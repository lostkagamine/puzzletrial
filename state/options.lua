local sdSelect = false

local menu = {
    {'Key configuration', function()
        switchstate('keyconfig')
    end},
    {'x', function()
        if not sdSelect then
            sdSelect = true
            return
        end

        love.filesystem.remove('save.json')
        love.event.quit()
    end, function()
        return sdSelect and 'Are you sure you want to erase your save and quit?' or 'Erase ALL save data permanently'
    end},
}

local selection = 1
local currentlyBinding = nil

local json = require "lib/json"

local ternary = function(a, b, c) if a then return b else return c end end

return {
    on = function(self)
        selection = 1
        currentlyBinding = nil
        sdSelect = false
    end,
    draw = function(self)
        love.graphics.setFont(font.big)
        love.graphics.print('Options', 20, 20)
        love.graphics.setFont(font.reg2)
        love.graphics.print('Use arrow keys and [ENTER] to select. Push [ESCAPE] to quit.', 20, 100)

        for i, j in ipairs(menu) do
            love.graphics.setFont(font.reg2)
            if selection == i then
                love.graphics.setColor(0.1, 1, 0.1)
            else
                love.graphics.setColor(1, 1, 1)
            end

            love.graphics.print((j[3] ~= nil and j[3]()) or j[1], 20, 120+(i*30))
        end

        love.graphics.setFont(font.reg2)
        love.graphics.setColor(1, 1, 1)
        local v = 'version '.._GAME_VERSION
        love.graphics.print(v, 800 - font.reg2:getWidth(v) - 20, 600 - 50)
    end,
    keydown = function(self, k)
        if k == 'down' then
          game.sfx.cursor:play()
            selection = selection + 1
            if selection > #menu then
                selection = 1
            end
            sdSelect = false
        end
        if k == 'up' then
          game.sfx.cursor:play()
            selection = selection - 1
            if selection < 1 then
                selection = #menu
            end
            sdSelect = false
        end
        if k == 'return' then
          game.sfx.select:play()
            menu[selection][2]()
        end
        if k == 'escape' then
            switchstate('title')
        end
    end
}
