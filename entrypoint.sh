#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Please run with outliner [export|import] arguments"
  exit
fi

setup_git() {
  chmod 0400 "$HOME/.ssh/id_rsa"

  if [ -f "$HOME/.ssh/id_rsa" ]; then
    chmod 600 "$HOME.ssh/id_rsa"

    if [ ! -d "$HOME/.ssh/id_rsa.pub" ]; then
      ssh-keygen -y -f "$HOME/.ssh/id_rsa" > "$HOME/.ssh/id_rsa.pub"
    fi

    echo "[+] Using SSH key for git pushes"
  else
    echo "[E] Git credentials not available, quitting"
    exit 0
  fi
}

update_git_repo() {
  BRANCH=${GIT_BRANCH:-master}
  # Clone the branch in a temporary directory
  tmp_dir=$(mktemp -d)
  git clone "$GIT_REMOTE_URL" "$tmp_dir"
  cp -r "$1/*" "$tmp_dir/"
  cd "$tmp_dir" || exit 1
  git add .
  git commit -m "Updates: $(date)"
  git push origin "$BRANCH"
}

case $1 in
  export)
    shift
    bundle exec outliner-export "$@"

    if [ -z "$GIT_REMOTE_URL" ]; then
      echo "GIT_REMOTE_URL not set"
    else
      setup_git
      update_git_repo "$2"
    fi
    ;;
  import)
    shift
    bundle exec outliner-import "$@"
    ;;
  *)
    echo "Invalid command, please check README"
    ;;
esac
