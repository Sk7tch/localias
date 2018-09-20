localias_clear()
{
  tmp_file="/tmp/localias.tmp"

  if [ -f $tmp_file ]; then
    while IFS='' read -r line || [ -n "$line" ]; do
      unalias $(echo "$line" | cut -d = -f 1) 2> /dev/null
    done < "$tmp_file"
    rm "$tmp_file"
  fi
}

localias_load()
{
  localias=".localias"
  tmp_file="/tmp/localias.tmp"

  if [ -f $localias ]; then
    while IFS='' read -r line || [ -n "$line" ]; do
        alias_name=$(echo "$line" | cut -d = -f 1)
        alias_command=$(echo "$line" | cut -d = -f 2-99)
        if [ "$alias_name" != "" -a "$alias_command" != "" ]; then
           if [ "$(command -v $alias_name)" ]; then
            (>&2 echo "$alias_name: is already an alias")
           else
            alias $alias_name="$alias_command"
            echo "$alias_name=$alias_command" >> "$tmp_file"
           fi
        fi
    done < "$localias"
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
