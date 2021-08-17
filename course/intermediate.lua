return {
    name = "Intermediate Course",
    music = "level2",
    sort = 1,
    stages = {
        {
            {
                "[happy]Welcome to the Intermediate Course!",
                "[happy]I'm gonna assume you've played the Introductory Course,\nbut if you haven't, now's the time to go play it.",
                "[smug]Anyway, let's get started!",
                "Rotations are pretty important, huh?\nWhat if I limit you?",
                "[smug]Don't rotate more than twice for each piece!"
            },
            objective = "Clear 10 lines without\nrotating more than twice\nfor each piece!",
            rotation="ars",
            update = function(self, dt)
                if gamestate.rotationsPerPiece >= 2 then
                    self.blockRotate = true
                else
                    self.blockRotate = false
                end
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/10 - %d"):format(gamestate.lines, gamestate.rotationsPerPiece)
            end
        },
        {
            {
                "[smug]Long-standing Tetris players might know this one...",
                "[happy]Ever heard of a game called BBlocks?",
                "It's pretty bad.",
                "[happy]There's something it does, that I'll try to recreate.",
                "[smug]Here we go!"
            },
            objective = "Clear 15 lines!",
            postInit = function(self, gs)
                gs.disabledPieces = {"T"}
            end,
            update = function(self, dt)
                if gamestate.lines >= 15 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/15"):format(gamestate.lines)
            end
        },
        {
            {
                "[smug]Flash quiz: what's the worst piece in the game?",
                "...Did you say O? No. It's S/Z."
            },
            objective = "Clear 5 lines!",
            postRngInit = function(self, gs)
                for i, j in ipairs(gs.nextQueue) do
                    gs.nextQueue[i] = 'S'
                    if math.fmod(i, 2) == 0 then
                        gs.nextQueue[i] = 'Z'
                    end
                end
            end,
            update = function(self, dt)
                if gamestate.lines >= 5 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/5"):format(gamestate.lines)
            end
        },
        {
            {
                "It's time for more shaders!!!",
                "...Should I have done this?"
            },
            objective = "Clear 10 lines!",
            postInit = function(self)
                self.timer = 0
                self.started = false
            end,
            onStart = function(self)
                self.started = true
                currentEffect = effects.vhs
                enableshader('fuck')
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
                self.timer = self.timer + dt
            end,
            getGoalText = function(self)
                return ("%d/10"):format(gamestate.lines)
            end,
            draw = function(self)
                if not self.started then return end
                love.graphics.setFont(font.big)
                if math.fmod(self.timer, 2) < 0.5 then
                    love.graphics.print("TRACK", 20, 20)
                end
            end
        },
        {
            {
                "Advanced techniques return in this advanced stage!",
                "Let's do some T-Triples!"
            },
            objective = "Do 5 T-Spin Triples!",
            postInit = function(self, gs)
                self.b2bs = 0
            end,
            onClear = function(self, lines, spin, mini)
                if lines == 3 and spin then -- I have no idea how you'd do a mini-t-triple but
                    self.b2bs = self.b2bs + 1
                end
                if self.b2bs >= 5 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/5"):format(self.b2bs)
            end
        },
        {
            {
                "Can you do... two perfect clears?",
            },
            objective = "Do 2 Perfect Clears!",
            postInit = function(self)
                self.pcs = 0
            end,
            onClear = function(self, lines, spin, mini)
                if lines >= 1 and not gamestate.board:hasAnyBlocks() then
                    self.pcs = self.pcs + 1
                end
                if self.pcs >= 2 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/2"):format(self.pcs)
            end
        },
        {
            {
                "So, the Roll-Roll stage was a bit of a foreshadowing.",
                "[smug]Reversal time!!"
            },
            objective = "Clear 10 lines!",
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/10"):format(gamestate.lines)
            end,
            postInit = function(self, gs)
                gs.lrReverse = true
            end
        },
        {
            {
                "Time for... fast drop... with a twist!"
            },
            objective = "Clear 10 lines!",
            blockHold = true,
            blockHarddrop = true,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/10"):format(gamestate.lines)
            end,
            postInit = function(self, gs)
                gs.delays.gravity = 1/3
                gs.delays.lock = 0
                gs.delays.are = 18 * (1/60)
                gs.delays.lineare = 24 * (1/60)
                gs.delays.clear = 18 * (1/60)
                gs.delays.das = 16 * (1/60)
                gs.delays.arr = 6 * (1/60)
            end
        },
        {
            {
                "Cool! Clear 25 lines in max gravity."
            },
            objective = "Clear 25 lines!",
            update = function(self, dt)
                if gamestate.lines >= 25 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/25"):format(gamestate.lines)
            end,
            postInit = function(self, gs)
                gs.delays.gravity = 20
            end
        },
        {
            {
                "[happy]And so, you made it.",
                "This is the end of the Intermediate Course.",
                "[smug]...But there's one final level to get through!",
                "[happy]Show me what you can do!!!"
            },
            objective = "Clear 40 lines\nwithin 120 sec.!",
            update = function(self, dt)
                if gamestate.time >= 120 then
                    gamestate:gameOver()
                end
                if gamestate.lines >= 40 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%s/40"):format(gamestate.lines)
            end
        }
    }
}