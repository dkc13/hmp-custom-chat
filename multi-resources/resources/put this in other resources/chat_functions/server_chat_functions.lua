-- chatResource is name of the resource that handles chat functionality
local chatResource = "chat"

Chat = {
    SendMessage = function (serverID, message)
        Resource.Call(chatResource, "SendMessage", { serverID, message })
    end,

    BroadcastMessage = function (message)
        Resource.Call(chatResource, "BroadcastMessage", { message })
    end
}