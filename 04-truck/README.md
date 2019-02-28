# Truck Factor

This assignment is to implement the calculation process of Truck Factor as in [this paper](https://peerj.com/preprints/1233.pdf)

## Getting Started


### Prerequisites

* Python 3.6.5

		* pandas
		* numpy
		* mysql.connector
		* configparser
* bash  
If using MacOS/Linux system, you do not need to install bash shell additionally. Just work with terminal.
* MySQL




### Using the code

* If you only want to use the exist data

 simply feed the python script a sublist of `filterrepolist.txt` in `04-truck/truck_factor`, say `samplelist.txt`. Set the path to `../EDS19`, and execute the following command in your terminal
 
```
python 04-truck/truck_factor/truckfactor.py samplelist.txt
```
* If you want to use your own interested list of repository.

execute the following lines once you've set the path

```
04-truck/data-acqu/./main.sh 
```
Then feed into your list of repos, and execute the sql script in `04-truck/database/database.sql`. This would automatically drop the former database if existing and build your new one. Finally, execute

```
python 04-truck/truck_factor/truckfactor.py
```
without feeding into any arguement.

