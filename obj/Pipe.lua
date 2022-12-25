Pipe = class{}

local PIPE_IMAGE = love.graphics.newImage('/assets/pipe.png')

PIPE_SCROLL_SPEED  = - 60

PIPE_HEIGHT = 433
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH
    self.height = PIPE_HEIGHT

    self.orientation = orientation
    
end

function Pipe:update(dt)
    -- self.x = self.x + PIPE_SCROLL_SPEED * dt
end

function Pipe:render()

    -- love.graphics.draw : 
    --      drawable    - a drawable object
    --      x           - The position to draw the object (x-axis)   
    --      y           - The position to draw the object (y-axis)
    --      r           - Orientation (radians)
    --      sx          - Scale factor (x-axis)
    --      sy          - Scale factor (y-axis)
    --      ...

    love.graphics.draw(PIPE_IMAGE, self.x, 
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), 
        0, 1, self.orientation == 'top' and -1 or 1)
        
end