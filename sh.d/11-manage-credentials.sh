
export ASSUME='-n <arn of role to assume, if any>'

credvers() {
  #
  # kbingham: 2016
  #
  # accepts three parameters and will prompt if first is not given; prints all
  # versions if second and third are not given
  #
  # $1 = the principal or key with which the value will be associated
  # $2 = an integer matching a version with or without zero padding 
  # $3 = maximum number of versions to print (defaults to 1 if $2)
  #
  # print all versions unless otherwise specified in $3
  local GOT VERSION MAXVERS=-1 
  # prompt for and set 1 the principal in $1 unless given
  [[ $# -eq 0 ]] && {
    echo -n "Enter principal to list versions > ";read -r
    set -- $REPLY;
  }
  # set the version to print and max to print to 1 if $2, otherwise let version equal 1
  [[ $# -ge 2 ]] && {
    MAXVERS=1
    VERSION=$2
  }
  # print at most $3 versions, otherwise print all
  [[ $# -eq 3 ]] && {
    MAXVERS=$3
  }
  # start at version 1 unless $2
  : ${VERSION:=1}
  # increment and interate until a version is not found or MAXVERS decrements
  # to exactly 0
  while [[ $MAXVERS -gt 0 || $MAXVERS -lt 0 ]] && GOT=$(credstash $ASSUME get $1 \
    -v$(printf '%019d' $VERSION) 2>/dev/null); do
      printf '%019d: %s\n' $VERSION $GOT;
      let VERSION++
      let MAXVERS--
  done
}

credput() {
  #
  # kbingham: 2016
  #
  # accepts one parameter and will prompt if not given; if the credential
  # already exists then the new secret is stored with an auto incremented
  # version number
  # $1 = the principal or key with which the value will be associated
  [[ $# -eq 0 ]] && {
      echo -n "Enter principal to put > ";read -r
      set -- $REPLY;
  }
  echo -n "Enter credential to store as '$1' (invisible) > ";read -sr
  credstash $ASSUME put $1 $REPLY -a
}

