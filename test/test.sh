#! /bin/bash

ok_s="\e[32mOK\e[0m"
ko_s="\e[31mKO\e[0m"

source ../localias.plugin.zsh
shopt -s expand_aliases

cd toto_ls
localias_load
echo -n "It should load aliases="
if [ "$(command -v toto)" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi

localias_clear
cd ../severals
localias_load
echo -n "It should load several aliases="
if [ "$(command -v a b c)" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi

localias_clear
echo -n "It should clear aliases="
if [ ! "$(command -v toto)" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi


cd ../recurs_1/recurs_2/recurs_3/
localias_load
nline=$(command -v rc1 rc2 rc3 | wc -l)
echo -n "It should recursivly load aliases(1)="
if [ "$nline" == "3" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi
cd ../../..

localias_clear
cd ./recurs_1/recurs_2/
localias_load
nline=$(command -v rc1 rc2 rc3 | wc -l)
echo -n "It should recursivly load aliases(2)="
if [ "$nline" == "2" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi
cd ../../

nline=$(localias | wc -l)
echo -n "localias command should return aliases="
if [ "$nline" == "2" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi

localias_clear
nline=$(alias | wc -l)
echo -n "It should clear recursive aliases="
if [ $nline == "0" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi


alias toto=ls
cd toto_ls
localias_load 2> stderr.log
nline=$(cat stderr.log | wc -l)
echo -n "It should raise error when overriding existing alias="
if [ $nline == "1" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi
rm stderr.log
unalias toto
localias_clear

nline=$(alias | wc -l)
echo -n "It should have alias cleared="
if [ $nline == "0" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi

cd ..
fn=$(echo $chpwd_functions | grep localias_chpwd | wc -l)
echo -n "It should add function to chpwd="
if [ $fn = "1" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi
