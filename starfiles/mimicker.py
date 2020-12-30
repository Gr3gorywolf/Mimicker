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


# helper functions
class helpers:
    def printDebugAction(action, params=[]):
        print("<-----debug-action----->")
        print("Action name: " + action)
        print("Params:")
        for param in params:
            print("-" + param)
        print("<-----debug-action----->")

    def buildAction(actionName, functionName, functionParams=[]):
        """
        Create actions to be used in ui element buttons
        """
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
        """
        Call a function defined in the script with its respective parameters
        """
        if(hasBridge):
            _bridge.message('CALL_FUNC', functionName, params)
        else:
            helpers.printDebugAction('CALL_FUNC', [functionName, params])


# phone actions
class phone:
    def showAlert(title="", message="", image=None, action=None):
        """
        shows an alert on the phone and if an image url is specified it shows it.
        If the action is specified, a button will be created in the alert that will execute that action
        """
        if(hasBridge):
            _bridge.message('PHONE_ALERT', title, message, image, action)
        else:
            helpers.printDebugAction(
                'PHONE_ALERT', [title, message, image, action])

    def showActionsList(title, actions=[]):
        """
        Show an alert with a set of actions on the phone
        """
        if(hasBridge):
            _bridge.message('SHOW_PHONE_ACTIONS_LIST', title, actions)
        else:
            helpers.printDebugAction(
                'SHOW_PHONE_ACTIONS_LIST', [title, actions])

    def setLoading(isLoading):
        """
        Put the phone app in loading mode
        """
        if(hasBridge):
            _bridge.message('PHONE_LOADING', isLoading)
        else:
            helpers.printDebugAction('PHONE_LOADING', [str(isLoading)])

    def launchUrl(url):
        """
        Launch a url on the phone
        """
        if(hasBridge):
            _bridge.message('LAUNCH_URL', url)
        else:
            helpers.printDebugAction('LAUNCH_URL', [url])

    def launchIntent(action, data="", package=""):
        """
        Create an android intent which allows you to interact with other applications
        more info on: https://pub.dev/packages/android_intent
        """
        if(hasBridge):
            _bridge.message('LAUNCH_INTENT', action, data, package)
        else:
            helpers.printDebugAction('LAUNCH_INTENT', [action, data, package])

# watch actions


class watch:
    def showAlert(title="", message="", image=None, action=None):
        """
        shows an alert on the watch and if an image url is specified it shows it.
        If the action is specified, a button will be created in the alert that will execute that action
        """
        if(hasBridge):
            _bridge.message('WATCH_ALERT', title, message, image, action)
        else:
            helpers.printDebugAction(
                'WATCH_ALERT', [title, message, image, action])

    def showActionsList(title, actions=[]):
        """
        Show an alert with a set of actions on the watch
        """
        if(hasBridge):
            _bridge.message('SHOW_WATCH_ACTIONS_LIST', title, actions)
        else:
            helpers.printDebugAction(
                'SHOW_WATCH_ACTIONS_LIST', [title, actions])

    def setLoading(isLoading):
        """
        Put the watch app in loading mode
        """
        if(hasBridge):
            _bridge.message('WATCH_LOADING', isLoading)
        else:
            helpers.printDebugAction('WATCH_LOADING', [isLoading])
