local prevtime = GetGameTimer()
local prevframes = GetFrameCount()
local fps = -1
local function Notify(msg) SetNotificationTextEntry('STRING') AddTextComponentString(msg) DrawNotification(0,1) end

Citizen.CreateThread(function()	  
        
        while not NetworkIsPlayerActive(PlayerId()) or not NetworkIsSessionStarted() do	        
            Citizen.Wait(250)
            prevframes = GetFrameCount()
            prevtime = GetGameTimer()            
	    end

        while true do		 
            curtime = GetGameTimer()
	        curframes = GetFrameCount()	   
		
            if((curtime - prevtime) > 1000) then
                fps = (curframes - prevframes) - 1				
                prevtime = curtime
                prevframes = curframes
            end

            if IsGameplayCamRendering() and fps >= 0 then
                SendNUIMessage({
                    action = 'setFps',
                    fps = fps
                })
            end            
            Citizen.Wait(1000)
       end	
end)

RegisterCommand('moveFpsCounter',  function()
    SetNuiFocus(true, true)
    Notify('Pulsa ~y~ESCAPE~s~ para salir')
end)

RegisterNUICallback('mdn_close', function()
    SetNuiFocus(false, false)
end)