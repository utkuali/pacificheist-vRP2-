fx_version "adamant"

game "gta5"

description 'vrp2_utk_oranteheist'

server_scripts{
  "@vrp/lib/utils.lua",
  "server_vrp.lua"
}

client_scripts{ 
  "@vrp/lib/utils.lua",
  "client_vrp.lua"
}

files{
  "client.lua"
}