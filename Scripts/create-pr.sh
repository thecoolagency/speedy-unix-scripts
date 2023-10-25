#!/bin/sh
#
#

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/homebrew/bin/gh:$PATH

echo "##################################################### "
echo "######                                         ###### "
echo "######              GH PR CREATE               ###### "
echo "######                                         ###### "
echo "##################################################### "

# current branch name in lowercase
branch_name=$(git branch --show-current | tr '[:upper:]' '[:lower:]')

# get the remote URL for the current branch
remote_url=$(git config --get remote.origin.url)

# extract the repository name from the remote URL
repo_name=$(basename -s .git "$remote_url" | sed 's/\.git$//')

# extract the owner/username from the remote URL
owner_name=$(basename "$(dirname "$remote_url")")

echo "branch_name: $branch_name"
echo "repo_name: $repo_name"
echo "owner_name: $owner_name"

echo "$(date +'%Y-%m-%d %H:%M:%S') - setting vars..."

# do not edit
reviewer="jonahtc"
# assignee get's your user from .gitconfig in your home folder
assignee="$(git config github.user)"

# enter
existing_labels=$(gh label list --repo "$owner_name/$repo_name" | awk '{printf "%s,",$1}' | sed 's/,$//')

echo "Enter labels (comma-separated, no spaces), only use: $existing_labels"
read -r labels

# initialize labels_exist variable
labels_exist=false

while [ "$labels_exist" = false ]; do
    # use GitHub CLI to list labels on the repository
    existing_labels=$(gh label list --repo "$owner_name/$repo_name" | awk '{print $1}')

    # check if all provided labels exist in the existing labels
    labels_exist=true

    IFS=',' read -ra label_array <<< "$labels"
    for label in "${label_array[@]}"; do
        if ! echo "$existing_labels" | grep -q "$label"; then
            labels_exist=false
            echo "Label '$label' does not exist on the repository."
        fi
    done

    if [ "$labels_exist" = false ]; then
        # re prompt the user to enter labels separated by commas
        echo "Enter labels (comma-separated):"
        read -r labels
    fi
done

echo "Enter the target branch (press enter for default: dev):"
read -r target_branch

# default to "dev" if the user didn't input anything
if [ -z "$target_branch" ]; then
    target_branch="dev"
fi

# prompt the user for a PR description
echo "Generating PR description..."

# generate a list of commits with links in markdown
commits_with_links=$(git log --oneline --abbrev-commit --format="- [%s](<link_to_commit>)")

echo "Enter a preview link:"
read -r preview_link
preview_link="[Preview]($preview_link)"

echo "Enter an Asana link:"
read -r asana_link
asana_link="[$asana_link]($asana_link)"

# create the PR description
description="## Description:

$commits_with_links

## Preview:

$preview_link

## Asana:

$asana_link"

pr_url=$(gh pr create --base "$target_branch" --head "$branch_name" --title "$branch_name" --body "$description" --reviewer "$reviewer" --assignee "$assignee" --label "$labels" | grep -o 'https://github.com/.*/pull/[0-9]\+')

# if pr went through open in browser
if [ -n "$pr_url" ]; then
    echo "Pull Request created successfully!"
    echo "Opening the PR link in your web browser..."
    open "$pr_url"
else
    echo "Failed to create the Pull Request."
fi