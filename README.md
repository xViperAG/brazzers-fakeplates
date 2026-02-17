![Brazzers Development Discord](https://i.imgur.com/nXhPxIO.png)

<details>
    <summary><b>Important Links</b></summary>
        <p>
            <a href="https://discord.gg/J7EH9f9Bp3">
                <img alt="GitHub" src="https://logos-download.com/wp-content/uploads/2021/01/Discord_Logo_full.png"
                width="150" height="55">
            </a>
        </p>
        <p>
            <a href="https://ko-fi.com/mannyonbrazzers">
                <img alt="GitHub" src="https://uploads-ssl.webflow.com/5c14e387dab576fe667689cf/61e11149b3af2ee970bb8ead_Ko-fi_logo.png"
                width="150" height="55">
            </a>
        </p>
</details>

# Installation steps

## General Setup
Very simple persistent fake plate script. I didn't see one made so here you go

Preview: https://www.youtube.com/watch?v=PsGh2FnSM1o

## Exports Usage
This gets the original plate from the fake plate. Input the fake plate number in the plate param
```lua
    local originalPlate = exports['brazzers-fakeplates']:getPlateFromFakePlate(plate)
    if originalPlate then plate = originalPlate end
```
This gets the fake plate from the original plate. Input the original plate number in the plate param
```lua
    local fakePlate = exports['brazzers-fakeplates']:getFakePlateFromPlate(plate)
    if fakePlate then plate = fakePlate end
```

## Features
1. Persistent Fake Plates ( Saves through garages )
2. Synced Plate Changing
3. Multi-Language Support using QBCore Locales
4. 24/7 Support in discord

## Dependencies
1. ox_target
2. oxmysql
3. qbx_core
4. ox_inventory