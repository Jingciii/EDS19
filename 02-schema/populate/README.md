# Database Schemata

Design and prototype a relational database schema



### Prerequisites

* R studio
* MySql 8.0.13



### Using the code

First, you must set your path in R script file (e.g, `../../02-schema/populate`. After that, move/copy the file generated from `01-data-acqu` along with a txt file storing the list of repositories you are interested into your work directory. Use your account name and passwork to connect R with MySQL in `store_data.R`. Finally, execute `store_data.R` and the targeted data would be imsert into the schema.

### Issues
 * Encoding issue:
 
 If dbWriteTable() raises error messages regarding invalid utf8/utf8mb4 character/string, you have to save the `.csv` files to `utf8` encoding. I recommand to open the files with [sublime](https://www.sublimetext.com/) and simply go to `File` --> `Save with Encoding` --> `UTF-8`, and then the files would be saved in utf8 encoding.



## Reference

[DBMS & SQL](https://www.studytonight.com/dbms/codd-rule.php)

[Copy data frames to database tables](http://web.mit.edu/~r/current/lib/R/library/DBI/html/dbWriteTable.html)
