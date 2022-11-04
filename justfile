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

run: format
    poetry run uvicorn app.main:app --reload
