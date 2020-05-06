return {
    name = "Advanced Course",
    music = "level2",
    sort = 2,
    stages = {
        {
            {
                "Welcome to the Advanced Course!",
                "[happy]I'll start you off with something nice.",
                "[smug]...oh, yeah, there will be memes."
            },
            objective = "Clear 5 lines!",
            postInit = function(self, gs)
                gs.invisible = true
            end,
            update = function(self, dt)
                if gamestate.lines >= 5 then
                    stopmusic()
                    fmv.ronaldinho:play()
                    videoplaying = fmv.ronaldinho
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines.."/5"
            end
        },
        {
            {
                "I'm really sorry about that last one!",
                "[smug]...but I just had to, didn't I?",
                "[happy]Either way, invisible mode is pretty fun, isn't it?",
                "[smug]Show me what you've got!"
            },
            objective = "Clear 10 lines!",
            postInit = function(self, gs)
                playmusic('level2')
                gs.invisible = true
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
        }
    }
}