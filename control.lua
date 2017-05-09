require "locale/utils/event" --Yes this line is seriously commented out, and yes without this it won't even work. I guess you now HAVE TO change the settings to match what you need.
require "permissions" --Permission manager
require "trusted" --Module to add trusted players to a seperate permission group
require "locale/utils/patreon" --Module to give patreons spectate and a nice unique tag
require "locale/utils/admin"	--Admin module to give the admins spectate, commands and character modifications.
require "announcements"	--Module to announce stuff ingame / give the players a welcome message
require "tag" --Module to let players set a tag behind their names to improve teamwork
require "fmcd" --Module to consolidate saving data to an output file for the agent
require "stats" --Module to generate stats and print them to the filesystem
require "popup" --Module to create and display an popup in the center of all players their screens.
require "rules" --Module which displays a popup with the rules when a player joins, or presses the open rules button
require "rocket" --Module to stop people removing the rocket silo
require("config")
require("util")
require("entity_generator")
require("spawn_generator")
require("water_generator")
require("island_generator")


-- Player Created event
script.on_event(defines.events.on_player_created, function(event)
        local player = game.players[event.player_index]
        player.insert{name="iron-plate", count=8}
        player.insert{name="steel-axe", count=1}
        player.insert{name="burner-mining-drill", count = 2}
        player.insert{name="stone-furnace", count = 2}
        player.insert{name="small-electric-pole", count = 4}
		player.insert{name="landfill", count = 50}
		
        if DEBUG then
            player.insert{name="landfill", count=2000}
        end

        if START_WITH_LANDFILL_RESEARCHED then
            player.force.technologies['landfill'].researched = true
        end
end)

-- Chunk Generated event
script.on_event(defines.events.on_chunk_generated, function(event)
        local x1 = event.area.left_top.x
        local y1 = event.area.left_top.y
        local x2 = event.area.right_bottom.x
        local y2 = event.area.right_bottom.y
        --local width = math.abs(x2) - math.abs(x1)
        --local height = math.abs(y2) - math.abs(y1)
        local surface = event.surface

        -- destroy decoratives
        surface.destroy_decoratives({{x1, y1}, {x2, y2}})

        -- destroy all entities
        entList = surface.find_entities({{x1, y1}, {x2, y2}})

        for i, ent in ipairs(entList) do
            if ent.name ~= "player" then
                ent.destroy()
            end
        end

        -- set water or grass
        -- create entity
        tiles = {}
        in_spawn = does_square_intersect(x1, y1, x2, y2, -SPAWN_SIZE, -SPAWN_SIZE, SPAWN_SIZE, SPAWN_SIZE)
        
        typeoftiles = "none"
        
        if (in_spawn) then
            tiles = get_spawn_tiles(surface, x1, y1, x2, y2)
            typeoftiles = "spawn"
        elseif (getRandomIntInclusive(1,100) <= ISLAND_SPAWN_CHANCE) then
            tiles = get_island_tiles(surface, x1, y1, x2, y2)
            typeoftiles = "island"
        else
            tiles = get_water_tiles(x1, y1, x2, y2)
            typeoftiles = "water"
        end
        
        -- set tiles
        if (typeoftiles == "island") then
            --log(serpent.block(tiles))
        end
        surface.set_tiles(tiles)
end)

-- Player Built Tile event
script.on_event(defines.events.on_player_built_tile, function(event)
        local player = game.players[event.player_index]
        local surface = player.surface
        local positions = event.positions

        for i, pos in ipairs(positions) do
            spawn_built_ore(surface, pos.x, pos.y)
        end
end)