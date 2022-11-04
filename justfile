_:
    @echo "moonfire 💨"
    @just -l -u

# Install poetry
install:
    poetry env use -- $(which python)
    poetry install

# Format Python
format:
    poetry run black app
    poetry run flake8 app

# Compile CSS
css:
    #!/bin/env bash
    cd app/tailwindcss
    npx tailwindcss -i ./styles/app.css -o ../static/css/app.css

# Run the webapp locally
run: format css
    MOONFIRE_URL="https://getluna.com" MOONFIRE_SLEEP=1 poetry run uvicorn app.main:app --reload

# Build the Docker image
build-docker:
    poetry export --without-hashes --format=requirements.txt > requirements.txt
    docker build -t moonfire .

# Run the webapp from the Docker image
run-docker:
    docker run -p 8000:80 --name moonfire --rm -e MOONFIRE_URL="https://getluna.com/" -e MOONFIRE_SLEEP=1 moonfire

# Deploy the AWS ECR
deploy-ecr:
    #!/bin/env bash
    export AWS_DEFAULT_REGION=us-east-1
    cd terraform/ecr
    terraform init
    terraform apply

# Push the Docker image to the ECR
push-docker:
    #!/bin/env bash
    cd terraform/ecr
    url=$(terraform output -raw repository_url)
    cd {{justfile_directory()}}
    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $url
    docker tag moonfire $url:latest
    docker push $url:latest

# Deploy the App
deploy-app:
    #!/bin/env bash
    export AWS_DEFAULT_REGION=us-east-1
    cd terraform/ecr
    url=$(terraform output -raw repository_url)
    cd {{justfile_directory()}}/terraform/app
    terraform init
    terraform apply -var repository_url=$url -var moonfire_url="https://getluna.com"
