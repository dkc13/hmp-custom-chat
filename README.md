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
webuiChat = WebUI.Create("file://your-resource/chat/ui/index.html", screenX, screenY, true)
```

5. **(Optional) Change the keybind to open chat**:

* By default, chat opens when the Y key is pressed (``key code 21``).
You can change this by editing the line inside the ``chatInputLoop`` event in ``client_chat.lua``:

```lua
if Game.IsGameKeyboardKeyJustPressed(21) then
```

* Replace ``21`` with the desired key ID.\
➡ Key codes can be found here:
https://happinessmp.net/docs/game/keys

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

This setup allows your other resources to communicate with the chat system using **export functions**.

## 🙏 Credits
Special thanks to [@spikedengineering](https://github.com/spikedengineering) for helping with the multi-resource integration logic and structure.

## 🐞 Bug Reports & Support

If you encounter any bugs or if something isn’t working as expected, feel free to reach out via Discord: **[dkc13](https://discord.com/users/467330703558836224)**

I’m happy to help or take feedback to improve the system. 👍
