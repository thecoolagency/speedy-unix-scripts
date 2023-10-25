#!/bin/sh
#
#

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/homebrew/bin/gh:$PATH
export PATH

echo "##################################################### "
echo "######                                         ###### "
echo "######                 GH SETUP                ###### "
echo "######                                         ###### "
echo "##################################################### "

read -r account_or_organization_handle
read -r repository

gh repo set-default $account_or_organization_handle/$repository

read -r github_handle

git config --global github.user $github_handle