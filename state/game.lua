--[[
    game state
]]

local randomBG = 0
local fieldLeft = 135

local inDialogue = true
local dialogueIndex = 1
local charastate = 'neutral'

return {
    on = function(self, nodialogue)
        gamestate = Game:new(rotationlist[curr_rotation])
        dialogueIndex = 1
        self.countdown = 0
        self.countdownStage = 0
        self.isCountingDown = false
        self.hasPlayedReady = false
        self.dead = false
        self.currtext = {}
        self.texttime = 0
        self.fieldCanvas = love.graphics.newCanvas()
        if nodialogue == true or not stage[1] or game.speedrunmode then
            inDialogue = false
            self.isCountingDown = true
        else
            inDialogue = true
            charastate = 'neutral'
        end

        game.vertFlip = false
    end,
    off = function(self)
        gamestate = nil
    end,
    draw = function(self)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gfx.background, 0, 0)
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle('fill', 0, 0, 800, 600)
        love.graphics.setColor(0, 0, 0, 0.9)
        local e = (600/2)-((BLOCK_HEIGHT*FIELD_HEIGHT)/2)
        love.graphics.setCanvas(self.fieldCanvas)
        love.graphics.clear()
        local htop = BLOCK_HEIGHT*HIDDEN_HEIGHT
        love.graphics.rectangle('fill', 0, BLOCK_HEIGHT*HIDDEN_HEIGHT, BLOCK_WIDTH*FIELD_WIDTH, BLOCK_HEIGHT*FIELD_HEIGHT)
        local fieldRight = fieldLeft+(BLOCK_WIDTH*FIELD_WIDTH)
        local fieldBottom = e+(BLOCK_HEIGHT*FIELD_HEIGHT)
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.setLineWidth(2)
        love.graphics.line(0, htop, BLOCK_WIDTH*FIELD_WIDTH, htop)
        local padding = 8
        local nextpad = 12
        local holdpad = 12
        love.graphics.setFont(game.font.med3)

        love.graphics.setColor(1, 1, 1, 1)
        local renderboard = gamestate.board:copy()
        local ps = gamestate.rotation.structure[gamestate.piece.name][gamestate.piece.rotationstate]
        local ghosty = gamestate:findLowestY()
        if gamestate.invisible then
            for y=1,FIELD_HEIGHT+HIDDEN_HEIGHT do
                for x=1,FIELD_WIDTH do
                    renderboard[y][x] = 0
                end
            end
        end
        if gamestate.piece.active then 
            for y=1,#ps do
                local fs = ps[y]
                for x=1,#fs do
                    local es = ps[y][x]
                    if es == 1 then
                        renderboard[y+ghosty][x+gamestate.x] = 'GHOST'
                    end
                end
            end
        end
        if gamestate.piece.active then
            for y=1,#ps do
                local fs = ps[y]
                for x=1,#fs do
                    local es = ps[y][x]
                    if es == 1 then
                        renderboard[y+gamestate.y][x+gamestate.x] = gamestate.piece.name
                    end
                end
            end
        end
        for y=1,FIELD_HEIGHT+HIDDEN_HEIGHT do
            for x=1,FIELD_WIDTH do
                local f = renderboard[y][x]
                if f ~= 0 and gamestate.running then
                    local col = deepcopy(gamestate.rotation.colours[f])
                    if f == 'GHOST' and gamestate.piece.active then
                        col = deepcopy(gamestate.rotation.colours[gamestate.piece.name])
                        table.insert(col, 0.4) 
                    else
                        table.insert(col, 1)
                    end
                    love.graphics.setColor(unpack(col))
                    love.graphics.draw(gfx.block, (BLOCK_WIDTH*(x-1)), (BLOCK_HEIGHT*((y-1))))
                end
            end
        end
        love.graphics.setCanvas(screen_cvs)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setBlendMode('alpha', 'premultiplied')
        if game.vertFlip then
            local w = self.fieldCanvas:getHeight()
            love.graphics.draw(self.fieldCanvas, fieldLeft, e-htop, 0, 1, -1, 0, w+htop)
        else
            love.graphics.draw(self.fieldCanvas, fieldLeft, e-htop)
        end
        love.graphics.setBlendMode('alpha')
        for pieceno=1,settings.drawNext do
            local pname = gamestate.nextQueue[pieceno]
            local p = gamestate.rotation.structure[pname][1]
            for y=1,#p do
                for x=1,#p[1] do
                    local es = p[y][x]
                    if es == 1 then
                        love.graphics.setColor(unpack(deepcopy(gamestate.rotation.colours[pname])))
                        love.graphics.draw(gfx.smallblock, fieldRight+padding+(SMALLBLOCK_WIDTH*(x-1)), e+((SMALLBLOCK_HEIGHT*(y-1))+(nextpad)+(SMALLBLOCK_HEIGHT*4*(pieceno-1))))
                    end
                end
            end
        end
        if gamestate.holdPiece ~= nil then 
            local pname = gamestate.holdPiece
            local p = gamestate.rotation.structure[pname][1]
            for y=1,#p do
                for x=1,#p[1] do
                    local es = p[y][x]
                    if es == 1 then
                        local c = deepcopy(gamestate.rotation.colours[pname])
                        if gamestate.holdAvailable then
                            c[4] = 1 
                        else
                            c[4] = 0.4
                        end
                        love.graphics.setColor(unpack(c))
                        love.graphics.draw(gfx.smallblock, (SMALLBLOCK_WIDTH*x)+(fieldLeft-(SMALLBLOCK_WIDTH*(#p[1]+1))-padding), e+((SMALLBLOCK_HEIGHT*(y-1))+(holdpad)))
                    end
                end
            end
        end

        love.graphics.setColor(1, 1, 1, 1)

        if self.isCountingDown and not inStateTransition then
            love.graphics.setFont(game.font.big)
            love.graphics.setColor(1, 1, 1, 1)
            local tex = tostring(3 - self.countdownStage)
            local tx, ty = self:centerTextOnField(tex)
            love.graphics.print(tex, tx, ty)
        end

        if self.dead then
            local tex = 'Game over!'
            local tex2 = 'Press Enter to try again.'
            local tx, ty = self:centerTextOnField(tex)
            love.graphics.print(tex, tx, ty-10)

            love.graphics.setFont(game.font.med)
            local tx2, ty2 = self:centerTextOnField(tex2)
            love.graphics.print(tex2, tx2, ty2+25)
        end

        if gamestate.stageClear then
            local tex = 'Cleared!'
            local tex2 = 'Press Enter to advance.'
            local tx, ty = self:centerTextOnField(tex)
            love.graphics.print(tex, tx, ty-10)

            love.graphics.setFont(game.font.med)
            local tx2, ty2 = self:centerTextOnField(tex2)
            love.graphics.print(tex2, tx2, ty2+25)
        end

        love.graphics.setFont(game.font.med3)
        local tex = string.format('%02d:%02d.%02d', math.floor(gamestate.time / 60), math.floor(math.fmod(gamestate.time, 60)), math.floor((gamestate.time*100)%100))
        love.graphics.print(tex, fieldRight + padding, fieldBottom - height(tex))

        if game.speedrunmode then
            local st = love.timer.getTime() - game.speedruntimer
            local stex = string.format('%02d:%02d.%02d', math.floor(st / 60), math.floor(math.fmod(st, 60)), math.floor((st*100)%100))
            love.graphics.print(stex, fieldRight + padding + width(stex) + 50, fieldBottom - height(tex))
        end

        if stage.getGoalText then
            local gt = stage:getGoalText()
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(gt, fieldRight+padding, fieldBottom - 100)
        end

        love.graphics.setFont(game.font.med)
        local fl = 'Lines'

        for i, j in ipairs(self.currtext) do
            love.graphics.setFont(game.font.med3)
            love.graphics.setColor(1, 1, 1, 1-(love.timer.getTime()-self.texttime))
            local ex, ey = self:centerTextOnField(j)
            love.graphics.print(j, ex, ey-(height(j)*(i-1)))
        end

        love.graphics.setFont(font.reg2)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(currcourse.name, 800 - 20 - (font.reg2:getWidth(currcourse.name)), e-35)
        local stext = ("Stage %d/%d"):format(stageno, #stages)
        love.graphics.print(stext, 800 - 20 - (font.reg2:getWidth(stext)), e)

        love.graphics.print(gamestate.rotation.name, 800 - 20 - (font.reg2:getWidth(gamestate.rotation.name)), e+35)

        if stage.objective then
            love.graphics.print(stage.objective, 800 - 20 - (font.reg2:getWidth(stage.objective)), e+(35*2))
        end

        if stage.draw then
            stage:draw()
        end

        if inDialogue then
            love.graphics.setColor(0, 0, 0, 0.6)
            love.graphics.rectangle('fill', 0, 0, 800, 600)

            local text = stage[1][dialogueIndex]
            local salt, pepper = string.find(text, "%b[]")
            if salt then
                local newstate = string.sub(text, salt+1, pepper-1)
                text = string.gsub(text, "%b[]", "")
                charastate = newstate
            else
                charastate = "neutral"
            end

            love.graphics.setColor(1, 1, 1, 1)
            local cspr = charasprites[charastate]
            love.graphics.draw(cspr, 100, (600/2)-(cspr:getHeight()/2)+10, 0, 0.7)

            love.graphics.setColor(0.1, 0.1, 0.1, 1)
            love.graphics.rectangle('fill', 20, 375, 800-40, 200)

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.setFont(font.reg2)
            love.graphics.print(text, 40, 375+20)
        end
    end,
    update = function(self, dt)
        gamestate:update(dt)
        if not inStateTransition and self.isCountingDown then
            if not self.hasPlayedReady then 
                self.hasPlayedReady = true
                game.sfx.ready:play()
            end
            self.countdown = self.countdown + dt
            if self.countdown >= 1 then
                self.countdown = 0
                self.countdownStage = self.countdownStage + 1
                if self.countdownStage > 2 then
                    gamestate:start()
                    self.isCountingDown = false
                    game.sfx.go:play()
                else
                    game.sfx.ready:play()
                end
            end
        end
    end,
    onGameOver = function(self)
        self.dead = true
    end,
    centerTextOnField = function(self, tex)
        local e = (600/2)-((BLOCK_HEIGHT*FIELD_HEIGHT)/2)
        return (((BLOCK_WIDTH*FIELD_WIDTH)/2)-(width(tex)/2))+fieldLeft, (((BLOCK_HEIGHT*FIELD_HEIGHT)/2 - (height(tex)/2)))+e
    end,
    keydown = function(self, k, sc, r)
        if k == 'escape' then
            stopmusic()
            enableshader()
            switchstate('title')
        end

        if k == 'space' and inDialogue then
            dialogueIndex = dialogueIndex + 1
            if dialogueIndex > #stage[1] then
                inDialogue = false
                self.isCountingDown = true
            end
        end

        if ((k == 'return' and self.dead) or k == 'r') and not inDialogue then
            self:on(true)
            enableshader()
            startstage(stageno, true)
        end

        if not RELEASE and k == 'tab' and game.speedrunmode then
            game.speedrunfinaltime = love.timer.getTime() - game.speedruntimer
            switchstate('speedrunend')
            stopmusic()
            return
        end
        
        if k == 'return' and gamestate.stageClear then
            enableshader()
            if not stages[stageno+1] then
                -- end of game
                game.save.cleared[currcourse.id] = true
                saveFile()
                if game.speedrunmode then
                    local next = {
                        introductory = 'intermediate',
                        intermediate = 'advanced',
                        advanced = 'credits'
                    }
                    local n = next[currcourse.id]
                    if n == 'credits' then
                        game.speedrunfinaltime = love.timer.getTime() - game.speedruntimer
                        switchstate('speedrunend')
                        stopmusic()
                        return
                    end
                    loadcourse(n)
                    stopmusic()
                    playmusic(currcourse.music or 'level1')
                    startstage(1)
                    return
                end
                switchstate('credits')
                return
            end
            self:on(true) -- reset
            startstage(stageno+1)
        end
    end,
    handleMove = function(self, lines, spin, mini)
        local piece = gamestate.piece.name
        if lines > 0 then
            local names = {
                'Single', 'Double', 'Triple', 'Quad', 'Quint'
            }
            local n = names[lines]
            local t = ''
            if spin then
                t = piece..'-Spin'
            end
            if mini and spin then
                t = 'Mini '..t
            end
            if t ~= '' then
                n = t .. ' ' .. n
            end
            local ta = {n}
            if gamestate.b2b > 1 then
                table.insert(ta, 1, 'Back-to-Back x'..gamestate.b2b-1)
            end
            if gamestate.combo > 1 then
                ta[#ta+1] = 'Combo '..gamestate.combo-1
            end
            self.currtext = ta
            self.texttime = love.timer.getTime()
        else
            local t = ''
            if spin then
                t = piece..'-Spin'
            end
            if mini and spin then
                t = 'Mini '..t
            end
            if spin then
                self.currtext = {n}
                self.texttime = love.timer.getTime()
            end
        end
    end
}