# Custom Chat for HappinessMP

A standalone integration of the default HappinessMP chat system. It provides direct control over the chat interface and behavior through WebUI and Lua, allowing for easy customization, custom keybinds, and styling.

---

## Features

- Standalone control over the HappinessMP chat system
- Easily customizable UI, styles, and logic
- Built-in network typing indicator support
- Compatible with single-resource and multi-resource server structures

---

## Installation

### Single-Resource Setup

1. Disable the default chat in `settings.xml`:
   ```xml
   <chat>false</chat>
   ```

2. Move the `chat/` folder into your target resource:
   ```text
   resources/your-resource/chat/
   ```

3. Update your resource's `meta.xml`:
   ```xml
   <meta type="lua">
       <file src="chat/ui/index.html" />
       <file src="chat/ui/styles.css" />
       <file src="chat/ui/script.js" />

       <script type="client" src="chat/client_chat.lua" />
       <script type="server" src="chat/server_chat.lua" />
   </meta>
   ```

4. Adjust `webuiChatPath` in `client_chat.lua`:
   ```lua
   local webuiChatPath = "file://your_resource/chat/ui/index.html"
   ```

---

### Multi-Resource Setup

1. Disable the default chat in `settings.xml`:
   ```xml
   <chat>false</chat>
   ```

2. Add the `chat` resource to `settings.xml`:
   ```xml
   <resource>chat</resource>
   ```

3. Copy `chat_functions/` into any resource that needs chat integration, and update its `meta.xml`:
   ```xml
   <meta type="lua">
       <script type="client" src="chat_functions/client_chat_functions.lua" />
       <script type="server" src="chat_functions/server_chat_functions.lua" />
   </meta>
   ```

4. If you change the chat resource folder name, update `webuiChatPath` in `client_chat.lua`:
   ```lua
   local webuiChatPath = "file://chat/ui/index.html"
   ```
   And also update `chatResource` in both `client_chat_functions.lua` and `server_chat_functions.lua` (which are placed in other resources):
   ```lua
   -- chatResource is name of the resource that handles chat functionality
   local chatResource = "chat"
   ```

---

## Configuration

### Changing Keybinds
By default, chat opens with the **Y** key (`key code 21`). 

You can change it by modifying `chatInputKey` in `client_chat.lua` or by calling the `chatInputKeyChange` event dynamically.

Refer to the [HappinessMP Key Documentation](https://happinessmp.net/docs/game/keys) for valid key IDs.

### Radar Zoom Behavior
By default, pressing **T** (`key code 20`) triggers the game's radar zoom, which can be annoying when opening the chat. 

This issue is automatically prevented out of the box. If you ever want to allow default radar zoom behavior, toggle `disableRadarZoom` in `client_chat.lua`:

```lua
local disableRadarZoom = true -- Set to false to allow default radar zoom behavior
```

---

## Technical Overview

- **Input State:** Uses `chatInputToggle` (a custom event created to replace the default `chatInputState` event) to manually manage input visibility.
- **Message Handling:** The UI triggers `chatInput`, which routes messages to `chatSubmit` or commands starting with `/` to `chatCommand` (both are client-side events).
- **Typing Indicator:** Re-implemented on the network layer using `Game.NetworkSetLocalPlayerIsTyping`.
- **Global Chat & Formatting:** Includes RGB-to-HEX player color parsing matching the default HappinessMP visual style.
