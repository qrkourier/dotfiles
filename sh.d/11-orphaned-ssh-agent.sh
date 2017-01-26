agent (){
# function to reconnect the ssh agent socket in screen or tmux; expects zero
# parameters; finds your orphaned sockets and sets a variable pointer and
# prints found keys
[[ "$SSH_AUTH_SOCK" ]] && {
  ssh-add -L
} || {
  export SSH_AUTH_SOCK=$(
    find /tmp/ssh-* -user $USER -name agent\* -printf '%T@ %p\n' 2>/dev/null | \
     sort -k 1nr | sed 's/^[^ ]* //' | head -n 1
  )
  [[ -z "$SSH_AUTH_SOCK" ]] && {
    echo "no orphaned sockets were discovered, bye"
    return 1
  }
}
}

