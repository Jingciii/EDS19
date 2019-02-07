#!/bin/bash

user="$1"
repo="$2"
repos_list="$3"
repo_id=$(grep -n "${user}/${repo}" "$repos_list")


repo_id=${repo_id:0:1}

echo "repo_id is ${repo_id}"



url="https://github.com/${user}/${repo}.git"

git clone $url

# Copy the python file into repos's directory
cp messages_to_csv.py ./$repo
cp numstat_to_csv.py ./$repo
home=$(pwd)

cd ./$repo


filename="${user}_${repo}"

# Collect the repos data for commits.csv
#----------------------------------------

git log --pretty=format:'"%H","%an","%ae","%ad","%cn","%ce","%ct"' > commit_output.csv
awk -v d="$repo_id" -F"," 'BEGIN { OFS = "," } {$8=d; print}' commit_output.csv > ${filename}commit.csv

echo "*** Commits info for ${repo} have been collected..."

# Collect the repos data for messages.csv
#----------------------------------------

git log --pretty=format:"%H %s %B🐱" | iconv -t utf-8//IGNORE | python3 messages_to_csv.py > ${filename}message.csv

echo "*** Messages info for ${repo} have been collected..."

git config diff.renameLimit 999999

# Collect the repos data for files.csv
#-------------------------------------


git log --pretty=format:🐱%n%H --numstat| iconv -t utf-8//IGNORE | python3 numstat_to_csv.py > ${filename}file.csv

echo "*** File info for ${repo} have been collected..."

#---------------------------------------

mv ${filename}commit.csv "$home"
mv ${filename}message.csv "$home"
mv ${filename}file.csv "$home"

# Return to the main directory
cd "$home"


mv ${filename}commit.csv  commit_metadata
mv ${filename}message.csv commit_messages
mv ${filename}file.csv commit_files


rm -rf $repo
echo "*** ${repo}'s repository has been removed..."
