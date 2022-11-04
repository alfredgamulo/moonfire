_:
    @echo "moonfire 💨"
    @just -l -u

# Install poetry
install:
    poetry env use -- $(which python)
    poetry install

format:
    poetry run black app
    poetry run flake8 app

css:
    #!/bin/env bash
    cd app/tailwindcss
    npx tailwindcss -i ./styles/app.css -o ../static/css/app.css

run: format css
    poetry run uvicorn app.main:app --reload
