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

* Running the code for the first time.

execute the following lines once you've set the path

```
04-truck/data-acqu/./main.sh 
```
Then feed into your list of repos, and execute the sql script in `04-truck/database/database.sql`. This would automatically drop the former database if existing and build your new one. Set the relevent information in `04-truck/truckfactor/config.ini` which would help with the connection between MySQL and Python. Finally, execute

```
python 04-truck/truck_factor/truckfactor.py
```
without feeding into any arguement.

* If you want to reuse the exist data

 After collecting the whole database for the first time, simply feed the python script a sublist of `filterrepolist.txt` in `04-truck/truck_factor`, say `samplelist.txt`. Set the path to `../EDS19`, and execute the following command in your terminal
 
```
python 04-truck/truck_factor/truckfactor.py samplelist.txt
```


### Result

The results for 10 randomly chosen repositories are as follows.

	- freebsd/freebsd: 17 
	- moment/moment: 1
	- llvm-mirror/clang: 22
	- aosp-mirror/platform_frameworks_base: 43
	- nrk/predis: 1
	- angular/angular.js: 8
	- fastlane/fastlane: 6
	- diaspora/diaspora: 7
	- mruby/mruby: 6
	- celluloid/celluloid: 2
