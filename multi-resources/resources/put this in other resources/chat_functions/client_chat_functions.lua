-- chatResource is name of the resource that handles chat functionality
local chatResource = "chat"
Chat = {}

function Chat.Create()
    Resource.Call(chatResource, "Create", {})
end

function Chat.Destroy()
    Resource.Call(chatResource, "Destroy", {})
end

function Chat.AddMessage(message)
    Resource.Call(chatResource, "AddMessage", { message })
end

function Chat.Clear()
    Resource.Call(chatResource, "Clear", {})
end

function Chat.IsInputActive()
    local chatInput = Resource.Call(chatResource, "IsInputActive", {})
    return chatInput
end