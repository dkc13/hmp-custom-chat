-- chatResource is name of the resource that handles chat functionality
local chatResource = "chat"
Chat = {}

function Chat.SendMessage(serverID, message)
    Resource.Call(chatResource, "SendMessage", { serverID, message })
end

function Chat.BroadcastMessage(message)
    Resource.Call(chatResource, "BroadcastMessage", { message })
end