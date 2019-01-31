install.packages("RMySQL")
library(RMySQL)
install.packages("lubridate")
library(lubridate)

setwd('YourPath')
getwd()
start_time <- Sys.time()
# Connect to MySQL database
db = dbConnect(MySQL(), 
               user='*****', 
               password='*******', 
               dbname='repository', 
               host='localhost')
# Import data generated from 01-data-acqu
commits <- read.csv("commits.csv", header=TRUE, quote ="",  fill=TRUE,
                    row.names = NULL, 
                    stringsAsFactors = FALSE, fileEncoding="UTF-8")


messages <- read.csv("messages.csv", header=TRUE, quote = "", 
                     row.names = NULL, 
                     stringsAsFactors = FALSE, fileEncoding = 'UTF-8')
files <- read.csv("files.csv", header=TRUE, quote = "", 
                  row.names = NULL, 
                  stringsAsFactors = FALSE, fileEncoding = 'UTF-8')
messages <- data.frame(messages$hash, messages$subject, messages$message)


# Prepare data for repo table
repo <- read.table('repos.list.txt', sep = '/', col.names = list( 'owner', 'project'))
repo <- cbind(id=1:nrow(repo), repo)
dbWriteTable(conn=db, name="repo", value=repo, overwrite=FALSE, append=TRUE, row.names=0)
# dbReadTable(db, 'repo')
commits$committer.timestamp
# Convert numeric/character timestamp to datetime
#commits$committer.timestamp <- anytime(as.numeric(commits$committer.timestamp))
Sys.setlocale("LC_TIME", "en_US.UTF-8")
commits$author.timestamp <- as.POSIXct(commits$author.timestamp, format="%a %b %d %H:%M:%S %Y")
commits$committer.timestamp <- as.POSIXct(commits$committer.timestamp, format="%a %b %d %H:%M:%S %Y")
# commits$author.timestamp

dbSendQuery(db,'ALTER DATABASE repository CHARACTER SET utf8 COLLATE utf8_general_ci;') 
dbSendQuery(db, 'SET NAMES utf8')
# Prepare dataframe for user table
author <- data.frame("name"=commits$author.name, "email"=commits$author.email)
committer <- data.frame("name"=commits$committer.name, "email"=commits$committer.email)
user <- rbind(author, committer)
user <- user[!duplicated(user), ] # Get unique tuple of (name, email) since they are composite primary keys
dbWriteTable(conn=db, name="user", value=user, overwrite=FALSE, append=TRUE, row.names=0)
# Prepare dataframe for commit table
commit_p1 <- data.frame("hash"=commits$hash, 
                        "author_date"=commits$author.timestamp, 
                        "committer_date"=commits$committer.timestamp, 
                        "author_name"=commits$author.name, 
                        "author_email"=commits$author.email, 
                        "committer_name"=commits$committer.name, 
                        "committer_email"=commits$committer.email, 
                        "repo_id"=commits$repo_id)
commit_p2 <- data.frame("hash"=messages$messages.hash, 
                        "subject"=messages$messages.subject, 
                        "message"=messages$messages.message)
commit <- merge(x=commit_p1, y=commit_p2, by="hash", all.y=TRUE)
dbWriteTable(conn=db, name="commit", value=commit, overwrite=FALSE, append=TRUE, row.names=0)

# Prepare dataframe for modification table
modification <- data.frame("id"=1:nrow(files), 
                           "number_deleted"=files$X.deleted., 
                           "number_added"=files$X.added., 
                           "hash"=files$X.hash. )
dbWriteTable(conn=db, name="modification", value=modification, overwrite=FALSE, append=TRUE, row.names=0)

end_time <- Sys.time()
cat("Running time: ", end_time - start_time, "seconds")







