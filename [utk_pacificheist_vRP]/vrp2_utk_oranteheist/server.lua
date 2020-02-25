local vRPoranteheist = class("vRPoranteheist", vRP.Extension)
local mincash = 5000 -- minimum amount of cash a pile holds
local maxcash = 15000 -- maximum amount of cash a pile can hold
local black = true -- enable this if you want blackmoney as a reward
local mincops = 0 -- minimum required cops to start mission
local enablesound = true -- enables bank alarm sound
local lastrobbed = 0 -- don't change this
local cooldown = 1800 -- amount of time to do the heist again in seconds (30min)
local info = {stage = 0, style = nil, locked = false}
local totalcash = 0
local PoliceDoors = {
    {loc = vector3(257.10, 220.30, 106.28), txtloc = vector3(257.10, 220.30, 106.28), model = "hei_v_ilev_bk_gate_pris", obj = nil, locked = true},
    {loc = vector3(236.91, 227.50, 106.29), txtloc = vector3(236.91, 227.50, 106.29), model = "v_ilev_bk_door", obj = nil, locked = true},
    {loc = vector3(262.35, 223.00, 107.05), txtloc = vector3(262.35, 223.00, 107.05), model = "hei_v_ilev_bk_gate2_pris", obj = nil, locked = true},
    {loc = vector3(252.72, 220.95, 101.68), txtloc = vector3(252.72, 220.95, 101.68), model = "hei_v_ilev_bk_safegate_pris", obj = nil, locked = true},
    {loc = vector3(261.01, 215.01, 101.68), txtloc = vector3(261.01, 215.01, 101.68), model = "hei_v_ilev_bk_safegate_pris", obj = nil, locked = true},
    {loc = vector3(253.92, 224.56, 101.88), txtloc = vector3(253.92, 224.56, 101.88), model = "v_ilev_bk_vaultdoor", obj = nil, locked = true}
}

function vRPoranteheist:__construct()
    vRP.Extension.__construct(self)
    RegisterServerEvent("utk_oh:gettotalcash")
    AddEventHandler("utk_oh:gettotalcash", function()
        local user = vRP.users_by_source[source]

        self.remote._sendAlert(user.source, "success", "You stole $"..totalcash)
    end)
end

RegisterServerEvent("utk_oh:removeitem")
AddEventHandler("utk_oh:removeitem", function(itemname)
    local user = vRP.users_by_source[source]

    user:tryTakeItem(itemname,1)
end)

RegisterServerEvent("utk_oh:updatecheck")
AddEventHandler("utk_oh:updatecheck", function(var, status)
    TriggerClientEvent("utk_oh:updatecheck_c", -1, var, status)
end)

RegisterServerEvent("utk_oh:toggleDoor")
AddEventHandler("utk_oh:toggleDoor", function(door, coords, status)
    TriggerClientEvent("utk_oh:toggleDoor_c", -1, door, coords, status)
end)

RegisterServerEvent("utk_oh:policeDoor")
AddEventHandler("utk_oh:policeDoor", function(doornum, status)
    PoliceDoors[doornum].locked = status
    TriggerClientEvent("utk_oh:policeDoor_c", -1, doornum, status)
end)

RegisterServerEvent("utk_oh:moltgate")
AddEventHandler("utk_oh:moltgate", function(x, y, z, oldmodel, newmodel, method)
    TriggerClientEvent("utk_oh:moltgate_c", -1, x, y, z, oldmodel, newmodel, method)
end)

RegisterServerEvent("utk_oh:fixdoor")
AddEventHandler("utk_oh:fixdoor", function(hash, coords, heading)
    TriggerClientEvent("utk_oh:fixdoor_c", -1, hash, coords, heading)
end)

RegisterServerEvent("utk_oh:openvault")
AddEventHandler("utk_oh:openvault", function(method)
    TriggerClientEvent("utk_oh:openvault_c", -1, method)
end)

RegisterServerEvent("utk_oh:startloot")
AddEventHandler("utk_oh:startloot", function()
    TriggerClientEvent("utk_oh:startloot_c", -1)
end)

RegisterServerEvent("utk_oh:rewardCash")
AddEventHandler("utk_oh:rewardCash", function()
    local user = vRP.users_by_source[source]
    local reward = math.random(mincash, maxcash)

    if black then
        user:tryGiveItem('dirty_money', reward, false)
        totalcash = totalcash + reward
    else
        user:tryGiveItem("money",reward, false)
        totalcash = totalcash + reward
    end
end)

RegisterServerEvent("utk_oh:rewardGold")
AddEventHandler("utk_oh:rewardGold", function()
    local user = vRP.users_by_source[source]

    user:tryGiveItem("gold_brick", 1,false)
end)

