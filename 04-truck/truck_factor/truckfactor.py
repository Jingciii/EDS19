import mysql.connector
from mysql.connector import MySQLConnection, Error
from configparser import ConfigParser
import math
import pandas as pd
import numpy as np
import math
from datetime import datetime 
import sys

def read_db_config(filename='config.ini', section='mysql'):
    """ Read database configuration file and return a dictionary object
    :param filename: name of the configuration file
    :param section: section of database configuration
    :return: a dictionary of database parameters
    """
    # create parser and read ini configuration file
    parser = ConfigParser()
    parser.read(filename)
 
    # get section, default to mysql
    db = {}
    if parser.has_section(section):
        items = parser.items(section)
        for item in items:
            db[item[0]] = item[1]
    else:
        raise Exception('{0} not found in the {1} file'.format(section, filename))
 
    return db

def connect():
    """ Connect to MySQL database """
 
    db_config = read_db_config()
 
    try:
        print('Connecting to MySQL database...')
        conn = MySQLConnection(**db_config)
 
        if conn.is_connected():
            print('connection established.')
        else:
            print('connection failed.')
 
    except Error as error:
        print(error)
 
    finally:
        conn.close()
        print('Connection closed.')

# Fetch data line by line
def query_with_fetchone():
    try:
        dbconfig = read_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM repo")
 
        row = cursor.fetchone()
 
        while row is not None:
            print(row)
            row = cursor.fetchone()
 
    except Error as e:
        print(e)
 
    finally:
        cursor.close()
        conn.close()
 

# Fetch all data at once
def query_with_fetchall(query):
    try:
        dbconfig = read_db_config()
        conn = MySQLConnection(**dbconfig)
        cursor = conn.cursor()
        cursor.execute(query)
        rows = cursor.fetchall()
 
        print('Total Row(s):', cursor.rowcount)
       # for row in rows:
       #     print(row)
 
    except Error as e:
        print(e)
 
    finally:
        cursor.close()
        conn.close()
    return 

# Setting up finished


repo = query_with_fetchall("SELECT DISTINCT user, repo, repo_id FROM commit")
repo = pd.DataFrame(repo, columns = ['user', 'repo', 'id'])
external_list = False
try:
    repofile = sys.argv[1]
    with open(repofile, 'r') as f:
        repolist = f.readlines()
    external_list = True
except Exception as e:
    pass
if external_list:
    repo_id = []
    for f in repofile:
        u = f.split('/')[0]
        r = f.split('/')[1]
        i = repo.loc[(repo['user'] ==u)&(repo['repo'] == r)]
        i = int(i['id'])
        repo_id.append(i)
else:
    repo_id = repo['id'].tolist()
user = query_with_fetchall('SELECT author_name, author_email FROM commit')
user = pd.DataFrame(user, columns = ['name', 'email'])
user = user.drop_duplicates()

truckfactor = dict(zip(repo_id, [0 for i in repo_id]))
filenumber = dict(zip(repo_id, [0 for i in repo_id]))

begin = datetime.now() 

for id in truckfactor.keys():
    # Retrive the data relevant to chosen repository from database
    commit_query = "SELECT hash, author_name, author_date  FROM commit WHERE repo_id = " + str(id)
    file_query = "SELECT hash, addline, file_path FROM file WHERE repo_id = " + str(id)
    linguist_query = "SELECT file_path FROM linguistfile WHERE repo_id = " + str(id)
    commit = pd.DataFrame(query_with_fetchall(commit_query), columns = ['hash', 'author_name', 'author_date'])
    file = pd.DataFrame(query_with_fetchall(file_query), columns = ['hash', 'addline', 'file_path'])
    linguist = query_with_fetchall(linguist_query)
    linguist = [ling[0] for ling in linguist]
    linguist = pd.DataFrame(linguist, columns =['file_path'])
    
    # Filter the tables containing only the modification records related to source code file
    file = pd.merge(linguist, file, how='left', on='file_path')
    commit = pd.merge(file, commit, how='left', on='hash')
    commit = commit.dropna()
    # Calculate the number of source code files in chosen repository
    nfiles = len(set(commit['file_path']))
    filenumber[id] = nfiles
    # Define the contributors dictionary to record the number of files owned by each developer
    contributors = commit['author_name'].drop_duplicates()
    contributors = {k: [] for k in contributors}
    # Iterate through the chosen files to find the degree of authorship (DOA) of each contributor
    for f in set(commit['file_path']):
        # Select rows only relating to current file
        this_file = commit.loc[commit['file_path'] == f]
        # Author with earlest commit date time is regarded as the first author with FA = 1 while the rests with FA = 0
        if this_file.loc[this_file['author_date'] == max(this_file['author_date'])]['author_name'].tolist():
            FA = this_file.loc[this_file['author_date'] == max(this_file['author_date'])]['author_name'].tolist()[0]
        else:
            FA = 0
        # The total number of modifications (sum of lines added by the contributors)
        total_change = this_file[['addline']].sum()
        # Calculate the number of modifications by each contributor
        DL = this_file.groupby(['author_name'])[['addline']].sum()
        # AC: changes by other developers
        AC = total_change - DL
        # Calculation of DOA
        DOA = 3.293 + 0.164 * DL - 0.321 * np.log(1 + AC)
        DOA.loc[FA] += 1.098
        # Normalization
        DOA /= DOA['addline'].max()
        # Find authors of file f
        for author_name in DOA.index:
            if (DOA.loc[author_name] >= 0.75).bool():
                contributors[author_name].append(f)
    tf = 0
    nfilekept = nfiles
    contributors = sorted(contributors.items(), key = lambda x: len(x[1]))
    while nfilekept > nfiles / 2:
        if contributors:
            tf += 1
            contributors.pop()
            filekept = [x for path in contributors for x in path[1]]
            nfilekept = len(set(filekept))
        else:
            break
    truckfactor[id] = tf
    
end = datetime.now() 

running_time = (end - begin).seconds
print('Running time is ' + str(running_time))


T_F = {}
for k, v in truckfactor.items():
    row = repo.loc[repo['id'] == k]
    user = row['user'].to_string(index=False)
    proj = row['repo'].to_string(index=False)
    key = user + '/' + proj
    T_F[key] = v

with open('Truck_Factor.txt', 'w') as t_f:
    for k, v in T_F.items():
        t_f.write(str(k) + ': '+ str(v) + '\n\n')
