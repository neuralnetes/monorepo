#!/bin/bash
cat <<EOF > "${HOME}/.gitconfig"
[user]
	name = ${GITHUB_USER_NAME}
	email = ${GITHUB_USER_EMAIL}
[core]
	editor = \$EDITOR
EOF
