import mimicker 
import urllib3
http = urllib3.PoolManager()
r = http.request('GET', 'https://loteriasdominicanas.com/')

mimicker.printOnPhone("la realeza",r.data)