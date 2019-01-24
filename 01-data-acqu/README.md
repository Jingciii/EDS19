# Data Acqusition

This repo gives an automatic system that performs large scale data acqusition on GitHub and generates datasets for future research.

## Getting Started


### Prerequisites

* Python 3.6.5
* bash  
If using MacOS/Linux system, you do not need to install bash shell additionally. Just work with terminal.


### Using the code

First, you must set the path to `01-data-acqu` directory in your terminal.

```
cd ../EDS19/01-data-acqu
```
To run the code, simply need to type:

```
./main.sh
```
Then, the shell would ask you to give the repos list. You can enter `repos.list.txt` as an example. You can also give the system other txt files of list as long as their elements follows `{user}/{repo}` format just like that in `repos.list.txt`.

## Result

Tested with `repos.list.txt`, the shell would tell data generated and the disk space they take. It will also report the running time of the whole process.


![](https://raw.githubusercontent.com/Jingciii/EDS19/master/01-data-acqu/result.png)



## Reference

[Shell programming with bash: by example, by counter-example](http://matt.might.net/articles/bash-by-example/)

[BASH Programming - Introduction HOW-TO](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html)

[How To Use Web APIs in Python 3](https://www.digitalocean.com/community/tutorials/how-to-use-web-apis-in-python-3) 