local text = [[This game contains disorienting graphical effects,
along with some flashing lights.

If you're susceptible to epilepsy, or are otherwise
easily disoriented, please do not play this game.]]

local timerDur = 10

return {
    on = function(self)
        self.timer = love.timer.getTime()
    end,
    update = function(self)
        local e = love.timer.getTime() - self.timer
        if e >= timerDur then
            switchstate('title')
        end
    end,
    draw = function(self)
        local e = love.timer.getTime() - self.timer
        love.graphics.setFont(font.reg2)
        love.graphics.print(text, (800/2)-(width(text)/2), (600/4)+50)
        love.graphics.setFont(font.big)
        love.graphics.print('Warning!', (800/2)-(width('Warning!')/2), (600/4)-25)

        love.graphics.setFont(font.reg2)
        love.graphics.print(round(timerDur-e, 1), (800/2)-(width('0.0')/2), (600/2)+50)
    end
}
