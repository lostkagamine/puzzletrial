return {
    name = "Practice Mode",
    id = "practice",
    music = "level1",
    unlisted = true,
    sort = 10,
    stages = {
        {
            objective = "Practice!",
            rotation = "prs",
            getGoalText = function(self)
                return tostring(gamestate.lines)
            end,
            postRngInit = function(self, gs)
                gs.delays.gravity = 0.02
            end
        }
    }
}