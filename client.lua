local prevtime = GetGameTimer();
local prevframes = GetFrameCount();
local fps = -1;

-- THREADS

CreateThread(function();
    while not NetworkIsPlayerActive(PlayerId()) or not NetworkIsSessionStarted() do;
        Wait(250);
        prevframes = GetFrameCount();
        prevtime = GetGameTimer();        
    end;
    while true do;
        curtime = GetGameTimer();
        curframes = GetFrameCount();
        if ((curtime - prevtime) > 1000) then;
            fps = (curframes - prevframes) - 1;				
            prevtime = curtime;
            prevframes = curframes;
        end;
        if IsGameplayCamRendering() and fps >= 0 then;
            SendNUIMessage({
                action = 'setFps',
                fps = fps
            })
        end;
        Wait(1000);
    end;
end);

-- FUNCTIONS

local function ChatMessage(msg); 
    TriggerEvent("chatMessage", "[Jaareet#0097]", {255, 255, 0}, msg);
end;

local function showCursor();
    ChatMessage('Pulsa ^5[ESCAPE]^0 para salir');
    SetNuiFocus(true, true);
end;

local function hideCursor();
    if not (Options.moveFPSMenu) then 
        ChatMessage("Has terminado el cambio de posicion del UI");
    end
    SetNuiFocus(false, false);
end;

local function closeAllMenus()
    if (ESX) and (Options.moveFPSMenu) then
        ESX.UI.Menu.CloseAll()
        ChatMessage("Has terminado el cambio de posicion del UI");
    end
end

-- EXPORTS

exports('ChatMessage', ChatMessage);

-- END FUNCTIONS


-- COMANDS

RegisterCommand('moveFPS', function();
    showCursor();
end);

RegisterCommand("desbugNUI", function();
    hideCursor();
end);

if(Options.moveFPSKeyMode)then;
    RegisterKeyMapping('moveFPS', 'Move FPS Counter', "keyboard", Options.MoveFPSKey);
end;

-- CALLBACKS

RegisterNUICallback('close', function();
    hideCursor();
    if(Options.moveFPSMenu)then;
        showFPSMenu();
    end
end);


-- EVENTS

AddEventHandler("onResourceStart", function(res);
    if res == GetCurrentResourceName() then;
        print("^3[j-fps]^0 Started");
    end;
end);

AddEventHandler("onResourceStop", function(res);
    if res == GetCurrentResourceName() then;
        print("^3[j-fps]^0 Stopped");
        closeAllMenus();
    end;
end);

-- FPS MENU

if(Options.moveFPSMenu)then;
    ESX = exports["es_extended"]:getSharedObject();

    RegisterCommand("fpsMenu", function()
        showFPSMenu();
    end)

    function showFPSMenu()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fpsMoveMenu', {
            title = "FPS Counter Menu",
            align = "bottom-right",
            elements = {
                {label = "Move FPS Counter", value = "moveFPS"},
                {label = "Close", value = "close"},
            }
        }, function(data, menu)
            menu.close()

            local val = data.current.value
            if val == "moveFPS" then;
                showCursor();
            elseif val == "close" then;
                closeAllMenus();
            end;
        end, function(data, menu)
            menu.close()
        end)
    end
    RegisterKeyMapping("fpsMenu", "Open FPS Counter Menu", "keyboard", Options.fpsMenuKey);
end
