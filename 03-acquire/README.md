# Data Acqusition

The repositories are chosen from 150 project with most fork numbers in each most popular programming languages (as in the [Truck-Factor paper](https://peerj.com/preprints/1233.pdf): Python, Java, JavaScript, C++, C, Ruby and PHP).

`get_repolist.py` gives the method to scrapy the repo list using python. Just reminder that due to the rate limitation(one could only collect 90 items once), it'd better not to collect all the repo names at one time, or it could raise HTTPError: `HTTP Error 429: Too Many Requests` .