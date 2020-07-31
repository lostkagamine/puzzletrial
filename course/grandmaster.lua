return {
    name = "Grand Master Course",
    music = "level4",
    sort = 5,
    hideUntilUnlock = true,
    stages = {
        {
            {
                "[happy]Here it is!! The final challenge!!",
                "[happy]You've done well to get this far, so give it your all!"
            },
            objective = "Clear 40 lines\nwithin 50 sec.!",
            update = function(self, dt)
                if gamestate.time >= 50 then
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
            objective = "Survive for 20 seconds!",
            update = function(self, dt)
                if gamestate.time >= 20 then
                    gamestate:signalClear()
                end
            end,
            postInit = function(self, gs)
                gs.delays.gravity = math.huge
                gs.delays.lock = 8 * (1/60)
                gs.delays.are = 6 * (1/60)
                gs.delays.lineare = 5 * (1/60)
                gs.delays.clear = 3 * (1/60)
                gs.delays.das = 6 * (1/60)
            end
        },
        {
            objective = "Survive for one minute!",
            update = function(self, dt)
                if gamestate.time >= 60 then
                    gamestate:signalClear()
                end
            end,
            postInit = function(self, gs)
                gs.delays.gravity = math.huge
                gs.delays.lock = 15 * (1/60)
                gs.delays.are = 6 * (1/60)
                gs.delays.lineare = 6 * (1/60)
                gs.delays.clear = 6 * (1/60)
                gs.delays.das = 8 * (1/60)
                gs.invisible = true
            end
        }
    }
}