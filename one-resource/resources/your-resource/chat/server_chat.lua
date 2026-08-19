Chat = {
    SendMessage = function (serverID, message)
        if Player.IsConnected(serverID) then
            Events.CallRemote("chatSendMessage", serverID, {message})
        end
    end,

    BroadcastMessage = function (message)
        Events.BroadcastRemote("chatSendMessage", {message})
    end
}

Events.Subscribe("chatSendGlobalMessage", function (message)
    Chat.BroadcastMessage(message)
end, true)