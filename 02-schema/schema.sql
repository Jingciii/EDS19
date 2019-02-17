DROP SCHEMA IF EXISTS repository;

CREATE SCHEMA IF NOT EXISTS  repository  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

CREATE TABLE IF NOT EXISTS repository.repo (
id      INTEGER     PRIMARY KEY, 
owner   VARCHAR(100)    NOT NULL, 
project   VARCHAR(100)   NOT NULL
);



CREATE TABLE IF NOT EXISTS   repository.user (
id                  INTEGER   NOT NULL,
name            VARCHAR(100)      NOT NULL, 
email             VARCHAR(100)     NOT NULL, 
PRIMARY KEY (id)
) ; 

CREATE TABLE IF NOT EXISTS   repository.commit (
hash                   CHAR(40)       PRIMARY KEY, 
subject                 VARCHAR (255)         NOT NULL, 
message             VARCHAR (255)         NULL, 
author_date         DATETIME         NOT NULL, 
committer_date    DATETIME        NOT NULL, 
author_id              INTEGER     NOT NULL,
committer_id          INTEGER     NOT NULL,
repo_id                   INTEGER    NOT NULL, 
FOREIGN KEY (author_id)  REFERENCES repository.user (id), 
FOREIGN KEY (committer_id) REFERENCES repository.user (id),
FOREIGN KEY (repo_id)  REFERENCES repository.repo (id)
) ;



CREATE TABLE IF NOT EXISTS  repository.modification (
number_deleted    INTEGER     NOT NULL, 
number_add          INTEGER    NOT NULL,
file_path                 CHAR(255)         NOT NULL,
hash                      CHAR(40)     NOT NULL, 
FOREIGN KEY (hash)  REFERENCES  repository.commit (hash),
PRIMARY KEY (hash, file_path)
);