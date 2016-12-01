mine() {
#
# kbingham: 2016
#
# fix ownership and permissions in homedir, prompting to retry as root if fail
#
# accepts one option,
#  '-c', as in "chatty"
#
local MINE MODOPTS QUIET OPTIND

# defaults
MODOPTS='-Rc'

# opts
getopts 'q' QUIET;shift $((OPTIND-1))
[[ "$QUIET" == 'q' ]] && {
  # configure commands to show changes
  MODOPTS=${MODOPTS/c/}
  
} || unset QUIET # nullify the '?' left by getopts

# try for each command line and sudo !! if fail
for MINE in \
  "chown $MODOPTS $USER:$USER $HOME 2>/dev/null" \
  "chmod $MODOPTS go-rwx $HOME 2>/dev/null" ;do
    { eval $MINE || \
      eval sudo --prompt=\"$0: ${MINE%2>*} requires \[sudo\] password for $USER:\" \
        ${MINE%2>*}
    } 2>&1 | /bin/less -n --no-init --QUIT-AT-EOF
done
}

