game.spinDetection = {}
game.spinDetection.T = {
    {{2, 0, 2},
     {0, 0, 0},
     {1, 1, 1}},
    {{1, 0, 2},
     {1, 0, 0},
     {1, 0, 2}},
    {{1, 1, 1},
     {0, 0, 0},
     {2, 0, 2}},
    {{2, 0, 1},
     {0, 0, 1},
     {2, 0, 1}}
}

ParkMiller = class('ParkMiller')
function ParkMiller:initialize(_seed)
    self.seed = math.fmod(_seed, 2147483647)
    if self.seed <= 0 then
        self.seed = self.seed + 2147483646
    end
end
function ParkMiller:_next()
    self.seed = math.fmod(self.seed * 16807, 2147483647)
    return self.seed
end
function ParkMiller:next(s, e)
    return math.floor((self:_next() - 1) / 2147483646 * (e - s)) + s
end

Board = class('Board')
function Board:initialize()
    self.board = {}
    for y=1,FIELD_HEIGHT+HIDDEN_HEIGHT do
        self.board[y] = {}
        for x=1,FIELD_WIDTH do
            self.board[y][x] = 0
        end
    end
end

function Board:hasBlock(x, y)
    local e = self.board[y]
    if not e then return true end
    return e[x] ~= 0
end

function Board:getBlock(x, y)
    return self.board[y][x]
end

function Board:isOnBoard(x, y)
    local e = self.board[y]
    if not e then return false end
    return e[x] ~= nil
end

function Board:hasAnyBlocks()
    for y=1,FIELD_HEIGHT+HIDDEN_HEIGHT do
        for x=1,FIELD_WIDTH do
            if self.board[y][x] ~= 0 then
                return true
            end
        end
    end
    return false
end

function Board:setBlock(x, y, v)
    self.board[y][x] = v
end

function Board:copy()
    return deepcopy(self.board)
end

function Board:setBoard(board)
    self.board = board
end

function Board:isColliding(piece, px, py)
    if not piece then piece = gamestate.rotation.structure[gamestate.piece.name][gamestate.piece.rotationstate] end
    local ax, ay = gamestate.x, gamestate.y
    if px then
        ax = px
    end
    if py then
        ay = py
    end
    local res = false
    local h, w = #piece, #piece[1]
    for y = 1, h, 1 do
        for x = 1, w, 1 do
            local b = piece[y][x]
            local t = (self.board[y+ay] or {nil, nil, nil, nil})[x+ax]
            if t == nil then
                t = true
            end
            if t ~= 0 and (b == 1) then
                res = true
            end
        end
    end
    return res
end

function Board:serialise()
    local e = self:copy()
    for i=1,#e do
        for j=1,#e[i] do
            e[i][j] = ternary(i == 0, 0, 1) 
        end
    end
end

LocalBoard = class('LocalBoard', Board)
function LocalBoard:initialize()
    Board.initialize(self)
end

Randomiser = class('Randomiser')
function Randomiser:initialize(rng, gs)
    self.rand = rng
    self.structure = {}
    for i, j in pairs(gs.rotation.structure) do
        if tableindex(gs.disabledPieces, i) == -1 then
            table.insert(self.structure, i)
        end
    end
    self.bag = deepcopy(self.structure)
end

