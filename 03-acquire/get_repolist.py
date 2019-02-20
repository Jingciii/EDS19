import time              
import re
import urllib.request 
from bs4 import BeautifulSoup
import requests
import json
import time


headers = {
    "User-Agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"
    }

cpp_query = "https://github.com/search?l=&o=desc&q=stars%3A%22%3E+100%22++language%3AC%2B%2B+size%3A%3E1000&s=forks&type=Repositories&p="
java_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3AJava+size%3A%3E1000&type=Repositories&p="
c_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3AC+size%3A%3E1000&type=Repositories&p="
python_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3APython+size%3A%3E1000&type=Repositories&p="
ruby_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3ARuby+size%3A%3E1000&type=Repositories&p="
php_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3APHP+size%3A%3E1000&type=Repositories&p="
js_query = "https://github.com/search?q=stars%3A%22%3E+100%22++language%3AJavaScript+size%3A%3E1000&type=Repositories&p="

def get_list(query):
    time.sleep(60)
    repo_list = []
    for p in range(1, 16):
        url = query + str(p)
        #with urllib.request.urlopen(url) as u:
         #   content = u.read()
        content = requests.get(url=url, headers=headers).text
        
        soup = BeautifulSoup(content,"html.parser")
        title_tab = soup.find_all("div",class_="col-12 col-md-8 pr-md-3")
        for tab in title_tab:
            title = tab.find("h3")
            print(title.get_text())
            repo_list.append(title.get_text().strip('\n'))
        if p == 9:
            time.sleep(60)
    
    return repo_list


java_list = get_list(java_query)
cpp_list = get_list(cpp_query)
python_list = get_list(python_query)
c_list = get_list(c_query)
php_list = get_list(php_query)
ruby_list = get_list(ruby_query)
js_list = get_list(js_query)