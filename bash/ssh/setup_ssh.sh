mkdir -p "${HOME}/.ssh"
ssh-keyscan github.com >> "${HOME}/.ssh/known_hosts"
echo "${SSH_PRIVATE_KEY}" > "${HOME}/.ssh/id_rsa"
chmod 600 "${HOME}/.ssh/id_rsa"
ssh-agent -a "${SSH_AUTH_SOCK}" > /dev/null
ssh-add "${HOME}/.ssh/id_rsa"
