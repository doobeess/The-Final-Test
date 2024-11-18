require('misc')

function check_tilemap_collision(hitbox)
    for y, row in pairs(slice(Room, math.floor(hitbox.y/Tile_Size)+1, math.floor((hitbox.y+hitbox.height)/Tile_Size)+1)) do
        for x, cell in pairs(
            slice(row, math.floor(hitbox.x/Tile_Size)+1, math.floor((hitbox.x+hitbox.width)/Tile_Size)+1)
        ) do
            if cell == 1 then
                return true
            end
        end
    end
    return false
end

function hitbox(x, y, width, height)
    return {
        x = x,
        y = y,
        width = width,
        height = height
    }    
end

function overlaps(hitbox1, hitbox2)
    if hitbox1.y + hitbox1.height <= hitbox2.y -- Is above
        or hitbox1.y <= hitbox2.y + hitbox2.height -- Is below
        or hitbox1.x + hitbox1.width <= hitbox2.x -- Is left
        or hitbox1.x <= hitbox2.x + hitbox2.width -- Is right
        then
        
        return false
    end

    return true -- Is none of those things, therefore it must be overlapping
end