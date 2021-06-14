function setup_pyenv() {
  export PYENV_ROOT="$HOME/.pyenv"
  if [[ ! -d "${PYENV_ROOT}" ]]; then
    git clone https://github.com/pyenv/pyenv.git "${PYENV_ROOT}"
  fi
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
}

function setup_pyenv_virtualenv() {
  DIR=$(pyenv root)/plugins/pyenv-virtualenv
  if [[ ! -d "${DIR}" ]]; then
    git clone https://github.com/pyenv/pyenv.git "${DIR}"
  fi
  eval "$(pyenv virtualenv-init -)"
}
