local text = [[- Puzzle Trial -

Programming by Rin.

Character art by @cloverkomaeda@twitter.com.

Background music by Hurt Record.

- Special thanks -
Oshisaure
0xFC
LewisTehMinerz
NoraVR

My hopes are to see this game become a fully-featured game.
Until then, have this text.]]

return {
    on = function(self)
        stopmusic()
        playmusic('credits')
        self.position = love.timer.getTime()
    end,
    draw = function(self)
        love.graphics.setFont(font.reg2)
        love.graphics.print(text, 20, 600 - ((self.position - love.timer.getTime()) * font.reg2:getHeight('h')*1.5)*-1)
    end,
    keydown = function(self, k)
        if k == 'escape' then stopmusic() switchstate('title') end
    end
}