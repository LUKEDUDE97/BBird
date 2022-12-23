Bird = class{}

local GRAVITY = 20

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('/assets/bird.png') -- all start from root dir
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- very center of the screen 
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:collides(pipe)
    
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + pipe.height then
            return true
        end
    end

    return false
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    -- apply the gravity to the y velocity
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = - 5
    end

    -- apply the current velocity to Y position
    self.y = self.y + self.dy
end