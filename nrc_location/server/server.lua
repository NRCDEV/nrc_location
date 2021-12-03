ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('n_location:AchatVehicule')
AddEventHandler('n_location:AchatVehicule', function(Nom, Vehicule, Price)
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    local car = Vehicule 
    if xPlayer.getMoney() >= Price then 
        xPlayer.removeMoney(Price)

        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Location', 'Véhicule', 'Votre véhicule arrive d\'ici peu !', 'CHAR_CASTRO', 1)
        Citizen.Wait(1500)
        TriggerClientEvent('n_Location:spawnCar', _src, car)
        Citizen.Wait(1500)
		TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Conseiller', "Un prélèvement de ~r~"..Price.." ~s~a été effectué sur votre compte pour ~r~une location ~s~!", 'CHAR_BANK_MAZE', 1)

    else 
        Citizen.Wait(500)
        TriggerClientEvent('esx:showAdvancedNotification', _src, 'Banque', 'Conseiller', "Vous n'avez pas suffisament d'argent sur votre compte bancaire ~s~!", 'CHAR_BANK_MAZE', 1)
    end
end)

RegisterNetEvent('n_location:Retour')
AddEventHandler('n_location:Retour', function()
    local _src = source 
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    if xPlayer then 
        TriggerClientEvent('esx:showNotification', source, "Vous avez bien rendu la ~b~location !")
    end 


end)