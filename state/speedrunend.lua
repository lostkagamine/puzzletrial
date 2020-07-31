return {
    on = function(self)
        if game.save.speedrunTime < 0 then
            -- no time
            self.hasTime = false
            game.save.speedrunTime = game.speedrunfinaltime
            saveFile()
        else
            self.hasTime = true
            self.pastTime = game.save.speedrunTime
            if game.save.speedrunTime > game.speedrunfinaltime then
                self.beatTime = true
                game.save.speedrunTime = game.speedrunfinaltime 
                saveFile()
            end
        end
        self.htimer = 0
    end,
    update = function(self, dt)
        self.htimer = self.htimer + (dt*40)
    end,
    draw = function(self)
        love.graphics.setFont(font.big)
        love.graphics.print('Congratulations!', 20, 20)
        local st = game.speedrunfinaltime
        local stex = string.format('%02d:%02d.%02d', math.floor(st / 60), math.floor(math.fmod(st, 60)), math.floor((st*100)%100))
        love.graphics.setFont(font.big)
        love.graphics.print(stex, (800/2)-(width(stex)/2), 135)

        love.graphics.setFont(font.reg2)
        if not self.hasTime then
            love.graphics.print('You have completed Speedrun Mode for the first time in:\n\n\n\n\nTry again to beat your time!', 20, 100)
        else
            love.graphics.print('You have completed Speedrun Mode in:\n\n\n\n\nYour personal best time is:', 20, 100)
            local ost = self.pastTime
            local oldtime = string.format('%02d:%02d.%02d', math.floor(ost / 60), math.floor(math.fmod(ost, 60)), math.floor((ost*100)%100))
            love.graphics.setFont(font.big)
            love.graphics.print(oldtime, (800/2)-(width(oldtime)/2), 265)
            if self.beatTime then
                local h = hue(math.fmod(self.htimer, 360))
                love.graphics.setColor(h)
                love.graphics.print('New Best!', (800/2)-(width('New Best!')/2), 330)
            end
        end

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setFont(font.reg2)
        love.graphics.print('Press [ESCAPE] to return to the title screen.', 20, (600-height('l')-20))
    end,
    keydown = function(self, k)
        if k == 'escape' then
            switchstate('title')
        end
    end
}