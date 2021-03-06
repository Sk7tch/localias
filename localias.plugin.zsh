LOCALIAS_RECURSIVE=1
LOCALIAS_ALIAS_OVERRIDE=0

localias_clear()
{
  tmp_file="/tmp/localias.tmp"

  if [ -f $tmp_file ]; then
    unalias `cat $tmp_file | cut -d = -f 1 | tr "\n" " "` 2> /dev/null
    rm "$tmp_file"
  fi
}

localias_load()
{
  cdir=$1
  if [ $# -eq 0 ]; then
    cdir=$(pwd)
  fi

  localias="$cdir/.localias"
  tmp_file="/tmp/localias.tmp"

  if [ -f $localias ]; then
    alias_tab=()
    while IFS='' read -r line || [ -n "$line" ]; do
        alias_name=$(echo "$line" | cut -d = -f 1)
        alias_command=$(echo "$line" | cut -d = -f 2-99)
        if [ "$alias_name" != "" -a "$alias_command" != "" ]; then
           if [ $LOCALIAS_ALIAS_OVERRIDE ] && [ "$(command -v $alias_name)" ]; then
            (>&2 echo "$alias_name: is already an alias")
           else
            alias_tab=(${alias_tab[@]} "$alias_name=$alias_command")
           fi
        fi
    done < "$localias"
    if [ ! ${#alias_tab[@]} -eq 0 ]; then
      alias ${alias_tab[@]}
      echo ${(j:\n:)alias_tab} >> $tmp_file
    fi
  fi
  if [ $LOCALIAS_RECURSIVE ]; then
    newdir=$(echo $cdir | rev | cut -d / -f 2-99 | rev)
    if [ $newdir ]; then
      localias_load $newdir
    fi
  fi
}

localias()
{
  tmp_file="/tmp/localias.tmp"

  if [ -f $tmp_file ]; then
    while IFS='' read -r line || [ -n "$line" ]; do
      echo $line
    done < "$tmp_file"
  fi
}

localias_chpwd() {
  localias_clear
  localias_load
}

chpwd_functions+='localias_chpwd'
