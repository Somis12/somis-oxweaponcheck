local weaponlist = {}
local function toUnsigned32(n)
    if n < 0 then
        return n + 4294967296
    end
    return n
end

local function isEntityPed(entity)
    return GetEntityType(entity) == 1
end

Citizen.CreateThread(function()
    Citizen.Wait(1000) 
    local items = exports.ox_inventory:Items()
    if items then
        for name, item in pairs(items) do
            if item.weapon == true then
                table.insert(weaponlist, item.name:lower())
            end
        end
    end
end)


local function GetWeaponNameFromHash(hash)
    local hashUnsigned = toUnsigned32(hash)
    for _, weaponName in pairs(weaponlist) do
        if toUnsigned32(GetHashKey(weaponName)) == hashUnsigned then
            return weaponName
        end
    end
    return nil
end

local serv_cooldown2 = {}
local cooldown_duration2 = config.relaxed_timer

AddEventHandler('weaponDamageEvent', function(shooter, data)
    if data.damageType ~= 3 then return end
    if config.relaxedmode then
    local now = GetGameTimer()
    if serv_cooldown2[shooter] and now < serv_cooldown2[shooter] then
        return 
    end
    serv_cooldown2[shooter] = now + cooldown_duration2
end
if data.weaponType == 2725352035 or data.weaponType == 2741846334 then
    local entity = NetworkGetEntityFromNetworkId(data.hitGlobalId)
    local shooterPed = GetPlayerPed(shooter)
    if not DoesEntityExist(entity) or not isEntityPed(entity) or not IsPedAPlayer(entity) then 
        return 
    end
    local shooterCoords = GetEntityCoords(shooterPed)
    local victimCoords = GetEntityCoords(entity)
    local distance = #(shooterCoords - victimCoords)
    if distance > 5.0 then
        DropPlayer(shooter, "lol")
        return
    end
end
    local weapon_namos_koskos = GetWeaponNameFromHash(data.weaponType)
    if not weapon_namos_koskos then
        return 
    end
    local caountos_mosmos = exports.ox_inventory:GetItemCount(tonumber(shooter), weapon_namos_koskos)
    if caountos_mosmos > 0 then
        return 
    end
        DropPlayer(shooter, "somis detected something weird with your weapon....")

end)


