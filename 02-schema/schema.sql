DROP SCHEMA IF EXISTS repository;

CREATE SCHEMA IF NOT EXISTS  repository  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

CREATE TABLE IF NOT EXISTS repository.repo (
id      INTEGER     PRIMARY KEY, 
owner    VARCHAR(100)    NOT NULL, 
project   VARCHAR(100)    NOT NULL
);

CREATE TABLE IF NOT EXISTS   repository.user (
name            VARCHAR(100)      NOT NULL, 
email             VARCHAR(100)     NOT NULL, 
PRIMARY KEY (name, email)
) ; 

CREATE TABLE IF NOT EXISTS   repository.commit (
hash                    CHAR(40)         PRIMARY KEY, 
subject                 VARCHAR (255)        NOT NULL, 
message             VARCHAR(255)          NULL, 
author_date         DATETIME         NOT NULL, 
committer_date    DATETIME         NOT NULL, 
author_name        VARCHAR(100)         NOT NULL, 
author_email        VARCHAR(100)         NOT NULL, 
committer_name    VARCHAR(100)       NOT NULL, 
committer_email     VARCHAR(100)       NOT NULL, 
repo_id                   INTEGER    NOT NULL, 
FOREIGN KEY (author_name, author_email)  REFERENCES repository.user (name, email), 
FOREIGN KEY (committer_name, committer_email) REFERENCES repository.user (name, email),
FOREIGN KEY (repo_id)  REFERENCES repo (id)
) ;

CREATE TABLE IF NOT EXISTS  repository.modification (
id         INTEGER       AUTO_INCREMENT, 
number_deleted    INTEGER     NOT NULL, 
number_added          INTEGER    NOT NULL,
hash        CHAR      NOT NULL, 
 PRIMARY KEY (id), 
FOREIGN KEY (hash)  REFERENCES  repository.commit (hash)
);