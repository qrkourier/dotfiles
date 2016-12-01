pw (){
  #
  # kbingham: 2016
  #
  # requires zero or one parameter
  # $1 = extended regex passed to pgrep
  #
  # prints processes and their children in like color for which the command or
  # arguments of the parent process matches an expression; prints $USER's
  # processes if none given;
  #
  local OPT OPTIND PGREP PID
  local -a HITS
  local PSOPTS='-ww -o user,pid,ppid,stime,tname,stat,cmd'

  [[ ${#@} -eq 0 ]] && {
    eval ps -u $USER $PSOPTS|while read;do
      echo -en "\e[38;5;$(($RANDOM % 256))m"
      echo $REPLY
      echo -en "\e[0m"
    done
    return
  } || {
    # in case of shell alias `pgrep` with problematic opts
    PGREP=$(which -a pgrep|egrep --color=never '^/.*bin.*/pgrep$'|head -1) && \
    [[ -x $PGREP ]] && \
     # list matching pids
     HITS=($($PGREP -f $@)) && \
      # return error if none
      [[ ${#HITS} -gt 0 ]] && \
       # for each do long print for parent and children
       for PID in ${HITS[@]};do
         echo -en "\e[38;5;$(($RANDOM % 256))m"
         eval ps $PSOPTS               --pid $PID && \
         eval ps $PSOPTS --no-headers --ppid $PID || return 1
         echo -en "\e[0m"
       done
  } || return 1
}

