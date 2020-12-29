import json
import mimicker
import urllib3
import base64
mimicker.init(locals())
authToken = ""
clientId = "24c5abef5660451a82fdb20f2b9a2686"
clientSecret = "78ac703484894c089427f01e9a861787"
# cert_reqs='REQUIRED', ca_certs=mimicker.MIMICKER_CERT_PATH
http = urllib3.PoolManager()

# helper functions


def getEncodedBasicAuth():
    basicAuth = clientId+":"+clientSecret
    return base64.b64encode(basicAuth.encode('ascii')).decode("ascii")


def getAuthHeader():
    return {"Authorization": "Bearer "+authToken}


def fetchData(url, method='GET', body=None):
    r = http.request(method, url, body, getAuthHeader())
    return json.loads(r.data)


def authorize():
    print(getEncodedBasicAuth())
    http = urllib3.PoolManager()
    r = http.urlopen("POST", "https://accounts.spotify.com/api/token",
                     headers={"Authorization": "Basic "+getEncodedBasicAuth(),
                              'Content-Type': "application/x-www-form-urlencoded"},
                     body="grant_type=client_credentials&scope=playlist-read-private")
    global authToken
    print(r.data)
    authToken = json.loads(r.data)['access_token']
# end of helper functions


authorize() 
devices = fetchData("https://api.spotify.com/v1/me/playlists")
print(devices)
