#!/bin/bash

start=`date +%s`

read -p "Enter the repos list collect data from: " repos_list

echo "$repos_list"

home=$(pwd)

function prepare_directories {
    mkdir -p commit_metadata
    mkdir -p commit_files
    mkdir -p commit_messages
}

prepare_directories

repo_num=`awk 'END{print NR}' "$repos_list"`

splitlines=$(( repo_num/8 ))
split -l $splitlines "$repos_list"


for repos in xa* ; do {
#for x in ` awk '{print}' $repos `
for x in ` cat $repos ` 
{
user="$(cut -d'/' -f1 <<<"$x")"
repo="$(cut -d'/' -f2 <<<"$x")"
bash git_log.sh "$user" "$repo" "$repos_list"
} 
} & done

wait

echo "Done!"


end=`date +%s` 

# Put all the files together
# And remove useless files
cd commit_metadata
echo '"hash","author name","author email","author timestamp","committer name","committer email","committer timestamp","repo_id"' > commits.csv
cat *commit.csv >> commits.csv
rm *commit.csv
cd "$home"
cd commit_messages
echo '"hash","subject","message"' > messages.csv
cat *message.csv >> messages.csv
rm *message.csv
cd "$home"
cd commit_files
echo '"hash","added","deleted","file path"' > files.csv
cat *file.csv >> files.csv
rm *file.csv
cd "$home"
rm xa*


# Calculate disk space taken
echo "The disk space taken up: "
cd commit_metadata
echo $(du -sh commits.csv)
cd "$home"/commit_messages
echo $(du -sh messages.csv)
cd "$home"/commit_files
echo $(du -sh files.csv)

dif=$[ end - start ]

echo "RunTime: $dif seconds"
