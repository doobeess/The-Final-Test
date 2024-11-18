---@diagnostic disable: lowercase-global
-- Reminder for me: global is [Variable], local is [variable], constant global is [VARIABLE]

anim8 = require("libraries.anim8")
Player = require('player')


function check_liminality(v, liminal_v) 
    if math.floor(liminal_v) > v then
        v = v + 1
    elseif math.floor(liminal_v)+1 < v or liminal_v == v-1 then
        v = v - 1
    end
    return v, liminal_v
end

function love.conf(t)
    t.console = true
end


function love.load()
    -- Fix pixel art
    love.graphics.setDefaultFilter("nearest", "nearest")

    SCREEN_WIDTH = 200
    SCREEN_HEIGHT = 200
    PIXEL_SIZE = 2

    -- Window width/height
    love.window.setMode(SCREEN_WIDTH*PIXEL_SIZE, SCREEN_HEIGHT*PIXEL_SIZE)

    init_player()

    KL = {}
    KD = {}

    KL.up = "up"
    KL.down = "down"
    KL.right = "right"
    KL.left = "left"
    KL.x = "interact"


    love.keypressed = function(k)
        if KL[k] then KD[KL[k]] = 1 end
    end
    
    love.keyreleased= function(k)
        if KL[k] then KD[KL[k]] = nil end
    end

    -- Will be deleted, used for testing
    Room = {
        {1,1,1,1,1},
        {1,0,0,1,1},
        {1,0,0,0,1},
        {1,0,0,0,1},
        {1,1,1,1,1}
    }
    Tile_Size = 40
end


function love.update(dt)
    if Player.state.id == 'movement' then
        if KD.down then
            Player:walk('front', dt)
        elseif KD.up then
            Player:walk('back', dt)
        elseif KD.right then
            Player:walk('right', dt)
        elseif KD.left then
            Player:walk('left', dt)
        elseif KD.interact then
            Player.state = Player.states.interacting()
        else
            Player:standstill()
        end
    elseif Player.state.id == 'interacting' then
        Player.current_animation = Player.animations[Player.facing..'_interacting']
        if Player.state.duration_left <= 0 then
            Player.state = Player.states.movement()
        else
            Player.state.duration_left = Player.state.duration_left - dt
        end
    end
    
    Player.current_animation:update(dt)
    
end


function love.draw()
    local font = love.graphics.newFont("pixeloid-font/PixeloidSans.ttf", 16)
    love.graphics.setFont(font)
    local rendered_tile_size = Tile_Size * PIXEL_SIZE

    love.graphics.setColor(43, 43, 43)
    for y, row in pairs(Room) do 
        for x, cell in pairs(row) do
            if cell == 1 then 
                love.graphics.rectangle('fill',(x-1)*rendered_tile_size,(y-1)*rendered_tile_size,rendered_tile_size,rendered_tile_size)
            end
        end
    end

    Player.current_animation:draw(Player_SS, Player.x*PIXEL_SIZE, Player.y*PIXEL_SIZE, 0, PIXEL_SIZE, PIXEL_SIZE)
end