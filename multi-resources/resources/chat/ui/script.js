// https://stackoverflow.com/a/7053197
function ready(callback)
{
    // in case the document is already rendered
    if (document.readyState!='loading') callback();
    // modern browsers
    else if (document.addEventListener) document.addEventListener('DOMContentLoaded', callback);
    // IE <= 8
    else document.attachEvent('onreadystatechange', function(){
        if (document.readyState=='complete') callback();
    });
}

let chatInput = false

const inputHistory = [];
let inputHistoryPosition = -1;
let inputCache = "";

ready(function()
{
    document.addEventListener("keydown", (event) => {
        switch(event.keyCode)
        {
            case 13: // Enter
            {
                if (chatInput)
                {
                    sendInput(false);
                }

                break;
            }
            case 38: // Arrow Up
            {
                if (chatInput)
                {
                    if(inputHistoryPosition == inputHistory.length - 1)
                    {
                        return;
                    }

                    if(inputHistoryPosition == -1)
                    {
                        inputCache = document.getElementById("chatinput").value;
                    }

                    inputHistoryPosition++;

                    const chatInputElement = document.getElementById("chatinput");
                    chatInputElement.value = inputHistory[inputHistoryPosition];
                    chatInputElement.selectionStart = chatInputElement.selectionEnd = chatInputElement.value.length;

                    event.preventDefault();
                }

                break;
            }
            case 40: // Arrow Down
            {
                if (chatInput)
                {
                    if(inputHistoryPosition === -1)
                    {
                        return;
                    }

                    if(inputHistoryPosition === 0)
                    {
                        document.getElementById("chatinput").value = inputCache;
                        inputHistoryPosition = -1;

                        return;
                    }

                    inputHistoryPosition--;
                    document.getElementById("chatinput").value = inputHistory[inputHistoryPosition];

                    event.preventDefault();
                }

                break;
            }
            case 33: // Page Up
            {
                document.getElementById("messageslist").scrollTop -= 15;

                break;
            }
            case 34: // Page Down
            {
                document.getElementById("messageslist").scrollTop += 15;

                break;
            }
            case 27: // Escape
            {
                if (chatInput)
                {
                    toggleInput(false);

                    e.preventDefault();
                }

                break;
            }
        }
    });
});

function sendInput()
{
    let message = document.getElementById("chatinput").value.trim();

    // Remove colors if in message.
    message = message.replace(/(?=!{).*(?<=})/g, "");

    // If box is empty, just close it.
    if (message.length < 1)
    {
        toggleInput(false);
        return;
    }

    // Send chat input event.
    Events.Call('chatInput', [message]);

    // Chat history stuff.
    inputHistory.unshift(message);
    inputHistory.length > 100 && inputHistory.pop();
    inputHistoryPosition = -1;

    // Clean up input box.
    document.getElementById("chatinput").value = "";
    
    // Close input box.
    toggleInput(false);
}

function toggleInput(toggle)
{
    if (toggle == chatInput)
    {
        return;
    }

    if (toggle)
    {
        chatInput = true;

        document.getElementById("chatinput").className = "inputBar";
        document.getElementById("chatinput").focus();
    }
    else
    {
        chatInput = false;
        
        document.getElementById("chatinput").className = "hide";
    }

    //Events.Call('chatInputState', [chatInput]);
    Events.Call('chatInputToggle', [chatInput]);
}

Events.Subscribe("forceInput", function(toggle)
{
    toggleInput(toggle);
});

function convertToPlain(html)
{
    // Create a new div element
    var tempDivElement = document.createElement("div");

    // Set the HTML content with the given value
    tempDivElement.innerHTML = html;

    // Retrieve the text property of the element 
    return tempDivElement.textContent || tempDivElement.innerText || "";
}

function processColors(text)
{
    const regex = /{([A-Fa-f0-9]{6})}([^{}]+)/g;
    let result = '<div>';
  
    text.replace(regex, function(match, color, content)
    {
        result += `<span style="color: #${color}">${convertToPlain(content)}</span>`;
    });
  
    if (result === '<div>')
    {
        result += text;
    }
  
    result += '</div>';

    return result;
}

Events.Subscribe("chatMessage", function(message)
{
    if(message.length < 1)
    {
        return;
    }

    document.getElementById("messageslist").innerHTML += `<div class="message stroke">${processColors(message)}</div>`;
    document.getElementById("messageslist").childElementCount > 100 && document.getElementById("messageslist").firstElementChild.remove();
    document.getElementById("messageslist").scrollTop = document.getElementById("messageslist").scrollHeight;
});

Events.Subscribe("chatClear", function()
{
    document.getElementById("messageslist").innerHTML = "";
    document.getElementById("messageslist").scrollTop = document.getElementById("messageslist").scrollHeight;
});