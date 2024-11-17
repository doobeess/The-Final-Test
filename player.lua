INTERACTION_DURATION = 1

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
            front_interacting = anim8.newAnimation(g('1-2', 4), 0.1),
            back_interacting = anim8.newAnimation(g('2-3', 5), 0.1),
            right_interacting = anim8.newAnimation(g(3,4, 1,5), 0.1),
            left_interacting = anim8.newAnimation(g(3,4, 1,5), 0.1):flipH(),
        },
        states = {
            movement = function () return {
                id = 'movement'
            } end,
            interacting = function () return {
                id = 'interacting',
                duration_left = INTERACTION_DURATION
            } end
        }
    }

    Player.state = Player.states.movement()
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
        self.current_animation = Player.animations[Player.facing]
        self.liminal_x = self.x
        self.liminal_y = self.y
    end
end