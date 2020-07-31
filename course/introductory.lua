return {
    name = "Introductory Course",
    id = "introductory",
    stages = {
        {
            {
                "[happy]So! Welcome to Puzzle Trial's full release!\nPress the long bar on the keyboard\nto advance dialogue.",
                "My name is Rin and I\'ll be your host for tonight.",
                "If you've ever heard of a little game called Tetris,\nit's kinda like that.",
                "Blocks will fall from the top of the screen,\nand YOU have to arrange them so\nthat they form complete lines.",
                "It's simple, really.",
                "Oh, also, don't let the blocks stack all the way up.\nBad things will happen.",
                "You might also run into some... surprises.",
                "[annoyed]...",
                "[smug]You'll see what I mean later on.",
                "[happy]Anyways, let's get started! Clear 15 lines to advance!!"
            },
            objective = 'Clear 15 lines!',
            onClear = function(self, lines, spin, mini)
                if gamestate.lines >= 15 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return gamestate.lines .. '/15'
            end
        },
        {
            {
                "There are also things called T-Spins.",
                "They're when you rotate the T piece (the purple one)\ninto a hole shaped like a T.",
                "It's honestly pretty simple, but the rotation system\ncan be fairly weird sometimes.",
                "[smug]Can you do 5 of them?"
            },
            objective = 'Perform 5 T-Spins!',
            on = function(self)
                self.spins = 0
            end,
            onClear = function(self, lines, spin, mini)
                if spin then
                    self.spins = self.spins + 1
                end
                if self.spins >= 5 then
                    gamestate:signalClear()
                end
            end,
            getGoalText = function(self)
                return self.spins .. '/5'
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