---@diagnostic disable: lowercase-global
-- Reminder for me: global is [Variable], local is [variable], constant global is [VARIABLE]

anim8 = require("libraries.anim8")


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

function init_player()
    -- Player spritesheet/grid
    Player_SS = love.graphics.newImage('assets/player.png')
    local g = anim8.newGrid(8, 12, Player_SS:getWidth(), Player_SS:getHeight())

    -- Player object
    Player = {
        x = 20,
        y = 20,
        liminal_x = 20,
        liminal_y = 20,
        speed = 60,
        facing = 'front',
        spritesheet = love.graphics.newImage('assets/player.png'), -- accessed by animation:draw
        animations = {
            front = anim8.newAnimation(g(1,1), 1),
            back = anim8.newAnimation(g(1,3), 1),
            right = anim8.newAnimation(g(1,2), 1),
            left = anim8.newAnimation(g(1,2), 1):flipH(),
            front_walk = anim8.newAnimation(g('2-3',1), 0.1),
            back_walk = anim8.newAnimation(g('2-3',3), 0.1),
            right_walk = anim8.newAnimation(g('2-3',2), 0.1),
            left_walk = anim8.newAnimation(g('2-3',2), 0.1):flipH(),
        }
    }
    Player.current_animation = Player.animations[Player.facing]

    Directions = {
        front = {0,1},
        back = {0,-1},
        right = {1,0},
        left = {-1,0}
    }

    function Player:walk(direction, dt)
        self.current_animation = Player.animations[direction..'_walk']

        self.liminal_x = self.liminal_x + (Directions[direction][1] * self.speed * dt)
        self.liminal_y = self.liminal_y + (Directions[direction][2] * self.speed * dt)

        self.x, self.liminal_x = check_liminality(self.x, self.liminal_x)
        self.y, self.liminal_y = check_liminality(self.y, self.liminal_y)
        print(self.x.." "..self.liminal_x)

        self.facing = direction
    end

    function Player:standstill()
        self.current_animation = Player.animations[self.facing]
        self.liminal_x = self.x
        self.liminal_y = self.y
    end
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


    love.keypressed = function(k)
        if KL[k] then KD[KL[k]] = 1 end
    end
    
    love.keyreleased= function(k)
        if KL[k] then KD[KL[k]] = nil end
    end
end


function love.update(dt)

    if KD.down then
        Player:walk('front', dt)
    elseif KD.up then
        Player:walk('back', dt)
    elseif KD.right then
        Player:walk('right', dt)
    elseif KD.left then
        Player:walk('left', dt)
    else
        Player:standstill()
    end

    Player.current_animation:update(dt)
    
end


function love.draw()
    local font = love.graphics.newFont("pixeloid-font/PixeloidSans.ttf", 16)
    love.graphics.setFont(font)

    Player.current_animation:draw(Player_SS, Player.x*PIXEL_SIZE, Player.y*PIXEL_SIZE, 0, 4, 4)
end