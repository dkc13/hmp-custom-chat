-- Chat Variables ---------------------------------------------------------------------------------
local webuiChat
local chatInput = false

-- Chat Functions ---------------------------------------------------------------------------------

Chat = {}

function Chat.Create()
    local screenX, screenY = Game.GetScreenResolution()
    webuiChat = WebUI.Create("file://your_resource/chat/ui/index.html", screenX, screenY, true)

    Events.Call("chatInputLoop", {})
end

function Chat.Destroy()
    if webuiChat then
        WebUI.Destroy(webuiChat)
        webuiChat = nil
    end
end

function Chat.AddMessage(message)
    if webuiChat then
        WebUI.CallEvent(webuiChat, "chatMessage", {message})
    end
end

function Chat.Clear()
    if webuiChat then
        WebUI.CallEvent(webuiChat, "chatClear", {})
    end
end

function Chat.IsInputActive()
    return chatInput
end

Events.Subscribe("chatSendMessage", function (message)
    Chat.AddMessage(message)
end, true)

-- Chat Management ---------------------------------------------------------------------------------

Events.Subscribe("scriptInit", function()
    -- Initialize the chat input system.
    Chat.Create()
end)

Events.Subscribe("chatInputLoop", function ()
    -- Chat input loop to handle keyboard input for chat.
    Thread.Create(function ()
        while true do
            Thread.Pause(0)
            if webuiChat then
                if Game.IsGameKeyboardKeyJustPressed(21) then
                    WebUI.CallEvent(webuiChat, "forceInput", {true})
                    Thread.Pause(100)
                end
            else
                -- If the webuiChat is destroyed, exit the loop.
                return
            end
        end
    end)
end)

Events.Subscribe("chatInputToggle", function (state)
    -- Toggle the chat input state.
    if state then
        chatInput = true
        WebUI.SetFocus(webuiChat, false)
    else
        chatInput = false
        WebUI.SetFocus(-1)
    end
end)

-- Global Chat Functionality ----------------------------------------------------------------------

local function rgbToHex(rgb)
	--local hexadecimal = '0X'
    local hexadecimal = ''

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

    --return hexadecimal
    return string.lower(hexadecimal)
end

Events.Subscribe("chatSubmit", function (message)
    local playerId = Game.GetPlayerId()
    local rgb = table.pack(Game.GetPlayerRgbColour(Game.GetPlayerId()))
    local hexColor = rgbToHex(rgb)

    Events.CallRemote("chatSendGlobalMessage", { "{" .. string.sub(hexColor, 1, 6) .. "}" .. Game.GetPlayerName(playerId) .. ": {ffffff}" .. message})
end)