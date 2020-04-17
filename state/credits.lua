return {
    on = function(self)
        stopmusic()
        playmusic('credits')
    end,
    draw = function(self)
        love.graphics.setFont(font.reg2)
        love.graphics.print([[Thank you for playing this very early build of Puzzle Trial.
Stay tuned for more news as the game develops
into a fully-fledged game.
(This screen is a placeholder while I think of something.)

Programming by Rin (ry00001)
Music by Hurt Record
(Mirera, Mikiya Komaba, Jishou Geijutsu Kameesan)
Graphics by Rin
Character art by Max/Stardust

Fonts from Google Font Library
Powered by Love2D]], 20, 20)
    end,
    keydown = function(self, k)
        if k == 'escape' then stopmusic() switchstate('title') end
    end
}