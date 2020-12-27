_bridge = None
_initContext = None
hasBridge = False
MIMICKER_CERT_PATH = "/data/data/com.gr3apps.mimicker/files/cacert.pem"


def init(ctxVars):
    global _initContext
    _initContext = ctxVars
    if('_bridge' in ctxVars):
        global hasBridge
        global _bridge
        hasBridge = True
        _bridge = ctxVars['_bridge']


def phoneAlert(title="", message="", action=None):
    if(hasBridge):
        _bridge.message('PHONE_ALERT', title, message, action)
    else:
        # when is not executed in app
        print(">>>>>>>>>>>>")
        print("PHONE_ALERT")
        print(message)
        print(title)
        print(">>>>>>>>>>>>")


def watchAlert(title="", message="", action=None):
    if(hasBridge):
        _bridge.message('WATCH_ALERT', title, message, action)
    else:
        # when is not executed in app
        print(">>>>>>>>>>>>")
        print('WATCH_ALERT')
        print(message)
        print(title)
        print(">>>>>>>>>>>>")


def launchUrl(url):
    if(hasBridge):
        _bridge.message('LAUNCH_URL', url)
    else:
        # when is not executed in app
        print(">>>>>>>>>>>>")
        print('LAUNCH_URL')
        print(url)
        print(">>>>>>>>>>>>")


def launchIntent(action, data="", package=""):
    if(hasBridge):
        _bridge.message('LAUNCH_INTENT', action, data, package)
    else:
        # when is not executed in app
        print(">>>>>>>>>>>>")
        print('LAUCH_INTENT')
        print(action)
        print(data)
        print(package)
        print(">>>>>>>>>>>>")


def buildAction(actionName, functionName, functionParams=[]):
    ctx_id = ""
    if(hasBridge):
        ctx_id = _initContext['_context_id']
    return {
        "context": ctx_id,
        "name": actionName,
        "function": functionName,
        "args": functionParams
    }


def setCallback(functionName, params=[]):
    if(hasBridge):
        _bridge.message('CALL_FUNC', functionName, params)
    else:
        # when is not executed in app
        print(">>>>>>>>>>>>")
        print('CALL_FUNC')
        print(functionName)
        print(params)
        print(">>>>>>>>>>>>")
