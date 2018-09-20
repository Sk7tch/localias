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
echo -n "It should clear aliases="
if [ ! "$(command -v toto)" ]; then
  echo -e $ok_s
else
  echo -e $ko_s
fi

alias toto=ls
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
