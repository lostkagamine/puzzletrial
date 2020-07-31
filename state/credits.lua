local text = ([[--- Puzzle Trial ---

Programming
Background art
Game design
Shader programming
Course design

by
Rin

Uses boipushy input library

Character art by @cloverkomaeda on Twitter

Background music provided by Hurt Record
https://www.hurtrecord.com



Thank you for playing my first full release.
It really means a lot to me
that someone would check this game out.



Special thanks
Oshisaure
0xFC963F18DC21

Inspired by
A Gnowius' Challenge
by Oshisaure





%s


Press [ESCAPE] to return to the title screen.]]):format(
    (game.save.cleared.grandmaster) and 'Congratulations on completing the final challenge.\nYou have truly mastered this game.' or (
    (game.save.cleared.intermediate and game.save.cleared.advanced and game.save.cleared.introductory) and 'The final challenge is now open to play.\nGo to the Course Select screen.' or '')
)

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