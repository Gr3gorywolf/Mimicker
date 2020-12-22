def printOnPhone(message="",title=""):
    _bridge.message('PHONE_ALERT',title,message)

def printOnWatch(message="",title=""):
    _bridge.message('WATCH_ALERT',title,message)