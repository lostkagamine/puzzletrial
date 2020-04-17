local menu = {}
local st = 1

local h = {}
for i, j in pairs(courselist) do
    j.id = i
    if not j.unlisted then
        table.insert(h, j)
    end
end

table.sort(h, function(a, b)
    return (a.sort or 0) < (b.sort or 0)
end)

for i, j in pairs(h) do
    table.insert(menu, {j.name, function()
        loadcourse(j.id)
        playmusic(j.music or 'level1')
        startstage(st)
    end})
end

table.insert(menu, {'Debug stage select',
left=function()
    st = st - 1
    if st<1 then
        st=1
    end
end,
right=function()
    st = st + 1
end, value = function()
    return "Debug stage select: "..st
end})

local selection = 1

return {
    on = function(self)
        selection = 1
        st = 1
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
            local text = j[1]
            if j.value then text = j:value() end
            love.graphics.print(text, 20, (600 - (30 * #menu) - 20) + (30 * (i-1)))
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
        if k == 'return' and menu[selection][2] then
            menu[selection][2]()
        end
        if k == 'left' and menu[selection].left then
            menu[selection]:left()
        end
        if k == 'right' and menu[selection].right then
            menu[selection]:right()
        end
        if k == 'escape' then
            switchstate('title')
        end
    end
}