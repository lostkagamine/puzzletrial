return {
    name = "Advanced Course",
    music = "level2",
    sort = 2,
    stages = {
        {
            {
                "Welcome to the Advanced Course!",
                "[happy]I'll start you off with something nice."
            },
            objective = "Clear 5 lines!",
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
        }
    }
}