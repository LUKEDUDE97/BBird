PlayState = class{__includes = BaseState}

function PlayState:init()

    self.bird = Bird()
    self.pipePairs = {}
    self.spawnTimer = 0

    self.score = 0

    -- the first pipePair's coordinate on y-aixs (up-left corner of the obj)
    self.lastY = - PIPE_HEIGHT + math.random(80) + 20 

end

function PlayState:update(dt)
    
    -- respawn one PipePair

    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2 then

        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT, self.lastY + math.random(-20, 20)))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0

    end

    -- update the bird, pipes and record the score

    self.bird:update(dt)

    for key, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH <= self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end

        pair:update(dt)

        if pair.remove then
            table.remove(self.pipePairs, key)
        end
    end

    -- transition to score state : collision detection (pipes and ground)

    for key, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15  then
        gStateMachine:change('score', {
            score = self.score
        })        
    end

end

-- TODO :

-- function tablelength(T)
--     local count = 0
--     for _ in pairs(T) do count = count + 1 end
--     return count
--   end

-- function PlayState:pipeLength()
--     love.graphics.setFont(love.graphics.newFont('font/font.ttf', 8))
--     love.graphics.setColor(0, 255, 0, 255)
--     love.graphics.print('Pipe Counts: ' .. tostring(tablelength(self.pipePairs)), 10, 10)
-- end

function PlayState:render()
    for key, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 0, 0)

    -- self:pipeLength()

    self.bird:render()
end