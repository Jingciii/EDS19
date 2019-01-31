DROP SCHEMA IF EXISTS repository;


CREATE SCHEMA IF NOT EXISTS  repository; 

CREATE TABLE IF NOT EXISTS repository.repo (
id      INTEGER     PRIMARY KEY, 
owner    CHAR(100)    NOT NULL, 
project   CHAR(100)    NOT NULL
);


CREATE TABLE IF NOT EXISTS   repository.user (
name            CHAR(100)      NOT NULL, 
email             CHAR(100)     NOT NULL, 
PRIMARY KEY (name, email)
) ; 

CREATE TABLE IF NOT EXISTS   repository.commit (
hash                    CHAR(40)         PRIMARY KEY, 
subject                 CHAR (255)        NOT NULL, 
message             CHAR(255)          NULL, 
author_date         DATETIME         NOT NULL, 
committer_date    DATETIME         NOT NULL, 
author_name        CHAR(100)         NOT NULL, 
author_email        CHAR(100)         NOT NULL, 
committer_name    CHAR(100)       NOT NULL, 
committer_email     CHAR(100)       NOT NULL, 
repo_id                   INTEGER    NOT NULL, 
FOREIGN KEY (author_name, author_email)  REFERENCES repository.user (name, email), 
FOREIGN KEY (committer_name, committer_email) REFERENCES repository.user (name, email),
FOREIGN KEY (repo_id)  REFERENCES repo (id)
) ;





CREATE TABLE IF NOT EXISTS  repository.modification (
id         INTEGER     PRIMARY KEY, 
number_deleted    INTEGER     NOT NULL, 
number_add          INTEGER    NOT NULL,
hash        CHAR      NOT NULL, 
FOREIGN KEY (hash)  REFERENCES  repository.commit (hash)
);