function Randomiser:next()
    local piece = self.rand:next(1, #self.bag)
    local pieceName = deepcopy(self.bag[piece]) -- overkill?
    table.remove(self.bag, piece)
    if #self.bag == 0 then
        self.bag = deepcopy(self.structure)
    end
    return pieceName
end

Piece = class('Piece')
function Piece:initialize(name, gs)
    self.name = name
    self.active = true
    self.colour = gs.rotation.colours[name]
    self.structures = gs.rotation.structure[name]
    self.rotationstate = 1
    self.structure = self.structures[self.rotationstate]
end
function Piece:updateRotation()
    self.structure = self.structures[self.rotationstate]
end

Game = class('Game')
function Game:initialize(rotation)
    self.counters = {
        gravity = 0,
        sdGravity = 0,
        are = 0,
        arr = 0,
        das = 0,
        lock = 0,
        clear = 0
    }

    self.delays = {
        gravity = 1/64, --tbd
        are = 0,
        lineare = 0,
        arr = framesToMS(1),
        das = framesToMS(10),
        lock = framesToMS(30),
        clear = 0
    }

    self.running = false

    self.rotation = rotation
    
    self.seed = 0
    self.seed = love.math.random(0,2147483647)
    self.rand = ParkMiller:new(self.seed)

    self.board = LocalBoard:new()

    self.nextQueue = {}

    self.spawnx, self.spawny = self.rotation:getSpawnLocation()

    self.x, self.y = self.spawnx, self.spawny
    self.holdPiece = nil
    self.holdAvailable = true

    self.infiniteHold = false

    self.time = 0
    self.lines = 0
    self.b2b = 0
    self.combo = 0
    self.lastAction = 'spawn'

    self.stageClear = false

    self.rotationsPerPiece = 0

    self.invisible = false

    self.lrReverse = false

    self.disabledPieces = {}
    self.shiftDownRows = {}

    self.clearing = false

    if stage.postInit then
        stage:postInit(self)
    end

    self.rng = Randomiser:new(self.rand, self)
    for i=1,256 do
        table.insert(self.nextQueue, self.rng:next())
    end

    if stage.postRngInit then
        stage:postRngInit(self)
    end

    self.piece = Piece:new(self.nextQueue[1], self)
end

function Game:start()
    self.running = true
    table.remove(self.nextQueue, 1)
    table.insert(self.nextQueue, self.rng:next())
    if stage.onStart then
        stage:onStart()
    end
end

function Game:signalClear()
    self.stageClear = true
    self.running = false
end

function Game:update(dt)
    if self.running then
        self:shiftDownTimer(dt)
        self:doDAS(dt)
        self:doARR(dt)
        self:doARE(dt)
        self:doGravity(dt, input:down('softdrop'))
        self:doLockDelay(dt)
        if input:pressed('left') then
            self:movePiece(-1, 0)
            self.lastAction = 'move'
            self:sound('move')
        elseif input:pressed('right') then
            self:movePiece(1, 0)
            self.lastAction = 'move'
            self:sound('move')
        end
        if input:pressed('rotateLeft') then
            self:rotate(-1)
            self:sound('rotate')
        elseif input:pressed('rotateRight') then
            self:rotate(1)
            self:sound('rotate')
        end
        if input:pressed('hold') then
            self:hold()
        end
        if input:pressed('harddrop') then
            self:harddrop()
        end

        if stage and stage.update then
            stage:update(dt)
        end

        self.time = self.time + dt
    end
end

function Game:sound(s)
    game.repeatsfx[s]:play()
end

function Game:movePiece(ex, ey)
    if self.lrReverse then
        ex = ex * -1
    end
    local tx, ty = self.x+ex, self.y+ey
    if not self.board:isColliding(nil, tx, ty) then
        self.x, self.y = tx, ty
        self.counters.lock = 0
        if cstate and cstate.onMove then
            cstate:onMove()
        end
    end
end

function Game:rotate(dir, ignoreblock)
    if stage.blockRotate and not ignoreblock then return end

    if self.rotation.oops then
        dir = dir * -1
    end

    local states = #self.rotation.structure[self.piece.name]
    local provstate = self.piece.rotationstate + dir
    if provstate < 1 then
        provstate = states
    end
    provstate = math.fmod(provstate-1, states)+1
    local st = self.rotation.structure[self.piece.name][provstate]
    if self.board:isColliding(st) then
        -- piece in wall
        local fail, mx, my = self.rotation.wallkick(st, self.piece.rotationstate, provstate)
        if fail then
            return
        end
        self.x = self.x + mx
        self.y = self.y + my
    end
    self.piece.rotationstate = provstate
    self.piece:updateRotation()
    self.lastAction = 'rotate'
    self.counters.lock = 0
    self.rotationsPerPiece = self.rotationsPerPiece + 1
end

function Game:doARE(dt)
    if self.clearing then return end
    self.counters.are = self.counters.are - dt
    if self.counters.are <= 0 and not self.piece.active then 
        self.counters.are = 0
        self:nextPiece()
    end
end

function Game:doDAS(dt)
    if input:down('left') then
        if self.counters.das > 0 then self.counters.das = 0 end
        self.counters.das = self.counters.das - dt
    elseif input:down('right') then
        if self.counters.das < 0 then self.counters.das = 0 end
        self.counters.das = self.counters.das + dt
    else
        self.counters.das = 0
    end
end

function Game:doARR(dt)
    if not self.piece.active then return end
    if self.counters.das < self.delays.das * -1 then
        self.counters.arr = self.counters.arr + dt
        while self.counters.arr >= self.delays.arr do
            self:movePiece(-1, 0)
            self.counters.arr = self.counters.arr - self.delays.arr
            local j = 1
            if self.lrReverse then j = j * -1 end
            if self.board:isColliding(nil, self.x-j) then break end
            self.lastAction = 'move'
            self:sound('move')
        end
    end
    if self.counters.das > self.delays.das then
        self.counters.arr = self.counters.arr + dt
        while self.counters.arr >= self.delays.arr do
            self:movePiece(1, 0)
            self.counters.arr = self.counters.arr - self.delays.arr
            local j = 1
            if self.lrReverse then j = j * -1 end
            if self.board:isColliding(nil, self.x+j) then break end
            self.lastAction = 'move'
            self:sound('move')
        end
    end
end

function Game:doGravity(dt, softdrop)
    if not self.piece.active then return end
    local baseG = 1/60
    if softdrop and self.delays.gravity < 1 then
        self:doSoftDrop(dt)
        return
    else
        self.counters.sdGravity = 0
    end
    self.counters.gravity = self.counters.gravity + dt
    local f = self.delays.gravity
    while self.counters.gravity >= (baseG/f) do
        self.counters.gravity = self.counters.gravity - (baseG/f)
        if self.board:isColliding(nil, nil, self.y+1) then break end
        self:movePiece(0, 1)
    end
end

function Game:doSoftDrop(dt)
    self.counters.sdGravity = self.counters.sdGravity + dt
    while self.counters.sdGravity >= 1/60 do
        self.counters.sdGravity = self.counters.sdGravity - 1/60
        if self.board:isColliding(nil, nil, self.y+1) then break end
        self:movePiece(0, 1)
    end
end

function Game:doLockDelay(dt)
    if not self.piece.active then return end
    if self.board:isColliding(nil, nil, self.y+1) then
        self.counters.lock = self.counters.lock + dt
        if self.counters.lock >= self.delays.lock then 
            self.counters.lock = 0
            self:sound('lock')
            self:lock()
        end
    end
end

function Game:findLowestY()
    for y=self.y,FIELD_HEIGHT+HIDDEN_HEIGHT do
        if self.board:isColliding(nil, nil, y+1) then
            return y
        end
    end
    return 1
end

function Game:placePieceOnField()
    for y=1,#self.piece.structure do
        for x=1,#self.piece.structure[1] do
            local isOnBoard = self.board:isOnBoard(self.x+x, self.y+y)
            local isPresent = self.piece.structure[y][x] == 1
            if isPresent and isOnBoard then
                self.board:setBlock(self.x+x, self.y+y, self.piece.name)
            end
        end
    end
end

function Game:lock()
    if cstate and cstate.onLock then
        cstate:onLock()
    end
    self.piece.active = false
    local spin, mini = self:spinDetect() 
    self:placePieceOnField()
    local lines = self:clearLines()
    self.lines = self.lines + lines
    if cstate and cstate.onClearLines then
        cstate:onClearLines(lines)
    end
    if stage and stage.onClear then
        stage:onClear(lines, spin, mini)
    end
    self:handleClear(lines, spin, mini)
    if lines >= 1 then
        self.clearing = true
        self.counters.clear = self.delays.clear
        self:shiftDownTimer(0) -- 0-shift special case
    else
        self.counters.are = self.delays.are
    end
end

function Game:clearLines()
    local count = 0
    local board = self.board:copy()
    local empty = {}
    for y=1,FIELD_HEIGHT+HIDDEN_HEIGHT,1 do
        local perform = true
        for x=1,FIELD_WIDTH do
            if board[y][x] == 0 then
                perform = false
            end
            table.insert(empty, 0)
        end
        if perform then
            count = count + 1
            for x=1,FIELD_WIDTH do
                board[y][x] = 0
            end
            table.insert(self.shiftDownRows, y)
        end
    end
    self.board:setBoard(board) -- jasklf
    return count
end

function Game:shiftDown()
    local count = 0
    local board = self.board:copy()
    local empty = {}
    for x=1,FIELD_WIDTH do
        table.insert(empty, 0)
    end
    for _, y in ipairs(self.shiftDownRows) do
        count = count + 1
        for shiftdown=y,1,-1 do
            if self.board:isOnBoard(1, shiftdown-1) then
                board[shiftdown] = deepcopy(board[shiftdown-1]) or empty
            end
        end
    end
    self.board:setBoard(board) -- jasklf
    self.shiftDownRows = {}
    return count
end

function Game:shiftDownTimer(dt)
    if not self.clearing then return end
    self.counters.clear = self.counters.clear - dt
    if self.counters.clear <= 0 then
        self.clearing = false
        self:shiftDown()
        self.counters.are = self.delays.lineare
    end
end

function Game:harddrop()
    if not self.board:isColliding(nil, nil, self.y+1) then
        self.lastAction = 'drop'
        self.y = self:findLowestY()
    end
    self:sound('lock')
    self:lock()
end

function Game:hold()
    if stage.blockHold then return end
    if not self.holdAvailable then return end
    if self.holdPiece == nil or self.sakuraHold then
        self.holdPiece = self.piece.name
        self.piece.active = false
        self:nextPiece(true)
    else
        local h = self.holdPiece
        self.holdPiece = self.piece.name
        self.piece = Piece:new(h, self)
        self.x, self.y = self.spawnx, self.spawny
        if h == 'O' then self.x = self.x + 1 end
        self.counters.lock = 0
        self.counters.gravity = 0
    end
    if not self.infiniteHold then
        self.holdAvailable = false
    end
    self.lastAction = 'hold'
end

function Game:nextPiece(held)
    if self.piece and self.piece.active then return end
    local h = self.nextQueue[1]
    self.piece = Piece:new(h, self)
    table.remove(self.nextQueue, 1)
    table.insert(self.nextQueue, self.rng:next())
    self.x, self.y = self.spawnx, self.spawny
    if h == 'O' then self.x = self.x + 1 end
    self.lastAction = 'spawn'

    self.counters.lock = 0
    self.counters.gravity = 0
    self.rotationsPerPiece = 0
    if not held then
        self.holdAvailable = true
    end

    if input:down('hold') and not held then
        self:hold()
    end

    -- if input:down('rotateLeft') then
    --     self:rotate(-1)
    --     self:sound('rotate')
    -- elseif input:down('rotateRight') then
    --     self:rotate(1)
    --     self:sound('rotate')
    -- end

    if self.board:isColliding() then
        -- game over
        self:gameOver()
    end
end

function Game:gameOver()
    self.running = false
    if cstate.onGameOver then
        cstate:onGameOver()
    end
end

function Game:spinDetect()
    local boxes = 0
    local mini = 0
    if self.lastAction == 'rotate' and self.piece.name == 'T' then -- temporary..
        local pn = self.piece.name
        local rs = game.spinDetection[pn][self.piece.rotationstate]
        for ey=1,#rs do
            for ex=1,#rs[1] do
                local f = rs[ey][ex]
                local filled = self.board:hasBlock(self.x+ex, self.y+ey)
                if filled then
                    if f == 1 then
                        boxes = boxes + 1
                    elseif f == 2 then
                        boxes = boxes + 1
                        mini = mini + 1
                    end
                end
            end
        end
    end
    return boxes > 2, mini < 2 -- {is spin, is mini}
end

function Game:handleClear(lc, spin, mini)
    local sound = lc
    if lc == 4 and self.b2b ~= 0 then
        sound = 5
    end
    if sound ~= 0 then
        game.clear[sound]:play()
    end
    if lc == 4 or spin then
        self.b2b = self.b2b + 1
    elseif lc ~= 0 then
        self.b2b = 0
    end
    if lc == 0 then
        if not spin then
            self.combo = 0
        end
    else
        self.combo = self.combo + 1
        local f = math.clamp(self.combo-1, 0, #game.combo)
        if f ~= 0 then
            game.combo[f]:play()
        end
    end

    if cstate.handleMove then
        cstate:handleMove(lc, spin, mini)
    end
end