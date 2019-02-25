#!/bin/bash

user="$1"
repo="$2"
repo_id="$3"
#repo_id=$(grep -n "${user}/${repo}" "$repos_list")


#repo_id=${repo_id:0:1}

#echo "repo_id is ${repo_id}"



url="https://github.com/${user}/${repo}.git"

git clone $url
./linguist_script.sh "${repo}"

# Copy the python file into repos's directory
cp messages_to_csv.py ./$repo
cp numstat_to_csv.py ./$repo
home=$(pwd)

cd ./$repo


filename="${user}_${repo}"

if [ ! -s "linguistfiles.log" ]
then
	cd "$home"
	rm -rf $repo
	echo "*** ${repo}'s repository has been removed..."
else

# Collect the repos data for commits.csv
#----------------------------------------

	git log --pretty=format:'"%H","%an","%ae","%ad","%cn","%ce","%ct"' | awk -v d="${user}" -F"," 'BEGIN { OFS = "," } {$8=d; print}' | awk -v d="${repo}" -F"," 'BEGIN { OFS = "," } {$9=d; print}' | awk -v d="${repo_id}" -F"," 'BEGIN { OFS = "," } {$10=d; print}' > ${filename}commit.csv

	echo "*** Commits info for ${repo} have been collected..."

	# Collect the repos data for messages.csv
	#----------------------------------------

	git log --pretty=format:"%H %s %B🐱" | iconv -t utf-8//IGNORE | python3 messages_to_csv.py | awk -v d="${repo_id}" -F"," 'BEGIN { OFS = "," } {$4=d; print}' > ${filename}message.csv

	echo "*** Messages info for ${repo} have been collected..."

	git config diff.renameLimit 999999

	# Collect the repos data for files.csv
	#-------------------------------------

	
	git log --pretty=format:🐱%n%H --numstat | iconv -t utf-8//IGNORE | python3 numstat_to_csv.py | awk -v d="${repo_id}" -F"," 'BEGIN { OFS = "," } {$5=d; print}' > ${filename}file.csv
	


	echo "*** File info for ${repo} have been collected..."

	# Collect the data of files selected by linguist library
	#-------------------------------------------------------

	awk -F"[;]" '{ print $2 }' ./linguistfiles.log | awk -v d="${user}" -F"," 'BEGIN { OFS = "," } {$2=d; print}' | awk -v d="${repo}" -F"," 'BEGIN { OFS = "," } {$3=d; print}' | awk -v d="${repo_id}" -F"," 'BEGIN { OFS = "," } {$4=d; print}' > ${filename}linguistfile.csv

	echo "*** Linguistfile info for ${repo} have been collected..."

	#---------------------------------------

	mv ${filename}commit.csv "$home"
	mv ${filename}message.csv "$home"
	mv ${filename}file.csv "$home"
	mv ${filename}linguistfile.csv "$home"

	# Return to the main directory
	cd "$home"

	mv ${filename}commit.csv  commit_metadata
	mv ${filename}message.csv commit_messages
	mv ${filename}file.csv commit_files
	mv ${filename}linguistfile.csv linguist_files

	rm -rf $repo
	echo "*** ${repo}'s repository has been removed..."
fi
