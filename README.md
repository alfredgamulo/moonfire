# moonfire

## Bootstrapping Python

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

---
**Thoughts:**
For this take-home project, I thought that the easiest way for me to make a simple webapp would be with using FastAPI
___
