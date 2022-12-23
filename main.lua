push = require "lib.push"
class = require "lib.class"

require "obj.Bird"
require "obj.Pipe"
require "obj.PipePair"

WINDOE_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("/assets/background.png")
local backgroundScroll = 0

local ground = love.graphics.newImage("/assets/ground.png")
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

local bird = Bird()

local pipePairs = {}
-- the first pipePair's coordinate on y-aixs (up-left corner of the obj)
local lastY = - PIPE_HEIGHT + math.random(80) + 20 

local spawnTimer = 0

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOE_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        fullscreen = false, 
        resizable = true
    })

    love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- kepp record the keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key ==  'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    -- scroll the background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT
    
    -- scroll the ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % GROUND_LOOPING_POINT

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT, lastY + math.random(-20, 20)))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    -- update the bird and pipes

    bird:update(dt)

    for key, pair in pairs(pipePairs) do
        pair:update(dt)
    end

    -- remove any flagged (out of left boundary of the screen) PipePairs 
    for key, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, key)
        end
    end

    love.keyboard.keysPressed = {}
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end

function displayInfo()
    love.graphics.setFont(love.graphics.newFont('font/font.ttf', 8))
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('Pipe Counts: ' .. tostring(tablelength(pipePairs)), 10, 10)
end

function love.draw()
    push:start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)

    -- be careful about the order of drawing procedure, we want it likes the pipe sticks out from the ground
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen 
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)  -- the height of our "gournd image" : 16

    bird:render()

    displayInfo()

    push:finish()
end