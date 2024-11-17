---@diagnostic disable: lowercase-global
-- Reminder for me: global is [Variable], local is [variable], constant global is [VARIABLE]

anim8 = require("libraries.anim8")
Player = require('player')


function check_liminality(v, liminal_v) 
    if math.abs(liminal_v) > v then
        v = v + 1
    elseif math.abs(liminal_v)+1 < v or liminal_v == v-1 then
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

    PIXELS_WIDTH = 200
    PIXELS_HEIGHT = 200
    PIXEL_SIZE = 2

    -- Window width/height
    love.window.setMode(PIXELS_WIDTH*PIXEL_SIZE, PIXELS_HEIGHT*PIXEL_SIZE)

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

    Player.current_animation:draw(Player_SS, Player.x*PIXEL_SIZE, Player.y*PIXEL_SIZE, 0, 4, 4)
end