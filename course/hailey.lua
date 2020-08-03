return {
    name = "Hailey's Fun Course",
    music = "hailey",
    stages = {
        {
            {
                "[happy]Hiya! Welcome to this bonus course created by Hailey.",
                "[neutral]To be honest, I have no idea what to expect from this\ncourse soooo...",
                "[smug]Be prepared!!",

            },
            objective = 'Clear 10 lines!',
            rotation = "hairs",
            onClear = function(self, lines, spin, mini)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/10'
            end
        },
        {
            {
                "[neutral]Uhhh.....what was that?",
                "[annoyed]The J, L and O pieces were....",
                "[happy]Eh, probably just a bug.",
                "Anyway, onto the next stage!",
                "[smug]This one has a new type of objective!"
            },
            objective = 'Get 1000 points in 10 lines!',

            on = function(self)
                self.lines = 0
                self.score = 0
            end,
            onClear = function(self, lines, score)
                if gamestate.score >= 1000 then
                    gamestate:signalClear()
                end
                if gamestate.lines > 10 then
                    gamestate:gameOver()
                end
            end,
            getGoalText = function(self)
                return gamestate.score .. " | " .. gamestate.lines .. "/10"
            end
        },
        {
            {
                "[happy]Cool, so you can play Tetris. Fantastic.",
                "[smug]But... how many advanced techniques do you know?",
                "[happy]For example, can you completely clear the field of blocks?",
                "[annoyed]Oh... and...",
                "[smug]If you get stuck, press the R key."
            },
            objective = 'Perform a Perfect Clear!',
            onClear = function(self, lines, spin, mini)
                if lines > 0 and not gamestate.board:hasAnyBlocks() then
                    gamestate:signalClear()
                end
            end
        },
        {
            {
                "Alright, alright, I get it. That was too easy.",
                "[happy]Those were just tests, though!\nNow we get into the real wacky stuff.",
                "[smug]What if I... take away one of your controls?",
                "How about rotate?",
                "[smug]To clear this stage, clear a line without rotating!"
            },
            blockRotate = true,
            objective = "Clear a line\nwithout rotating!",
            onClear = function(self, lines, spin, mini)
                if lines > 0 then
                    gamestate:signalClear()
                end
            end
        },
        {
            {
                "[happy]...Like I said, you'll run into surprises.\nThis is one of them.",
                "[smug]Can you play... UPSIDE-DOWN!?"
            },
            objective = "Clear 4 lines!",
            onStart = function(self)
                game.vertFlip = true
            end,
            onClear = function(self, lines, spin, mini)
                if gamestate.lines >= 4 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/4'
            end
        },
        {
            {
                "[happy]Ah, here's something fun I thought of!",
                "[smug]What if the pieces fell... really fast?",
                "How about instantly, even?",
                "[happy]You've just gotta survive a while here. Don't sweat it.",
                "For anyone who has experience with TGM, this should be easy."
            },
            objective = "Survive 30 seconds\nin max gravity!",
            onStart = function(self)
                gamestate.delays.gravity = math.huge
            end,
            update = function(self, dt)
                if gamestate.time >= 30 then
                    gamestate:signalClear()
                end
            end
        },
        {
            {
                "[annoyed]Hmmm... I can't think of anything...",
                "[happy]Ah! I know! Ever heard of Item Mode?",
                "[smug]Well... I'm gonna do something to your rotations!",
                "It'll be fine, I promise."
            },
            objective = "Clear 10 lines!",
            onStart = function(self)
                self.counter = 0
            end,
            update = function(self, dt)
                self.counter = self.counter + dt
                if self.counter >= 1 and gamestate.running then
                    self.counter = 0
                    gamestate:rotate(1)
                end
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/10'
            end
        },
        {
            {
                "[happy]Hey, remember the 'no rotating' stage?",
                "[smug]That was fun, right?\nLet's do it again, but this time longer!",
                "Don't worry, here you can use the hold as much as you want."
            },
            objective = "Clear 10 lines!",
            blockRotate = true,
            onStart = function(self)
                gamestate.sakuraHold = true
                gamestate.infiniteHold = true
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/10'
            end
        },
        {
            {
                "[smug]This next one is very fun!",
                "[annoyed]It might make you a tiny bit dizzy, though...\nDon't worry, it'll be fine.",
                "[happy]Graphical effects are the best feature."
            },
            objective = "Clear 10 lines!",
            onStart = function(self)
                enableshader('sin')
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    enableshader()
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/10'
            end
        },
        {
            {
                "Last stage was good, right?",
                "[happy]What if we did it again?",
                "[smug]Giving me GLSL was a mistake."
            },
            objective = "Clear 10 lines!",
            onStart = function(self)
                enableshader('sin2')
            end,
            update = function(self, dt)
                if gamestate.lines >= 10 then
                    enableshader()
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/10'
            end
        },
    }
}
