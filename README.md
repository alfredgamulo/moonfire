# moonfire

This project is built after the recruiting assignment from [prompt.md](prompt.md).

**This document outlines the development process for this project app.
For notes about take-home assignment, my general thoughts, and answers to the outstanding questions, please read the [NOTES.md](NOTES.md)**

## Bootstrapping the environment

These are my general terminal commands used to startup my dev environment for Python development:

```
brew install just pyenv openssl@3

echo 'eval "$(pyenv init --path)"' >> ~/.zprofile
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

env PYTHON_CONFIGURE_OPTS="--enable-shared" pyenv install 3.11
pyenv local 3.11

curl -sSL https://install.python-poetry.org | python3

cat << EOF > poetry.toml
[virtualenvs]
in-project = true
system-packages = true
EOF

poetry env use 3.11
poetry init # creates pyproject.toml
poetry install
```

Note: `just` is a cli tool for organizing scripts.
More info at https://github.com/casey/just.

___
**Thoughts:**
For this take-home project, I thought that the easiest way for me to make a simple webapp would be with using FastAPI. To add a little bit of flair, I added TailwindCSS.
___

```
npm install -D tailwindcss
npm install -D daisyui
npx tailwindcss init
```

## Running the webapp
Assuming that the user has `just` installed, a lot of the commands necessary to build and run the webapp are listed in the `justfile` at the root directory.

`just run` will start the uvicorn webapp on port 8000.
This process will also have a background task that pings a designated url for the smoke test. The environment variables that this project webapp accepts are:
* `MOONFIRE_URL`
* `MOONFIRE_METHOD`
* `MOONFIRE_HEADERS`
* `MOONFIRE_PARAMS`
* `MOONFIRE_DATA`
* `MOONFIRE_SLEEP`

The first five variables represent ways to configure the request that moonfire should smoke test. The last variable sets the sleep cycle for convenience.

___
**Thoughts:**
My reasoning for having these variables configurable through the environment is for deploying the container multiple times for the number of URLs being validated.
___

## Building the Docker image

`just build-docker` will build the included Dockerfile.

`just run-docker` is analogous to the `just run` command above, with the same environment variables set for the shortcut as well.

## Create ECR and push the Dockerfile to AWS
`just deploy-ecr` will run the terraform module to create the `moonfire` ECR to your AWS account.

`just push-docker` will push the built Docker image up to the newly created ECR.

## Create the AWS APP
`just deploy-app` will run the terraform module to create the `moonfire` app in ECS.
This command also prints out the `service_url` (the loadbalancer DNS) so that you can easily view the webapp as it is deployed in AWS.
