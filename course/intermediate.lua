return {
    name = "Intermediate Course",
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
            onStart = function(self)
                enableshader('fuck')
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%d/10"):format(gamestate.lines)
            end
        },
        {
            {
                "Advanced techniques return in this advanced stage!",
                "Let's do some T-Triples!"
            },
            objective = "Do 5 T-Spin Triples\nin a row!",
            postInit = function(self, gs)
                self.b2bs = 0
            end,
            onClear = function(self, lines, spin, mini)
                if lines == 3 and spin then -- I have no idea how you'd do a mini-t-triple but
                    self.b2bs = self.b2bs + 1
                elseif lines ~= 0 and not spin then
                    self.b2bs = 0
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
        }
    }
}