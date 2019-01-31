#!/bin/bash


user="$1"

repo="$2"

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

git log --pretty=format:'"%H","%an","%ae","%ad","%cn","%ce","%ct"' > ${filename}commit.csv

#retrieve_commit_metadata > "${home}/commit_metadata/${filename}"

echo "*** Commits info for ${repo} have been collected..."

# Collect the repos data for messages.csv
#----------------------------------------

git log --pretty=format:"%H %s %B🐱" | python3 messages_to_csv.py > ${filename}message.csv

#retrieve_commit_message_info > "${home}/commit_messages/${filename} "

echo "*** Messages info for ${repo} have been collected..."

git config diff.renameLimit 999999

# Collect the repos data for files.csv


git log --pretty=format:🐱%n%H --numstat| python3 numstat_to_csv.py > ${filename}file.csv

#retrieve_commit_file_modification_info > "${home}/commit_files/${filename}"

echo "*** File info for ${repo} have been collected..."


mv ${filename}commit.csv "$home"
mv ${filename}message.csv "$home"
mv ${filename}file.csv "$home"

cd "$home"

mv ${filename}commit.csv  commit_metadata
mv ${filename}message.csv commit_messages
mv ${filename}file.csv commit_files

rm -rf $repo
echo "*** ${repo}'s repository has been removed..."
