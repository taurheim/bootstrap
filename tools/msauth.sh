#!/usr/bin/env bash
# Made by Niko Savas
# https://docs.microsoft.com/en-us/azure/devops/artifacts/npm/npmrc?view=vsts&tabs=new-nav%2Cwindows

echo 'This tool will help set up your .npmrc file to access VSTS in a similar way to msauth on windows'
echo 'NOTE: IT WILL WIPE YOUR .npmrc FILE SO BACK IT UP'
echo 'Enter your organization:'
read org
echo 'Enter your username:'
read username
echo 'Enter your email:'
read email
echo 'Enter your PAT token (https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=vsts):'
read PAT

feeds=()
# e.g. ISS
echo 'Enter a feed name:'
read feed
while [ "$feed" != "" ]
do
  feeds+=("$feed")
  echo 'Enter another feed name, or press enter to finish:'
  read feed
done

# Backup the npmrc
if [ -f ~/.npmrc ]
then
  if [ -f ~/.npmrc.bak ]
  then
    rm ~/.npmrc
  else
    mv ~/.npmrc ~/.npmrc.bak
  fi
fi

# print to npmrc
touch ~/.npmrc
for f in "${feeds[@]}"
do
  prefix="//pkgs.dev.azure.com/$org/_packaging/$f/npm/registry/"
  printf "$prefix:username=$username\n" >> ~/.npmrc
  printf "$prefix:_password=$PAT\n" >> ~/.npmrc
  printf "$prefix:email=$email\n" >> ~/.npmrc
  printf "$prefix:always-auth=true\n\n" >> ~/.npmrc
done
