import json 
import mimicker 
import urllib3 
mimicker.init(locals())
mimicker.printOnPhone("xd","xdd")
url = "https://api.crackwatch.com/api/games?page=0&sort_by=crack_date&is_cracked=true"

http = urllib3.PoolManager()#cert_reqs='REQUIRED', ca_certs=mimicker.MIMICKER_CERT_PATH)
r = http.request('GET', url)
content_body = json.loads(r.data)
print(content_body)
message = ""
for game in content_body:
    print(game)
    message+="Titulo: "+ game.title + "\n"
    message+="Estado: crackeado" + "\n"
    message+="Crackeado el:" +game.crackDate +  "\n\n"
mimicker.printOnPhone(message,"Lista de juegos crackeados")