push = require "lib.push"
class = require "lib.class"

require "obj.Bird"
require "obj.Pipe"
require "obj.PipePair"

require "StateMachine"
require "states.BaseState"
require "states.TitleScreenState"
require "states.PlayState"
require "states.ScoreState"
require "states.CountDownState"

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

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('font/font.ttf', 8)
    mediumFont = love.graphics.newFont('font/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('font/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('font/flappy.ttf', 56)

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOE_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        fullscreen = false, 
        resizable = true
    })

    -- build state machine
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end,
        ['count'] = function() return CountDownState() end
    }
    gStateMachine:change('title')

    -- record the input keys once pressed 
    love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

-- Keypress Control --

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

    -- the background and ground keep scrolling at any states

    -- scroll the background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT
    
    -- scroll the ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
        % GROUND_LOOPING_POINT

    -- update according to current state
    gStateMachine:update(dt)

    -- empty the input keys table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background starting at top left (0, 0)
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()  -- notice on drawing order

    -- draw the ground on top of the background, toward the bottom of the screen 
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)  -- the height of our "gournd image" : 16

    push:finish()
end