# Pacific Standard Bank Heist Script by utku

Made by **utku#9999 (UTK)**

Converting form ESX to vRP by **AceDax#0394** and **BradXY#5882**

[ESX version](https://github.com/utkuali/pacificheist-ESX-)
[vRP0.5 / Dunko vRP version](https://github.com/utkuali/pacificheist-vRP)

You can edit this freely. If you want to share an improved or edited version of this script, just please ask for my permission and credit me.

Changing the file names breaks the script. Just don't change it.

[My Discord](https://discord.gg/yqHmvcr)

I share my ideas and announce upcoming scripts here, join if you are interested. I also try to help people as long as I have time, but you are encouraged to ask for help in FiveM forum.

[My Patreon](https://www.patreon.com/utkforeva)

I share my scripts to my Patrons very early for them to test and provide feedback, so that I can fix issues before the public release. This script had lots of bugs, issues and missing features which I fixed with the helps of my Patrons. You can support my work here if you want.

## Installation

This script is made for **vRP2** not **Dunko vRP** or **vRPEX**.

### Updating vRP Folder

- Change *__resource.lua* file name to *fxmanifest.lua*

- Inside fxmanifest.lua add these lines:

```lua
fx_version "adamant"

game "gta5"
```

- Open vrp/client/map.lua and change the fallowing lines:

```lua
-- line 87
SetBlipSprite(self.blip, 29)

--line 144
SetBlipSprite(self.blip, 29)
```

- Open vrp/client/garage.lua and add these lines accordingly:

add this:

```lua
local id = NetworkGetNetworkIdFromEntity(nveh)  
    SetNetworkIdCanMigrate(id, true)
```

after

```lua
local nveh = CreateVehicle(mhash, x,y,z+0.5, 0.0, true, false)
```

and comment out **SetEntityAsMissionEntity(nveh, true, true)**

After that, replace **function Garage:despawnVehicle(model)** with

```lua
function Garage:despawnVehicle(model)
    local veh = self.vehicles[model]
  
    if veh then
        vRP:triggerEvent("garageVehicleDespawn", model)
        SetEntityAsMissionEntity(veh, false, true)
        DeleteVehicle(veh)
        self.vehicles[model] = nil
        return true
    end
end
```

- Also make sure you have provided a some sort of way of reaching the item "lockpick", "thermal_charge" and "laptop_h" to your players because they are essential to the heist.

- Make sure to start *utk_ornateprops* before *vrp2_utk_ornateheist*

## Configuration

- There are lots of comment lines inside the code for you to understand better.
