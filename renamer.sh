#!/bin/bash

old="_template_"
new="$1"

projPath="../$new.Solution"

if [ -e "$projPath" ]
then
  echo "This project already exists"
  exit 1
elif [ "$#" -lt 1 ]
then
  echo "Please give a project name"
  exit 1
elif [ "$#" -gt 1 ]
then
  echo "Too many arguments"
  exit 1
fi

mkdir "$projPath"
currentDir="$(pwd)"
cd "$projPath"
projPath="$(pwd)"
cd "$currentDir"

rename()
{
  for file in *
  do
    if [ "$file" != "bin" ] && [ "$file" != "obj" ] && [ "$file" != ".git" ] && [ "$file" != "renamer.sh" ] && [ "$file" != "README.md" ]
    then
      newFile="${file/$old/$new}"
      if [ -d "$file" ]
      then
        cd "$file"
        local currentFile="$file"
        local currentNewfile="$newFile"
        local currentProjPath="$projPath"
        projPath="$projPath/$newFile"
        mkdir "$projPath" && echo "Creating directory $newFile in $currentProjPath"
        rename
        file="$currentFile"
        newFile="$currentNewfile"
        projPath="$currentProjPath"
        cd ..
      else
        sed "s/$old/$new/g" "$file" > "$projPath/$newFile" && echo "Creating file $newFile in $projPath"
      fi
      
    fi
  done
}

shopt -s dotglob
rename
shopt -u dotglob
