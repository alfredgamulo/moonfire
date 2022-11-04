resource "aws_ecs_cluster" "moonfire" {
  name = "moonfire"
}

data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "moonfire" {
  name                  = "moonfire"
  assume_role_policy    = data.aws_iam_policy_document.ecs_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.moonfire.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "container" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  container_name               = "moonfire"
  container_image              = var.repository_url
  container_cpu                = 2048
  container_memory             = 8192
  container_memory_reservation = 4096

  port_mappings = [{
    containerPort = 80
    hostPort      = 80
    protocol      = "tcp"
  }]

  log_configuration = {
    logDriver = "awslogs",
    options = {
      "awslogs-group"         = "/fargate/tasks/moonfire",
      "awslogs-region"        = data.aws_region.current.name,
      "awslogs-stream-prefix" = "fargate",
    }
  }
  essential = true
  map_environment = {
    "MOONFIRE_URL" = var.moonfire_url,
  }
}

resource "aws_ecs_task_definition" "moonfire" {
  family                   = "moonfire"
  container_definitions    = module.container.json_map_encoded_list
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.moonfire.arn
  task_role_arn            = aws_iam_role.moonfire.arn
  cpu                      = 2048
  memory                   = 8192
  requires_compatibilities = ["FARGATE"]
}

resource "aws_cloudwatch_log_group" "task_logs" {
  name              = "/fargate/tasks/moonfire"
  retention_in_days = 90
}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "application_load_balancer" {
  name               = "moonfire"
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

resource "aws_lb_target_group" "target_group" {
  name        = "moonfire-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id
  health_check {
    matcher = "200,301,302"
    path    = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "moonfire" {
  name            = "moonfire"
  cluster         = aws_ecs_cluster.moonfire.id
  task_definition = aws_ecs_task_definition.moonfire.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.moonfire.family
    container_port   = 80
  }
}

output "service_url" {
  value = aws_alb.application_load_balancer.dns_name
}
