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
    end,
    draw = function(self)
        love.graphics.setFont(font.reg2)
    end,
    keydown = function(self, k)
        if k == 'escape' then stopmusic() switchstate('title') end
    end
}