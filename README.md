# Custom Chat for HappinessMP

This repository contains a **working integration of the default HappinessMP chat system** as a standalone resource.  
It allows developers to **manually control and customize the chat**, making it easier to manipulate, extend, or restyle in their projects.

It provides a cleaner and more modular way to use the **existing default chat** — enabling full access to its behavior and UI through WebUI and Lua.

---

## 🎯 Purpose

The goal of this setup is to:

- Provide **direct access** to the built-in HappinessMP chat  
- Enable **easy styling, extension, or feature development**
- Give full control over how and when chat is opened or interacted with

This is especially useful if you want to:
- Change the key used to open chat
- Modify its appearance or behavior
- Add buttons, themes, animations, or new logic

---

## 📦 One-Resource Setup

This setup is ideal for smaller servers where everything is handled within a single resource.

### 🔧 Integration Guide

1. **Disable the default chat** in `settings.xml`:

```xml
<chat>false</chat>
```

2. **Add the** ``chat/`` **folder** into your existing resource:

```xml
resources/your-resource/chat/
```

3. **Update the resource’s** ``meta.xml``:

```xml
<meta type="lua">
    <file src="chat/ui/index.html" />
    <file src="chat/ui/styles.css" />
    <file src="chat/ui/script.js" />

    <script type="client" src="chat/client_chat.lua" />
    <script type="server" src="chat/server_chat.lua" />
</meta>
```

4. **Adjust the WebUI path** in ``client_chat.lua``:

```lua
local webuiChatPath = "file://your_resource/chat/ui/index.html"
```

## 🔁 Multi-Resource Setup
For larger server structures, you can keep the chat in its own resource and use exported functions from other modules.

### 🔧 Integration Guide

1. **Disable the default chat** in ``settings.xml``:

```xml
<chat>false</chat>
```

2. Add the ``chat`` resource to your server.

3. Register the chat resource in ``settings.xml``:

```xml
<resource>chat</resource>
```

4. **In every other resource that will use chat features**, do the following:

* Copy the ``chat_functions/`` folder from ``multi-resources/resources/put in other resources/`` into the target resource.

* Update that resource’s ``meta.xml`` with:

```xml
<meta type="lua">
    <script type="client" src="chat_functions/client_chat_functions.lua" />
    <script type="server" src="chat_functions/server_chat_functions.lua" />
</meta>
```

5. **Adjust the WebUI path** in ``client_chat.lua``:

```lua
local webuiChatPath = "file://your_resource/chat/ui/index.html"
```

This setup allows your other resources to communicate with the chat system using **export functions**.

---

## 🛠 Changing the Chat Keybind

By default, the chat opens when pressing the **Y** key (`key code 21`).

You can change this dynamically using the `chatInputKeyChange` event, or by modifying the `chatInputKey` variable in `client_chat.lua`:

The chat input loop uses the `chatInputKey` variable, so it will respond to whichever key you set.

➡ You can find all valid key IDs here:
https://happinessmp.net/docs/game/keys

---

## 🧠 How It Works

Here’s a technical overview of how the system operates under the hood:

### 🔘 Toggling Chat Input

To control the visibility of the chat input, a new event ``chatInputToggle`` was introduced.
This replaces the default ``chatInputState`` event, which only interacts with the built-in HappinessMP chat and does not affect custom implementations:

```lua
-- Events.Call('chatInputState', [chatInput])
Events.Call('chatInputToggle', [chatInput])
```

``chatInputToggle`` is used to manually manage chat input visibility in this custom system.

### 📤 Sending Messages

When the player sends a message through the chat input, the `sendInput` function in `script.js` is triggered. This function sends the message to the client-side via:

```js
Events.Call('chatInput', [message]);
```

> ℹ️ Note: `chatInput`, `chatSubmit`, and `chatCommand` are all **built-in events** provided by the HappinessMP framework.

### 🔁 Handling Chat Input

On the client side, the `chatInput` event determines whether the input is:

- A regular message (calls `chatSubmit`)
- A command (starts with `/`, calls `chatCommand`)

This separation allows message and command handling to be managed independently.

### ⌨️ Typing Indicator

This system also includes a **typing indicator**. It automatically shows when the player has the chat input active and hides when the input is closed.  

The typing system has been **reimplemented on the networking layer**, so you can also use the native function to check if a specific player is currently typing:

```lua
Game.NetworkIsPlayerTyping(playerId)
```

By default, this works with the built-in player name and typing icon.
If you want to create a custom typing indicator, this function is especially useful to detect typing state for your own UI or features.

### 🧩 Overwritten `Chat.` Functions

The default Chat. API has been re-implemented to work with the custom WebUI-based chat system. 

### 💬 Global Chat

**The default chatbox** appearance (*including colors, layout, and structure*) is implemented in `client_chat.lua`, closely following the style used by HappinessMP. This includes a function that converts the player's RGB color to a hexadecimal format, which is then used to color the player's name in chat messages.

You are free to customize or completely replace this functionality and visual style to better fit your project’s needs.

---

## 🙏 Credits
Special thanks to [@spikedengineering](https://github.com/spikedengineering) for helping with the multi-resource integration logic and structure.

## 🐞 Bug Reports & Support

If you encounter any bugs or if something isn’t working as expected, feel free to reach out via Discord: **[dkc13](https://discord.com/users/467330703558836224)**

I’m happy to help or take feedback to improve the system. 👍
