#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Please run with outliner [export|import] arguments"
  exit
fi

case $1 in
  export)
    shift
    bundle exec outliner-export $@
    ;;
  import)
    shift
    bundle exec outliner-import $@
    break
    ;;
  *)
    echo "Invalid command, please check README"
    ;;
esac
