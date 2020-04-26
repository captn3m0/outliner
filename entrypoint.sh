#!/bin/sh
set -eu
if [ $# -eq 0 ]; then
  echo "Please run with outliner [export|import|sync] arguments"
  exit
fi

setup_git() {
  if [ -f "$HOME/.ssh/id_rsa" ]; then
    # This is required because Kubernetes secret mounts can't
    # have file permissions set
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
    BRANCH=${GIT_BRANCH:-master}
    old_git_dir=$(mktemp -d)
    fresh_export_dir=$(mktemp -d)
    if [ -z "$GIT_REMOTE_URL" ]; then
      echo "[E] GIT_REMOTE_URL not set"
      exit 1
    else
      git clone --branch "$BRANCH" "$GIT_REMOTE_URL" "$old_git_dir"
      setup_git
      update_git_config
      echo "[+] Exporting data from Outline"
      bundle exec outliner-export "$fresh_export_dir"
      echo "[+] Resetting git repository"
      cd "$old_git_dir"
      # We update so that git forgets all files
      git ls-files -z |xargs -n1 -0 git rm
      # Then we copy across the files from the new export
      cd "$fresh_export_dir"
      echo "[+] Updating git repository"
      rsync -av . "$old_git_dir"
      cd "$old_git_dir"
      echo "[+] Committing to git"
      git add .
      git commit --message "Backup: $(date)" > /dev/null
      git status
      echo "[+] Pushing to git remote"
      git push origin "HEAD:$BRANCH"
      echo "[+] Cleaning up"
      rm -rf "$old_git_dir"
      rm -rf "$fresh_export_dir"
    fi
    ;;
  *)
    echo "Invalid command, please check README"
    ;;
esac
