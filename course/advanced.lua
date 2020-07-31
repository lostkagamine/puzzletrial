return {
    name = "Advanced Course",
    music = "level3",
    sort = 2,
    stages = {
        {
            {
                "Welcome to the Advanced Course!",
                "[happy]I'll start you off with something nice.",
                "[smug]Can you play invisible?"
            },
            objective = "Clear 5 lines!",
            postInit = function(self, gs)
                gs.invisible = true
            end,
            update = function(self, dt)
                if gamestate.lines >= 5 then
                    if love.math.random(1, 100) <= 5 then
                        stopmusic()
                        fmv.ronaldinho:play()
                        videoplaying = fmv.ronaldinho
                    end
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines.."/5"
            end
        },
        {
            {
                "[happy]Invisible mode is pretty fun, isn't it?",
                "[smug]Show me what you've got!"
            },
            objective = "Clear 10 lines!",
            postInit = function(self, gs)
                gs.invisible = true
                gs.delays.gravity = 3
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines.."/10"
            end
        },
        {
            {
                "[happy]...Right, so this course...",
                "This is the last course of the game.",
                "As a result, it's gonna get difficult.",
                "[smug]And it starts here!",
                "[smug]Go really fast!"
            },
            objective = "Survive for one minute!",
            update = function(self, dt)
                if gamestate.time >= 60 then
                    gamestate:signalClear()
                end
            end,
            postInit = function(self, gs)
                gs.delays.gravity = math.huge
                gs.delays.lock = 17 * (1/60)
                gs.delays.are = 10 * (1/60)
                gs.delays.lineare = 10 * (1/60)
                gs.delays.clear = 9 * (1/60)
                gs.delays.das = 9 * (1/60)
            end
        },
        {
            {
                "Hey, you did it!",
                "[smug]Now do some spins!"
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
                "[happy]Time to kick your speed into overdrive!"
            },
            objective = "Clear 40 lines\nwithin 60 sec.!",
            update = function(self, dt)
                if gamestate.time >= 60 then
                    gamestate:gameOver()
                end
                if gamestate.lines >= 40 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return ("%s/40"):format(gamestate.lines)
            end
        },
        {
            {
                "NES mode returns, clear a Quad!"
            },
            objective = "Clear a Quad!",
            onClear = function(self, lines, spin, mini)
                if lines >= 4 then
                    gamestate:signalClear()
                end
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
    }
}