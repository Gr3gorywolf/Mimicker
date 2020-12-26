_bridge = None
hasBridge = False
MIMICKER_CERT_PATH = "/data/data/com.gr3apps.mimicker/files/cacert.pem"

def init(ctxVars):
    if('_bridge' in ctxVars):
        global hasBridge
        global _bridge
        hasBridge = True
        _bridge = ctxVars['_bridge']


def printOnPhone(message="", title=""):
    if(hasBridge):
        _bridge.message('PHONE_ALERT', title, message)
    else:
        #when is not executed in app
        print(">>>>>>>>>>>>")
        print("PHONE_ALERT")
        print(message)
        print(title)
        print(">>>>>>>>>>>>")


def printOnWatch(message="", title=""):
    if(hasBridge):
        _bridge.message('WATCH_ALERT', title, message)
    else:
        #when is not executed in app
        print(">>>>>>>>>>>>")
        print('WATCH_ALERT')
        print(message)
        print(title)
        print(">>>>>>>>>>>>")


def launchUrl(url):
    if(hasBridge):
        _bridge.message('LAUNCH_URL', url)
    else:
        #when is not executed in app
        print(">>>>>>>>>>>>")
        print('LAUNCH_URL')
        print(url)
        print(">>>>>>>>>>>>")


def launchIntent(action, data="", package=""):
    if(hasBridge):
        _bridge.message('LAUNCH_INTENT', action, data, package)
    else:
        #when is not executed in app
        print(">>>>>>>>>>>>")
        print('LAUCH_INTENT')
        print(action)
        print(data)
        print(package)
        print(">>>>>>>>>>>>")
