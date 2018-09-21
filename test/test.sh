#! /bin/zsh

ok_s="\e[32m.\e[0m"
ko_s="\e[31mKO\e[0m"

source ../localias.plugin.zsh
rm /tmp/localias.tmp 2> /dev/null

localias_end_test() {
  echo -n "\n$1"
  echo -e $ko_s
  exit 1
}

localias_tmp_file() {
  n=$(cat /tmp/localias.tmp 2> /dev/null | wc -l)
  if [ $1 -eq $n ]; then
    echo -en "$ok_s"
  else
    localias_end_test "Tmp file shoud have $1 entries/ has $n="
  fi
}

start_n=$(alias | wc -l)

cd toto_ls
localias_load
if [ "$(command -v toto)" ]; then
  echo -en "$ok_s"
  localias_tmp_file 1
else
  localias_end_test "It should load aliases="
fi

localias_clear
cd ../severals
localias_load
if [ "$(command -v a b c)" ]; then
  echo -en "$ok_s"
  localias_tmp_file 3
else
  localias_end_test "It should load several aliases="
fi


localias_clear
if [ ! "$(command -v toto)" ]; then
  echo -en "$ok_s"
  localias_tmp_file 0
else
  localias_end_test "It should clear aliases="
fi


cd ../recurs_1/recurs_2/recurs_3/
localias_load
nline=$(command -v rc1 rc2 rc3 | wc -l)
if [ "$nline" = "3" ]; then
  echo -en "$ok_s"
  localias_tmp_file 3
else
  localias_end_test "It should load several aliases="
fi
cd ../../..

localias_clear
cd ./recurs_1/recurs_2/
localias_load
nline=$(command -v rc1 rc2 rc3 | wc -l)
if [ "$nline" = "2" ]; then
  echo -en "$ok_s"
  localias_tmp_file 2
else
  localias_end_test "It should recursivly load aliases(2)="
fi
cd ../../


nline=$(localias | wc -l)
if [ "$nline" = "2" ]; then
  echo -en "$ok_s"
else
  localias_end_test "localias command should return aliases="
fi

localias_clear

cd toto_ls
alias toto=ls
localias_load 2> stderr.log
nline=$(cat stderr.log | wc -l)
if [ $nline = "1" ]; then
  echo -en "$ok_s"
else
  localias_end_test "It should raise error when overriding existing alias="
fi
rm stderr.log
unalias toto
localias_clear

nline=$(alias | wc -l)
if [ $nline = $start_n ]; then
  echo -ne $ok_s
else
  localias_end_test "It should have alias cleared="
  echo -e $ko_s
fi

cd ..
fn=$(echo $chpwd_functions | grep localias_chpwd | wc -l)
if [ $fn = "1" ]; then
  echo -e $ok_s
else
  localias_end_test "It should add function to chpwd="
  echo -e $ko_s
fi
