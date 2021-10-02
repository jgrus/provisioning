#!/bin/bash -e

echo Installing ssh server
sudo apt install openssh-server
echo Importing SSH keys from github profile
ssh-import-keys gh:jgrus

