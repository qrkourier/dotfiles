fall (){
#
# find everything that matches a pattern; dirs, files, lines from files,
# sources, executables, and manuals (kbingham: 2016)
#
#
## handle differences between shell interpreters; initialize a data strucuture
## for storing facts and configuration
local -A SHEBANG
# store the filename of the executable running this script
SHEBANG[bin]="$(basename $(readlink -f /proc/$$/exe))"
case "${SHEBANG[bin]}" in
  zsh5) setopt KSH_ARRAYS ;;
esac
#
## parameters
local EREPATTERN="$1" # escaped regex for which to search
local RECURSEPATH=("$2") # limit search scope to directory
[[ ! -d ${RECURSEPATH[0]:=$PWD} || ${#RECURSEPATH[*]} -gt 1 ]] && {
  echo "The second parameter is optional and must be a directory"
  return 1;
}
# - if the search path is a mere stop (.) then substitute the absolute path of
#   the present working directory so that `locate` does not print every indexed
#   file in the database
# - from here on we'll treat RECURSEPATH like a string, not a list, because we
#   know it has one value and ksh-emulation in bash and zsh support expanding an
#   array as the first element in a scalar context
[[ "$RECURSEPATH" == "." || "$RECURSEPATH" == "./" ]] && RECURSEPATH="$PWD/"
# enclose expression with parens if logical OR
[[ $EREPATTERN =~ '|' ]] && \
  EREPATTERN=$(sed 's/\(.*|.*\)/(\1)/g' <<< "$EREPATTERN")
#
## grep highlighting
# part of the line from a file or file name that matches the pattern
local MATCHEDSTR='02;91' # darker red
# the non-matching part of a line from a file
local SELECTEDLINE='01;35' # lavender
# full names of files which contain matching lines or that have
# basenames matching the pattern
local SELECTEDFILE='00;35' # darker lavender
# full names of dirs that have basenames matching the pattern
local SELECTEDDIR='01;94' # blue to be like LS_COLORS dirs
# defaults, Voltron-style
local GREP_COLORS="ms=${MATCHEDSTR}:sl=${SELECTEDLINE}:fn=${SELECTEDFILE}"
#export GREP_COLORS
#
# * print mans, bins, and srs with a bright color
# * print files from index with subdued color
# * print dir names like LS_COLORS
# * print file names like GREP_COLORS
# * print lines from files in RECURSEPATH or PWD like GREP_COLORS
# * print lines from compressed manuals like GREP_COLORS
# run as a group command so we can filter the output all at once
{
  #
  # search manuals, sources, and the executable path, 
  { if [[ -n "$RECURSEPATH" ]];then
    # optionally constrained to the given search path 
    for WHERE in \B \M \S; do
      eval whereis -${WHERE} "${RECURSEPATH}" -f "${EREPATTERN}" 
    done
  else
    # instead of the normal paths (e.g. PATH, MANPATH, etc...)
    whereis "${EREPATTERN}" 
  fi; } | /bin/egrep --color=always -i "${EREPATTERN}"
  #
  # print matches from the file index which may stale, but it's fast!; dump
  # stderr because it's unlikely to be meaningful 
  echo -e ".:\e[${SELECTEDFILE}mmlocate with LS_COLORS\e[0m:."
  locate --null --ignore-case \
   --regex "${RECURSEPATH:=$PWD/}.*$EREPATTERN([^/]+)?$" | \
    LS_COLORS="rs=$SELECTEDFILE:di=$SELECTEDDIR" \
     xargs --null --max-lines=11 --no-run-if-empty \
      /bin/ls -1d --color=always | GREP_COLORS="ms=${MATCHEDSTR}" \
       /bin/egrep --color=always -i "$EREPATTERN"
  #
  # also fast, find dirs with matching names; showing errors because the thing
  # you're looking for my be just a sandwich away, I mean a "sudo" away. 
  echo -e ".:\e[${SELECTEDDIR}mfind -type d\e[0m:."
  find ${RECURSEPATH:=$PWD} -type d -regextype egrep \
   -regex ".*${EREPATTERN}([^/]+)?$" | \
    GREP_COLORS="ms=${MATCHEDSTR}:sl=${SELECTEDDIR}" \
     /bin/egrep --color=always -i "${EREPATTERN}"
  #
  # slower, find files with matching names
  echo -e ".:\e[${SELECTEDFILE}mfind -type f\e[0m:."
  find ${RECURSEPATH:=$PWD/} -type f -regextype egrep \
   -regex ".*$EREPATTERN([^/]+)?$" | \
    GREP_COLORS="$GREP_COLORS:sl=$SELECTEDFILE" \
     /bin/egrep --color=always -i "$EREPATTERN"
  #
  # even slower, search recently accessed, non-binary files for matching lines
  echo -e ".:\e[${SELECTEDLINE}megrep\e[0m:."
  find ${RECURSEPATH:=$PWD/} -type f -atime -11 -print0 | \
   GREP_COLORS="$GREP_COLORS" xargs --null --max-lines=11 --no-run-if-empty \
    /bin/egrep --color=always -iI "$EREPATTERN"
  # slowest, search older non-binary files for matching lines
  find ${RECURSEPATH:=$PWD/} -type f -atime +11 -print0 | \
   GREP_COLORS="$GREP_COLORS" xargs --max-lines=11 --null --no-run-if-empty \
    /bin/egrep --color=always -iI "$EREPATTERN"
  #
  # page the output unless there is none
#} | less -nRe --no-init --QUIT-AT-EOF
#} | awk '!seen[$0]++' | less -nRe --no-init --QUIT-AT-EOF
} 2>/dev/null | awk '!seen[$0]++' | less -nRe --no-init --QUIT-AT-EOF
}

