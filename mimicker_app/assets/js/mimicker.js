let msgFNC = sendMessage;
function sendAction(action, data) {
    if (!msgFNC) {
        return;
    }
    msgFNC("js", JSON.stringify({
        action: action,
        data
    }));
}

function buildAction(title, callback) {
    return {
        title,
        action: "" + callback,
        instanceId
    }
}
/**
 * 
 * @param {object} toRender 
 * @returns 
 */
function render(toRender) {
    return sendAction('RENDER', toRender);
}

/**
 * 
 * @param {function(any)} callback 
 */
function buildRenderCallback(callback, id = null) {
    callback = callback + '';
    var val = JSON.stringify({
        instanceId,
        callback,
        id
    });
    var script = "${runCallback(" + val + ")}";
    return script;
}

const phone = {
    /**
     * 
     * @param {string} title 
     * @param {string} message 
     * @param {string} image
     * @param {{title:string,action:string,instanceId:string }} action
    */
    showAlert(title, message, image = null, action = null) {
        sendAction('PHONE_ALERT', {
            title,
            message,
            image,
            action
        })
    },
    /**
     * 
     * @param {string} title 
     * @param {[{title:string,action:string,instanceId:string }]} actions 
     */
    showActionsList(title, actions = []) {
        sendAction('SHOW_PHONE_ACTIONS_LIST', {
            title,
            actions
        })
    },
    /**
     * 
     * @param {string} url 
     */
    launchUrl(url) {
        sendAction('LAUNCH_URL', {
            url
        })
    },
    /**
     * 
     * @param {boolean} isLoading 
     */
    setLoading(isLoading) {
        sendAction('PHONE_LOADING', {
            isLoading
        })
    },
    /**
     * 
     * @param {string} action 
     * @param {string} data 
     * @param {string} package 
     */
    launchIntent(action, data = null, package = null) {
        sendAction('LAUNCH_INTENT', {
            action,
            data,
            package
        })
    }

}

const watch = {
    /**
    * 
    * @param {string} title 
    * @param {string} message 
    * @param {string} image
    * @param {{title:string,action:string,instanceId:string }} action
   */
    showAlert(title, message, image = null, action = null) {
        sendAction('WATCH_ALERT', {
            title,
            message,
            image,
            action
        })
    },
    /**
     * 
     * @param {string} title 
     * @param {[{title:string,action:string,instanceId:string }]} actions 
     */
    showActionsList(title, actions = []) {
        sendAction('SHOW_WATCH_ACTIONS_LIST', {
            title,
            actions
        })
    },
    /**
     * 
     * @param {boolean} isLoading 
     */
    setLoading(isLoading) {
        sendAction('WATCH_LOADING', {
            isLoading
        })
    }

}