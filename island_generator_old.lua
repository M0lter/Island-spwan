--table.insert(tiles, { name = "grass", position = {x, y}})

local function countAliveNeighbors(grid, _x, _y)
    count = 0
    for y = -1, 1 do
        for x = -1, 1 do
            if (y == 0 and x == 0) then goto continue end -- skip ourself
            if (x + _x < 0 or x + _x >= 32 or y + _y < 0 or y + _y >= 32) then goto continue end -- skip map edges
            if (grid[y + _y][x + _x].name == "grass") then count = count + 1 end
            ::continue::
        end
    end
    return count
end

local function generate_initial()
    for y = 0, 31 do
        tiles[y] = {}
        for x = 0, 31 do
            if (getRandomIntInclusive(1, 100) < 55) then
                tiles[y][x] = {name = "grass", position = {x, y}}
            else
                tiles[y][x] = {name = "water" , position = {x, y}}
            end
        end
    end
    return tiles
end

local function iterate_tiles(tiles)
    new_tiles = {}
    
    for y = 0, 31 do
        new_tiles[y] = {}
        for x = 0, 31 do
            new_tiles[y][x] = tiles[y][x]
            count = countAliveNeighbors(tiles, x, y)
            if (count >= 5 and tiles[y][x].name == "water") then new_tiles[y][x].name = "grass"
            elseif (count <= 3 and tiles[y][x].name == "grass") then new_tiles[y][x].name = "water"
            end
        end
    end
    
    --log("Old Tiles " .. serpent.line(tiles))
    --log("New Tiles " .. serpent.line(new_tiles))
    
    return new_tiles
end

function generate_island(x1, y1)
    
    grid_tiles = generate_initial()
    
    for i = 0, 14 do
        grid_tiles = iterate_tiles(grid_tiles)
    end
    
    tiles = {}
    for y = 0, 31 do
        for x = 0, 31 do
            grid_tiles[y][x].position[1] = grid_tiles[y][x].position[1] + x1
            grid_tiles[y][x].position[2] = grid_tiles[y][x].position[2] + y1
            table.insert(tiles, grid_tiles[y][x])
        end
    end
    
    return tiles
end