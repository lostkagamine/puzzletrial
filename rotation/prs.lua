--[[
    JESUS CHRIST THIS TOOK A LONG TIME
    
    feel free to use this, I really don't care,
    in fact i'll be happy if i find this in another tetris game
    because it means i've saved someone from having to do this themselves
    (C) ry00001 2019
]]

-- utility stuff
local BLANK = {0, 0, 0, 0}

local ars = {}

ars = {
    name = "Perm. Rotation System"
}

ars.structure = {
    I = {
        { BLANK,
            {1, 1, 1, 1},
            BLANK,
            BLANK },
        { {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 0, 1, 0},
            {0, 0, 1, 0} }
    },
    T = {
        {{0, 1, 0},
         {1, 1, 1},
         {0, 0, 0}},
        {{0, 1, 0},
         {0, 1, 1},
         {0, 1, 0}},
        {{0, 0, 0},
         {1, 1, 1},
         {0, 1, 0}},
        {{0, 1, 0},
         {1, 1, 0},
         {0, 1, 0}}
    },
    S = {
        {{0, 0, 0},
         {0, 1, 1},
         {1, 1, 0}},
        {{1, 0, 0},
         {1, 1, 0},
         {0, 1, 0}}
    },
    Z = {
        {{0,0,0},
         {1, 1, 0},
         {0, 1, 1}},
        {{0, 0, 1},
         {0, 1, 1},
         {0, 1, 0}}
    },
    J = {
        {{1, 0, 0},
        {1, 1, 1},
        {0, 0, 0}},
        {{0, 1, 1},
        {0, 1, 0},
        {0, 1, 0}},
        {{0, 0, 0},
        {1, 1, 1},
        {0, 0, 1}},
        {{0, 1, 0},
        {0, 1, 0},
        {1, 1, 0}}
    },
    L = {
        {{0, 0, 1},
        {1, 1, 1},
        {0, 0, 0}},
        {{0, 1, 0},
        {0, 1, 0},
        {0, 1, 1}},
        {{0, 0, 0},
        {1, 1, 1},
        {1, 0, 0}},
        {{1, 1, 0},
        {0, 1, 0},
        {0, 1, 0}}
    },
    O = {
        {{0, 0},
         {1, 1},
         {1, 1}},
    }
}

ars.colours = {
    I = hue(180),
    J = hue(240),
    L = hue(30),
    T = hue(270),
    S = hue(120),
    Z = hue(0),
    O = hue(60)
}

function ars.wallkick(piecest, a, b)
    local kicks = {{0, 0}, {1, 0}, {-1, 0}, {0, -1}, {0, 1}, {-1, 1}, {1, 1}, {-1, -1}, {1, -1}}
    for i=0,5 do
        for _, j in ipairs(kicks) do
            local nx, ny = gamestate.x, gamestate.y
            nx = nx + (j[1] + i)
            ny = ny + (j[2] + i)
            if not gamestate.board:isColliding(piecest, nx, ny) then
                return false, j[1]+i, j[2]+i
            end
        end
    end
    return true, 0, 0
end

function ars:getSpawnLocation()
    return 3, HIDDEN_HEIGHT-1
end

return ars