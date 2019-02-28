DROP SCHEMA IF EXISTS truck_factor;

CREATE SCHEMA IF NOT EXISTS  truck_factor  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

CREATE TABLE IF NOT EXISTS   truck_factor.commit (
hash                   CHAR(40)       PRIMARY KEY, 
author_name      VARCHAR(100)   NOT NULL, 
author_email       VARCHAR(100)      NULL,
author_date         DATETIME          NULL, 
committer_name       VARCHAR(100)     NOT NULL,
committer_email         VARCHAR(100)      NULL,
committer_date    DATETIME         NULL, 
user            VARCHAR(100)        NOT NULL ,
repo            VARCHAR(100)       NOT NULL,
repo_id                   INTEGER    NOT NULL
) ;


CREATE TABLE IF NOT EXISTS   truck_factor.file(
hash        CHAR(40)      NOT NULL, 
addline      INTEGER(11)     NOT NULL  DEFAULT 0,
deleteline     INTEGER(40)    NOT NULL   DEFAULT  0,
file_path    VARCHAR(255)    NOT NULL,
repo_id     INTEGER(11)  NOT NULL,
PRIMARY KEY (hash, file_path)
);


CREATE TABLE IF NOT EXISTS   truck_factor.linguistfile(
file_path    VARCHAR(255)     PRIMARY KEY, 
user        VARCHAR(100)  NOT NULL, 
repo    VARCHAR(100) NOT NULL, 
repo_id     INTEGER(11)    NOT NULL
);

use truck_factor;

LOAD DATA LOCAL INFILE '..yourpath/EDS19/04-truck/data-acqu/commit_metadata/commits.csv' 
INTO TABLE `commit` 
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n' 
 IGNORE 1 ROWS 
 (@hash, @author_name,@author_email, @author_date, @committer_name, @committer_email, @committer_date,  user, repo, repo_id)
 SET hash = REPLACE(@hash, '"', ''),
 author_name = REPLACE(@author_name, '"', ''), author_email = REPLACE(@author_email, '"', ''),
 author_date  = STR_TO_DATE(REPLACE(@author_date, '"', ''), '%a %b %e %H:%i:%s %Y'), 
 committer_name = REPLACE(@committer_name, '"', ''), committer_email = REPLACE(@committer_email, '"', ''),
 committer_date = from_unixtime(REPLACE(@committer_date, '"', ''));

LOAD DATA LOCAL INFILE '..yourpath/EDS19/04-truck/data-acqu/commit_files/files.csv' 
INTO TABLE `file` 
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n' 
 IGNORE 1 ROWS 
 (@hash, addline, deleteline, @file_path, repo_id)
 SET hash = REPLACE(@hash, '"', ''), file_path = REPLACE(@file_path, '"', '');
 
LOAD DATA LOCAL INFILE '..yourpathEDS19/04-truck/01-data-acqu/linguist_files/linguistfiles.csv' 
INTO TABLE `linguistfile` 
FIELDS TERMINATED BY ','
 LINES TERMINATED BY '\n' 
 IGNORE 1 ROWS 
 (file_path, user, repo, repo_id);
 
