function SendMessage(serverID, message)
    if Player.IsConnected(serverID) then
        Events.CallRemote("chatSendMessage", serverID, {message})
    end
end

function BroadcastMessage(message)
    Events.BroadcastRemote("chatSendMessage", {message})
end

Events.Subscribe("chatSendGlobalMessage", function (message)
    BroadcastMessage(message)
end, true)