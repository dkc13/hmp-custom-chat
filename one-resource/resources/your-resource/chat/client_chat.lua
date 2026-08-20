-- Chat Variables ---------------------------------------------------------------------------------
local webuiChatPath = "file://your_resource/chat/ui/index.html" -- URL for the chat WebUI.
local webuiChat                                                 -- WebUI instance for the chat interface.
local chatInputKey = 21                                         -- Key code for the chat input toggle (e.g., 21 for 'Y' key).
local chatInput = false                                         -- Flag to track if chat input is active.

-- Game Adjustement -------------------------------------------------------------------------------

-- DisableZoomRadar for T key
local function updateRadarZoom(key)
    if key == 20 then
        Game.DisableZoomRadar(true)
    else
        Game.DisableZoomRadar(false)
    end
end

-- Chat Functions ---------------------------------------------------------------------------------

Chat = {
    Create = function ()
        local screenX, screenY = Game.GetScreenResolution()
        webuiChat = WebUI.Create(webuiChatPath, screenX, screenY, true)
        Events.Call("chatInputLoop", {})
        Events.Call("chatTypingLoop", {})
        updateRadarZoom(chatInputKey)
    end,

    Destroy = function ()
        if webuiChat then
            WebUI.Destroy(webuiChat)
            webuiChat = nil
            chatInput = false
            Game.DisableZoomRadar(false)
        end
    end,

    AddMessage = function (message)
        if webuiChat then
            WebUI.CallEvent(webuiChat, "chatMessage", {message})
        end
    end,

    Clear = function ()
        if webuiChat then
            WebUI.CallEvent(webuiChat, "chatClear", {})
        end
    end,

    IsInputActive = function ()
        return chatInput
    end
}

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
                if Game.IsGameKeyboardKeyJustPressed(chatInputKey) then
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

Events.Subscribe("chatTypingLoop", function ()
    Thread.Create(function ()
        while true do
            Thread.Pause(0)
            if webuiChat then
                local playerId = Game.GetPlayerId()
                if chatInput then
                    Game.NetworkSetLocalPlayerIsTyping(playerId) -- Set typing indicator on while chat input is active.
                    Thread.Pause(1900) -- Pause slightly below 2000ms because NetworkSetLocalPlayerIsTyping lasts 2000ms, to keep the typing indicator active without interruption.
                end
            else
                -- If the webuiChat is destroyed, exit the loop.
                return
            end
        end
    end)
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

-- Change Chat Key --------------------------------------------------------------------------------

Events.Subscribe("chatInputKeyChange", function (newKey)
    -- Update chat key from external script.
    newKey = tonumber(newKey) -- Ensure the new key is a number.
    if newKey and newKey > 0 and newKey < 222 and newKey ~= chatInputKey then
        chatInputKey = newKey
        updateRadarZoom(chatInputKey)
    end
end, true)