RegisterServerEvent("utk_oh:rewardDia")
AddEventHandler("utk_oh:rewardDia", function()
    local user = vRP.users_by_source[source]

    user:tryGiveItem("dia_box", 1,false)
end)

RegisterServerEvent("utk_oh:giveidcard")
AddEventHandler("utk_oh:giveidcard", function()
    local user = vRP.users_by_source[source]

    user:tryGiveItem("id_card", 1,false)
end)

RegisterServerEvent("utk_oh:ostimer")
AddEventHandler("utk_oh:ostimer", function()
    lastrobbed = os.time()
    info.stage, info.style, info.locked = 0, nil, false
    Citizen.Wait(300000)
    totalcash = 0
    TriggerClientEvent("utk_oh:reset", -1)
end)

RegisterServerEvent("utk_oh:gas")
AddEventHandler("utk_oh:gas", function()
    TriggerClientEvent("utk_oh:gas_c", -1)
end)

RegisterServerEvent("utk_oh:ptfx")
AddEventHandler("utk_oh:ptfx", function(method)
    TriggerClientEvent("utk_oh:ptfx_c", -1, method)
end)

RegisterServerEvent("utk_oh:alarm_s")
AddEventHandler("utk_oh:alarm_s", function(toggle)
    if enablesound then
        local audio = "https://s0.vocaroo.com/media/download_temp/Vocaroo_s0uuSMNZWD3B.mp3"
        vRP.EXT.Audio.remote._setAudioSource(-1, "Alarm", audio, 0.1, 252.82916259766,222.19030761719,101.6834487915, 80)
    end
    vRP.EXT.Phone:sendServiceAlert(user.source, "911" ,252.82916259766,222.19030761719,101.6834487915, "Robbery in progress at Pacific Standards")
end)

function Digits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. _U('locale_digit_grouping_symbol')):reverse())..right
end

vRP.EXT.Inventory:defineItem("thermal_charge", "Thermal Charge", "A small thermal charge for breaking locks.", nil, 1.0)
vRP.EXT.Inventory:defineItem("laptop_h", "Laptop", "A portable computer for multiple uses..", nil, 1.0)
vRP.EXT.Inventory:defineItem("id_card", "Debug Card", "A wireless debug tool for hacking systems.", nil, 1.0)
vRP.EXT.Inventory:defineItem("gold_brick", "Gold Brick", "Solid Gold.", nil, 1.0)
vRP.EXT.Inventory:defineItem("dia_box", "Diamond Box", "A box of diamonds.", nil, 1.0)

vRPoranteheist.event = {}

function vRPoranteheist.event:playerJoinGroup(user)
    self.remote.setInfo(user.source, info)
end

function vRPoranteheist.event:playerStateLoaded(user)
    if user and user:isReady() then
        self.remote.setInfo(user.source, info)
        self.remote.setState(user.source)
    end
end

vRPoranteheist.tunnel = {}

function vRPoranteheist.tunnel:GetDoors()
    local user = vRP.users_by_source[source]

    self.remote._returnDoors(user.source, PoliceDoors)
end

function vRPoranteheist.tunnel:policeCheck()
    local user = vRP.users_by_source[source]

    if user:hasPermission("police.key") then
	    return true
    end
    return false
end

function vRPoranteheist.tunnel:checkItem(itemname)
    local user = vRP.users_by_source[source]

    if user:hasPermission("!item."..itemname..".>0") then
        return true
    else
        return false
    end
end

function vRPoranteheist.tunnel:startevent(method)
    local user = vRP.users_by_source[source]
    local cops = vRP.EXT.Group:getUsersByPermission("bank.cops")

    if not info.locked then
        if (os.time() - cooldown) > lastrobbed then
            if #cops >= mincops then
                if method == 1 then
                    if user:hasPermission("!item.thermal_charge.>0") then
                        user:tryTakeItem("thermal_charge",1)
                        info.stage = 1
                        info.style = 1
                        info.locked = true
                        return true
                    else
                        self.remote._sendAlert(user.source, "error", "You don't have any thermal charges.")
                    end
                elseif method == 2 then
                    if user:hasPermission("!item.lockpick.>0") then
                        user:tryTakeItem("lockpick",1)
                        info.stage = 1
                        info.style = 2
                        info.locked = true
                        return true
                    else
                        self.remote._sendAlert(user.source, "error", "You don't have any lockpicks.")
                    end
                end
            else
                self.remote._sendAlert(user.source, "error", "There must be at least "..mincops.." police in the city.")
            end
        else
            self.remote._sendAlert(user.source, "error", math.floor((cooldown - (os.time() - lastrobbed)) / 60)..":"..math.fmod((cooldown - (os.time() - lastrobbed)), 60).." left until the next robbery.")
        end
    else
        self.remote._sendAlert(user.source, "error", "Bank is currently being robbed.")
    end
end

vRP:registerExtension(vRPoranteheist)