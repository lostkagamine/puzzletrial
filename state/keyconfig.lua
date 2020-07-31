local menu = {
    {'Move piece left', 'left'},
    {'Move piece right', 'right'},
    {'Hard drop', 'harddrop'},
    {'Soft drop', 'softdrop'},
    {'Rotate left', 'rotateLeft'},
    {'Rotate right', 'rotateRight'},
    {'Hold piece', 'hold'}
}

local selection = 1
local currentlyBinding = nil

local json = require "lib/json"

return {
    on = function(self)
        selection = 1
        currentlyBinding = nil
    end,
    draw = function(self)
        love.graphics.setFont(font.big)
        love.graphics.print('Key configurator', 20, 20)
        love.graphics.setFont(font.reg2)
        love.graphics.print('Use arrow keys and [ENTER] to select. Push [ESCAPE] to quit.', 20, 100)

        for i, j in ipairs(menu) do
            love.graphics.setFont(font.reg2)
            if selection == i then
                love.graphics.setColor(0.1, 1, 0.1)
            else
                love.graphics.setColor(1, 1, 1)
            end

            local key = input.binds[j[2]] or {}
            local f = table.concat(key, ', ')
            if #key == 0 then f = "Not bound" end

            if currentlyBinding == i then
                f = "Press key, or [DELETE] to unbind"
            end

            love.graphics.print(j[1] .. ': ' .. f, 20, 120+(i*30))
        end

        love.graphics.setFont(font.reg2)
        love.graphics.setColor(1, 1, 1)
        local v = 'version '.._GAME_VERSION
        love.graphics.print(v, 800 - font.reg2:getWidth(v) - 20, 600 - 50)
    end,
    keydown = function(self, k)
        if currentlyBinding then
            local fk = menu[currentlyBinding][2]
            if k == 'delete' then
                for action, keys in pairs(input.binds) do
                    if action == fk then
                        input.binds[action] = {}
                    end
                end
                currentlyBinding = nil
                return
            end
            for _, ckey in pairs(input.binds[fk]) do
                if k == ckey then
                    return
                end
            end
            input:bind(k, fk)
            currentlyBinding = nil
            return
        end
        if k == 'down' then
            selection = selection + 1
            if selection > #menu then
                selection = 1
            end
        end
        if k == 'up' then
            selection = selection - 1
            if selection < 1 then
                selection = #menu
            end
        end
        if k == 'return' then
            currentlyBinding = selection
        end
        if k == 'escape' then
            love.filesystem.write('keys.json', json.encode(input.binds))
            switchstate('options')
        end
    end
}