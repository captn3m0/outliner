#!/bin/sh
set -eu

if [ $# -eq 0 ]; then
  echo "Please run with outliner [export|import] arguments"
  exit
fi

setup_git() {
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    chmod 0400 "$HOME/.ssh/id_rsa"

    if [ ! -d "$HOME/.ssh/id_rsa.pub" ]; then
      ssh-keygen -y -f "$HOME/.ssh/id_rsa" > "$HOME/.ssh/id_rsa.pub"
    fi
    echo "[+] Using SSH key for git pushes"
  else
    echo "[E] Git credentials not available, quitting"
    exit 1
  fi

  eval $(ssh-agent)
  ssh-add "$HOME/.ssh/id_rsa"
}

update_git_config() {
  EMAIL=${GIT_EMAIL:-outliner@example.invalid}
  git config --global user.email "$EMAIL"
  git config --global user.name "Outliner Backup"
  git remote add origin "$GIT_REMOTE_URL"
}

case $1 in
  export)
    shift
    bundle exec outliner-export "$@"
    ;;
  import)
    shift
    bundle exec outliner-import "$@"
    ;;
  sync)
    tmp_dir=$(mktemp -d)
    if [ -z "$GIT_REMOTE_URL" ]; then
      echo "[E] GIT_REMOTE_URL not set"
      exit 1
    else
      setup_git
      bundle exec outliner-export "$tmp_dir"
      cd "$tmp_dir"
      git init
      update_git_config
      git add .
      git commit --message "Backup: $(date)"
      BRANCH=${GIT_BRANCH:-master}
      git checkout -b "$BRANCH"
      git push origin --force "$BRANCH"
    fi
    ;;
  *)
    echo "Invalid command, please check README"
    ;;
esac
