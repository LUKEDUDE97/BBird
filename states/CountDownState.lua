CountDownState = class{__includes = BaseState}

COUNTDOWN_SECOND = 0.75

function CountDownState:init()
    self.timer = 0
    self.count = 3
end

function CountDownState:update(dt)
    self.timer = self.timer + dt
    
    if self.timer > COUNTDOWN_SECOND then
        self.timer = self.timer % COUNTDOWN_SECOND
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end