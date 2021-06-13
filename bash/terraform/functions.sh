function setup_tfenv() {
  rm -rf "${HOME}/.tfenv"
  git clone https://github.com/tfutils/tfenv.git "${HOME}/.tfenv"
  ln -fs "${HOME}/.tfenv/bin"/* "${HOME}/.local/bin"
  tfenv install
}

function update_terraform_version() {
  tfenv list-remote |
    head -n 1 \
      >"${GITHUB_WORKSPACE}/.terraform-version"
}
