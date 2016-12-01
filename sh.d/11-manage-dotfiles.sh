# function to recursively and non-destructively link in dotfiles 
rcupl (){
  #
  # kbingham: 2016
  #
  DEBUG=""
  test -d "$1" || { echo "Expects the link target dir as the first argument, bye"; return 1; }
  test -d "$2" || { echo "Expects the link location dir as the second argument, bye"; return 1; }
  # set the optional dotfile prefix accepting 'nil' to mean no prefix
  case "$3" in
    "") local RCPRE='.';;
 "nil") local RCPRE='';;
     *) local RCPRE="$3";;
  esac
  for RCTGT in $1/*;do 
    [[ $RCTGT == "$1/*" ]] && continue
    local RCLNK="$2/${RCPRE}$(basename $RCTGT)"
    # test whether the target is a directory
    if test -d "$RCTGT";then
      # make the corresponding link directory and a shortcut link sans prefix
      # (e.g., ./bin -> ./.bin)
      $DEBUG mkdir -pv "$RCLNK"
      $DEBUG ln -sTnv "$RCLNK" \
        "${RCLNK/\/$RCPRE$(basename $RCTGT)/\/$(basename $RCTGT)}" 2>/dev/null
    fi
    # test whether another file or intact link already exists
    if test -e "$RCLNK"; then
      # test whether the existing file is a link
      if test -L "$RCLNK";then
        # test whether the existing link already points to the intended target
        if test "$(readlink -f $RCTGT)" == "$(readlink -f $RCLNK)";then
          # skip to next RCTGT
          continue
        else
	  # if a link pointing elsewhere then assume it is a thoughtbot dotfile
	  # and create the expected local include variant
          RCLNK="${RCLNK}.local"
          $DEBUG ln -sfnv "$RCTGT" "$RCLNK"
        fi
      # test whether the existing file is a directory
      elif test -d "$RCLNK";then
        # recurse
        rcupl "$RCTGT" "$RCLNK" nil
      # if a regular file then warn
      else
        echo "not clobbering existing regular file $RCLNK" >&2
      fi
    else
      # if not exists or broken link then create the normal link
      $DEBUG ln -sfnv "$RCTGT" "$RCLNK"
    fi
  done
}
