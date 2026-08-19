-- chatResource is name of the resource that handles chat functionality
local chatResource = "chat"

Chat = {
    Create = function ()
        Resource.Call(chatResource, "Create", {})
    end,

    Destroy = function ()
        Resource.Call(chatResource, "Destroy", {})
    end,

    AddMessage = function (message)
        Resource.Call(chatResource, "AddMessage", { message })
    end,

    Clear = function ()
        Resource.Call(chatResource, "Clear", {})
    end,

    IsInputActive = function ()
        local chatInput = Resource.Call(chatResource, "IsInputActive", {})
        return chatInput
    end
}