
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize todo:zsh

# reading the manual can be easier on the eyes
MANWIDTH=111

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

ALWAYSTRYCOLOR=yes
if [[ "${ALWAYSTRYCOLOR:=no}" == yes ]]; then
    if [[ -x "$(which tput)" ]] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# initialize a data strucuture for storing facts and configuration for this
# interpreter
typeset -A SHEBANG

# store the filename of the executable running this script
SHEBANG[bin]="$(basename $(readlink -f /proc/$$/exe))"

if [[ "${SHEBANG[bin]}" == "bash" ]];then
  if [[ "$color_prompt" == "yes" ]]; then
    PS1='\[\e[01;32m\]\h\[\e[00m\]:'
    PS1+='\[\e[01;34m\]\W\[\e[00m\]:'
    PS1+='\[\e[01;34m\]$?\[\e[00m\] $ '
  else
    PS1='\h:\w:$? $ '
  fi
fi
unset color_prompt ALWAYSTRYCOLOR

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# configure default on and 'n' as in "no" as in "off" prefix color for commands
# that support the --color=always|never|auto conventions; these need to be
# sourced after setting up the literal aliases so that these can be
# appended to those alias definitions; this is to ensure the base command has
# the color options, not all aliased variant forms of the commands which should
# probably call the anchor 

# store the name of the aliases associative array for this shell
case ${SHEBANG[bin]} in
   bash) SHEBANG[aliases]="BASH_ALIASES"
       ;;
   zsh5) SHEBANG[aliases]="aliases"
       ;;
esac

# create color on/off aliases for common commands (e.g., ls for on, nls for off)
for NAME in {e,r,o,v,s,x,}grep ls nmcli watch;do
  # refer to self if not defined
  for ALT in {,n}${NAME};do
    [[ -z "$(eval echo \${${SHEBANG[aliases]}[$ALT]})" ]] && {
      eval ${SHEBANG[aliases]}[$ALT]=\"$NAME\" 
    }
  done
  case $NAME in
    *grep|ls) 
      COLORON='--color=always'
      NOCOLOR='--color=never'
      ;;
    nmcli)
      COLORON='-colors yes'
      NOCOLOR='-colors no'
      ;;
    watch)
      # include a trailing space so that aliases called by watch will be
      # expanded in `sh -c` params passed by watch
      COLORON='--color '
      NOCOLOR=' '
      ;;
    *) echo "no color options found for $NAME" >&2
       unset COLORON NOCOLOR
      ;;
  esac
  eval ${SHEBANG[aliases]}[$NAME]+=\" $COLORON\" # bash and zsh5 work
  eval ${SHEBANG[aliases]}[n${NAME}]+=\" $NOCOLOR\" # bash and zsh5 work
  #eval echo \"$NAME = \${${SHEBANG[aliases]}[$NAME]}\"
  #aliases[$NAME]="${aliases[$NAME]} --color=always"  # zsh5 works
  #eval aliases[$NAME]=\"${aliases[$NAME]} --color=always\" # zsh5 works
  #eval ${SHEBANG[aliases]}[$NAME]=\"${aliases[$NAME]} --color=always\" # zsh5 works
  unset COLORON NOCOLOR
done


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# override the default terminfo set by Ubuntu Xenial because it results in an
#+ error when using SSH to a remote host that does not support the new string
alias ssh='TERM=xterm-256color ssh'

palette4(){
#!/bin/bash
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
#Background
for clbg in {40..47} {100..107} 49 ; do
  #Foreground
  for clfg in {30..37} {90..97} 39 ; do
    #Formatting
    for attr in {0..7} ; do
      #Print the result
      echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
    done
    echo #Newline
  done
done

# kb: scraped this second one from somewhere and fixed it up a bit
T='gYw'   # The test text
for BGs in {40..47}m; do printf '%s%.0s' $BGs {1..5};done # headers
for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m'                    \
           '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m'                    \
           '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m'                    ;
  do FG=${FGs// /}
  echo -en " $FGs \033[$FG  $T  "
  for BG in {40..47}m; do 
    echo -en "$EINS \033[$FG\033[$BG  $T \033[0m\033[$BG \033[0m";
  done
  echo;
done
echo

}

palette8(){
#!/bin/bash
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.
for fgbg in 48 38 ; do #Foreground/Background
  for color in {0..256} ; do #Colors
    #Display the color
    echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
    #Display 10 colors per lines
    if [ $((($color + 1) % 10)) == 0 ] ; then
      echo #New line
    fi
  done
  echo #New line
done
}

