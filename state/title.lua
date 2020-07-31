local menu = {
    {'Start game', function()
        switchstate('courseselect')
    end},
    {'Options', function() switchstate('options') end},
    {'Credits', function() switchstate('credits') end},
    {'Quit', function() love.event.quit() end}
}

local selection = 1

return {
    on = function(self)
        selection = 1
    end,
    draw = function(self)
        love.graphics.draw(gfx.logo, (800/2)-(gfx.logo:getWidth()/2), 75)

        for i, j in ipairs(menu) do
            love.graphics.setFont(font.menu)
            if selection == i then
                love.graphics.setColor(0.1, 1, 0.1)
            else
                love.graphics.setColor(1, 1, 1)
            end
            love.graphics.print(j[1], 20, (600 - (30 * #menu) - 20) + (30 * (i-1)))
        end

        love.graphics.setFont(font.reg2)
        love.graphics.setColor(1, 1, 1)
        local v = 'version '.._GAME_VERSION
        love.graphics.print(v, 800 - font.reg2:getWidth(v) - 20, 600 - 50)
    end,
    keydown = function(self, k)
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
            menu[selection][2]()
        end
        if k == 'o' and not RELEASE then
            error('testing')
        end
    end
}