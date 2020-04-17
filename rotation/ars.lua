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
    name = "Arika Rotation System (ARS)"
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
        {{0, 0, 0},
         {1, 1, 1},
         {0, 1, 0}},
        {{0, 1, 0},
         {1, 1, 0},
         {0, 1, 0}},
        {{0, 0, 0},
         {0, 1, 0},
         {1, 1, 1}},
        {{0, 1, 0},
         {0, 1, 1},
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
        {{0,0,0},
         {1, 1, 1,},
         {0, 0, 1,}},
        {{0, 1, 0,},
         {0, 1, 0,},
         {1, 1, 0}},
        {{0,0,0},
         {1, 0, 0},
         {1, 1, 1}},
        {{0, 1, 1},
         {0, 1, 0},
         {0, 1, 0}}
    },
    L = {
        {{0, 0, 0},
         {1, 1, 1},
         {1, 0, 0}},
        {{1, 1, 0},
         {0, 1, 0},
         {0, 1, 0}},
        {{0, 0, 0},
         {0, 0, 1},
         {1, 1, 1}},
        {{0, 1, 0,},
         {0, 1, 0,},
         {0, 1, 1,}}
    },
    O = {
        {{0, 0},
         {1, 1},
         {1, 1}},
    }
}

ars.colours = {
    I = hue(0),
    J = hue(240),
    L = hue(30),
    T = hue(180),
    S = hue(300),
    Z = hue(120),
    O = hue(60),
    FLAT = {1, 1, 1, 1}
}

function ars.wallkick(piecest, a, b)
    local failed = true
    local change = 0
    if gamestate.piece.name == "I" then return true, 0, 0 end
    local middlepieces = {'T', 'J', 'L'}
    if tableindex(middlepieces, gamestate.piece.name) ~= -1 then
        -- middle column rule!
        for y=0,2 do
            local brk = false
            for x=0,2 do
                local b = gamestate.board:hasBlock(gamestate.x+x, gamestate.y+y)
                if b ~= 0 then
                    if x == 1 then
                        return true, 0, 0
                    else
                        brk = true
                        break
                    end
                end
            end
            if brk then
                break
            end
        end
    end
    if not gamestate.board:isColliding(piecest, gamestate.x+1) then -- mihara's conspiracy
        change = 1
        failed = false
    end
    if not gamestate.board:isColliding(piecest, gamestate.x-1) then
        change = -1
        failed = false
    end
    -- if not gamestate.board:isColliding(f, gamestate.x) then
    --     change = 0
    --     failed = false
    -- end
    return failed, change, 0
end

function ars:getSpawnLocation()
    return 3, HIDDEN_HEIGHT-1
end

return ars