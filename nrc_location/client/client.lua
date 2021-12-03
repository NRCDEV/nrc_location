ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local open = false
local MenuLocation = RageUI.CreateMenu("Location", "Interaction")
MenuLocation.Display.Header = true
MenuLocation.Close = function() 
    open = false
end

function OpenMenuLocation() 
    if open then 
        open = false
        RageUI.Visible(MenuLocation, false)
        return
    else
        open = true
        RageUI.Visible(MenuLocation, true)
        CreateThread(function()
            local cooldown = false
            while open do 
                RageUI.IsVisible(MenuLocation, function()
                    RageUI.Separator("  ↓                ~o~Location de véhicules                ~s~↓")
                    for k, v in pairs(Config.Location.vehicule) do 
                        RageUI.Button(v.Nom, nil, {RightLabel = "~r~"..v.Price.."$"}, not cooldown, {
                            onSelected = function()
                                RageUI.CloseAll()
                                TriggerServerEvent('n_location:AchatVehicule', v.Nom, v.Vehicule, v.Price)
                                cooldown = true
                                Citizen.SetTimeout(10000, function()
                                    cooldown = false 
                                end)
                            end 
                        })
                    end 
                    RageUI.Separator("  ↓                           ~b~Retour                            ~s~↓")
                    RageUI.Button("Rendre la location", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            local veh, dist = ESX.Game.GetClosestVehicle(PlayerCoords)
                            if dist < 4 then 
                                DeleteEntity(veh)
                                TriggerServerEvent('n_location:Retour')
                            end                  
                        end 
                    })

                    RageUI.Separator("  ↓                         ~r~Fermeture                        ~s~↓")
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            RageUI.CloseAll()
                        end 
                    })            
                    
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
		local wait = 750

			for k in pairs(Config.Location.position) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.Location.position
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= Config.MarkerDistance then
                wait = 0
                ESX.ShowHelpNotification("Appuyer sur [~o~E~s~] pour accéder à la ~o~Location !")
                DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
            end

			if dist <= 4.0 then
                wait = 0
                Visual.Subtitle(Config.Text, 1)
                if IsControlJustPressed(1,51) then
                    OpenMenuLocation()
                end
		    end
		end
    Wait(wait)
    end
end)

-- Spawn des véhicules
RegisterNetEvent('n_Location:spawnCar')
AddEventHandler('n_Location:spawnCar', function(car)
    local car = GetHashKey(car)
    local playerped = PlayerPedId()

    RequestModel(car)
    while not HasModelLoaded(car) do Citizen.Wait(10) end 
    local Vehicule = CreateVehicle(car, -491.84, -668.81, 32.15, 270.46, true, false)
    SetEntityAsMissionEntity(Vehicule, true, true)
end)

-- Blip
Citizen.CreateThread(function()
    local locblips = AddBlipForCoord(-496.02, -670.29, 32.9)
    SetBlipSprite(locblips , 77)
    SetBlipColour(locblips , 17)
    SetBlipScale(locblips , 0.8)
    SetBlipAsShortRange(locblips , true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("~o~Location")
    EndTextCommandSetBlipName(locblips )
end)

-- Ped
Citizen.CreateThread(function()
    local hash = GetHashKey("cs_josh")
    local pedpos = vector3(-496.02, -670.29, 31.95) -- Position du Ped

    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
    end

    ped = CreatePed("PED_TYPE_CIVMALE", "cs_josh", pedpos.x, pedpos.y, pedpos.z, 180.51, false, true) --Emplacement du PEDS
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end)


