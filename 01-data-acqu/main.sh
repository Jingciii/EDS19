#!/bin/bash

start=`date +%s`

read -p "Enter the repos list collect data from: " repos_list

echo "$repos_list"

home=$(pwd)

repo_num=`awk 'END{print NR}' "$repos_list"`

splitlines=$(( repo_num/10 ))
split -l $splitlines "$repos_list"

for repos in xa* ; do {
#for x in ` awk '{print}' $repos `
for x in ` cat $repos ` 
{
user="$(cut -d'/' -f1 <<<"$x")"
repo="$(cut -d'/' -f2 <<<"$x")"
bash git_log.sh "$user" "$repo"
} 
} & done

wait

echo "Done!"

# Put all the files together
cat *.csv > commits.csv
cat *.csv > messages.csv
cat *.csv > files.csv

end=`date +%s` 

#remove useless files
rm *commit.csv
rm *message.csv
rm *file.csv
rm xa*

# Calculate disk space taken
echo "The disk space taken up: "
echo $(du -sh commits.csv)
echo $(du -sh messages.csv)
echo $(du -sh files.csv)

dif=$[ end - start ]

echo "RunTime: $dif seconds"