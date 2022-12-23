PipePair = class{}

local GAP_HEIGHT = 110

function PipePair:init(y)
    
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- whether this PipePair is ready to be removed from the screen 
    self.remove = false

    -- whether or not this pair of pipes has been passed / scored
    self.scored = false

end

function PipePair:update(dt)
    
    if self.x > - PIPE_WIDTH then
        self.x = self.x + PIPE_SCROLL_SPEED * dt
        self.pipes['upper'].x = self.x
        self.pipes['lower'].x = self.x
    else
        self.remove = true
    end

end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
