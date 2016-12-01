
# switch to zsh if available and interactive shell, otherwise bail out
case $- in
  *i*) [[ -x /usr/bin/zsh ]] && \
       exec /usr/bin/zsh $@ ;;
    *) return;;
esac

# glob-order source rc files 
RCS+=(~/sh.d/*.sh)
RCS+=(~/bash.d/*.sh)
for RC in ${RCS[*]};do 
  test -s $RC && { file --dereference --mime $RC | \
    egrep -q 'text/(x-shellscript|plain)'; } && {
      source $RC;
    } || {
      echo -e "\e[1;49;31m ERROR: \e[0m$RC" >&2 ;
    }
done
unset RCS

# rvm insists on being first in the path search?
#stackPath "~/.rvm/bin" # Add RVM to PATH for scripting
for RVMRC in ~/.rvm/scripts/rvm;do # configure ruby version manager 
  test -s $RVMRC && source $RVMRC
done

### Added by the Heroku Toolbelt
#stackPath "/usr/local/heroku/bin"

