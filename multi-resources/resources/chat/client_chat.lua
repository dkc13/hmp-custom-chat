-- Chat Variables ---------------------------------------------------------------------------------
local webuiChatPath = "file://chat/ui/index.html"               -- URL for the chat WebUI.
local webuiChat                                                 -- WebUI instance for the chat interface.
local chatInputKey = 21                                         -- Key code for the chat input toggle (e.g., 21 for 'Y' key).
local chatInput = false                                         -- Flag to track if chat input is active.

-- Game Adjustement -------------------------------------------------------------------------------

-- Disable radar zoom feature when the chat key is set to 'T' (Key code 20)
local disableRadarZoom = true

local function updateRadarZoom(key)
    Game.DisableZoomRadar(disableRadarZoom and key == 20)
end

-- Chat Functions ---------------------------------------------------------------------------------

function Create()
    if webuiChat then
        -- If webui already exists, abort creating new one.
        return
    end

    local screenX, screenY = Game.GetScreenResolution()
    webuiChat = WebUI.Create(webuiChatPath, screenX, screenY, true)
    Events.Call("chatInputLoop", {})
    Events.Call("chatTypingLoop", {})
    updateRadarZoom(chatInputKey)
end

function Destroy()
    if webuiChat then
        WebUI.Destroy(webuiChat)
        webuiChat = nil
        chatInput = false
        updateRadarZoom(false)
    end
end

function AddMessage(message)
    if webuiChat then
        WebUI.CallEvent(webuiChat, "chatMessage", {message})
    end
end

function Clear()
    if webuiChat then
        WebUI.CallEvent(webuiChat, "chatClear", {})
    end
end

function IsInputActive()
    return chatInput
end

Events.Subscribe("chatSendMessage", function (message)
    AddMessage(message)
end, true)

-- Chat Management ---------------------------------------------------------------------------------

Events.Subscribe("scriptInit", function()
    -- Initialize the chat input system.
    Create()
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
                if chatInput then
                    local playerId = Game.GetPlayerId()
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

local function rgbToHex(r, g, b)
    return string.format("%02x%02x%02x", r or 255, g or 255, b or 255)
end

Events.Subscribe("chatSubmit", function (message)
    local playerId = Game.GetPlayerId()
    local r, g, b = Game.GetPlayerRgbColour(playerId)
    local hexColor = rgbToHex(r, g, b)

    Events.CallRemote("chatSendGlobalMessage", { 
        "{" .. hexColor .. "}" .. Game.GetPlayerName(playerId) .. ": {ffffff}" .. message 
    })
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