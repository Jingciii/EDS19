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

echo '"hash","author name","author email","author timestamp",\
"committer name","committer email","committer timestamp"' > ${filename}commit.csv

git log --pretty=format:'"%H","%an","%ae","%ad","%cn","%ce","%ct"' >> ${filename}commit.csv

echo "*** Commits info for ${repo} have been collected..."

# Collect the repos data for messages.csv
#----------------------------------------

echo '"hash","subject","message"' > ${filename}message.csv

git log --pretty=format:"%H %s %B🐱" | python3 messages_to_csv.py >> ${filename}message.csv

echo "*** Messages info for ${repo} have been collected..."

git config diff.renameLimit 999999

# Collect the repos data for files.csv
#-------------------------------------

echo '"hash","added","deleted","file path"' > ${filename}file.csv

git log --pretty=format:🐱%n%H --numstat| python3 numstat_to_csv.py >> ${filename}file.csv

echo "*** File info for ${repo} have been collected..."

#---------------------------------------

mv ${filename}commit.csv "$home"
mv ${filename}message.csv "$home"
mv ${filename}file.csv "$home"

# Return to the main directory
cd "$home"

rm -rf $repo
echo "*** ${repo}'s repository has been removed..."
