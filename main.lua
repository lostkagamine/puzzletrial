_GAME_VERSION = '1.0.0'

game = {}

require "constants"
Input = require "lib/input"
class = require "lib/middleclass"
require "repeatsounds"
require "util"
require "engine"
inspect = require "lib/inspect"

local json = require "lib/json"

stage = nil
stageno = nil

game.font = { --keeping two separate font tables? lul
    big = love.graphics.newFont("data/standard.ttf", 48),
    small = love.graphics.newFont("data/standard.ttf", 12),
    std = love.graphics.newFont("data/standard.ttf", 18),
    med = love.graphics.newFont("data/standard.ttf", 24),
    med2 = love.graphics.newFont("data/standard.ttf", 30),
    med3 = love.graphics.newFont("data/standard.ttf", 36),
    larger = love.graphics.newFont("data/standard.ttf", 40)
}

game.sfx = {
    heavydamage = love.audio.newSource('data/sfx/heavydamage.wav', 'static'),
    move = love.audio.newSource('data/sfx/move.wav', 'static'),
    rotate = love.audio.newSource('data/sfx/rotate.wav', 'static'),
    lock = love.audio.newSource('data/sfx/lock.wav', 'static'),
    fluff = love.audio.newSource('data/sfx/fluff.ogg', 'static'),
    error = love.audio.newSource('data/sfx/error.mp3', 'static'),
    ready = love.audio.newSource('data/sfx/ready.wav', 'static'),
    go = love.audio.newSource('data/sfx/go.wav', 'static'),
    spin = love.audio.newSource('data/sfx/spin.wav', 'static')
}

game.repeatsfx = {}
for i, j in pairs(game.sfx) do
    game.repeatsfx[i] = RepeatableSound:new(j)
end

game.save = {}

game.combo = {}
for i=1,15 do
    game.combo[i] = RepeatableSound:new(love.audio.newSource('data/sfx/combo/combo'..i..'.wav', 'static'))
    game.combo[i].source:setVolume(0.8)
end

game.clear = RepeatableSound.static.buildTable({
    'single.wav', 'double.wav', 'triple.wav', 'quad.wav', 'b2b_quad.wav'
}, 'data/sfx/clear')

game.bgm = {}
game.bgm.level1 = love.audio.newSource('data/bgm/mirai_ha_sodotteru.mp3', 'stream')
game.bgm.level2 = love.audio.newSource('data/bgm/information_source.mp3', 'stream')
game.bgm.level3 = love.audio.newSource('data/bgm/lumiere.mp3', 'stream')
game.bgm.level4 = love.audio.newSource('data/bgm/beat_noise.mp3', 'stream')
game.bgm.credits = love.audio.newSource('data/bgm/sudden_events.mp3', 'stream')
local isplaying = nil

for _, j in pairs(game.bgm) do
    j:setLooping(true)
    j:setVolume(0.4)
end

function playmusic(name)
    isplaying = game.bgm[name]
    isplaying:play()
end

function stopmusic()
    if not isplaying then return end
    isplaying:stop()
end

font = {}
font.reg = love.graphics.newFont('data/standard.ttf', 20)
font.reg2 = love.graphics.newFont('data/standard.ttf', 24)
font.menu = love.graphics.newFont('data/standard.ttf', 30)
font.big = love.graphics.newFont('data/bold.ttf', 56)

courselist = {}
rotationlist = {}
states = {}

gfx = {
    logo = love.graphics.newImage('data/logo.png'),
    block = love.graphics.newImage('data/gfx/block.png'),
    smallblock = love.graphics.newImage('data/gfx/smallblock.png'),
    background = love.graphics.newImage('data/gfx/background.png'),
    mihara = love.graphics.newImage('data/gfx/mihara.jpg')
}

charasprites = {
    neutral = love.graphics.newImage('data/character/neutral.png'),
    smug = love.graphics.newImage('data/character/smug.png'),
    happy = love.graphics.newImage('data/character/happy.png'),
    annoyed = love.graphics.newImage('data/character/annoyed.png')
}

fmv = {
    ronaldinho = love.graphics.newVideo('data/fmv/ronaldinho.ogv')
}

settings = {
    drawNext = 3
}

curr_course = nil
curr_rotation = nil

cstate = nil
cstate_name = nil

shaders = {}
local cur_shader = nil
local sh_time = 0

local drawdebug = false
local oldver = false

screen_cvs = nil

videoplaying = nil
local vc = love.graphics.newCanvas()

function switchstate(t)
    if not states[t] then return end
    if cstate and cstate.off then cstate:off() end
    cstate = states[t]
    if cstate and cstate.on then cstate:on() end
    cstate_name = t
    sh_time = love.timer.getTime()
    if videoplaying then
        videoplaying:pause()
        videoplaying:rewind()
    end
    videoplaying = nil
end

function enableshader(n)
    if n == nil then
        cur_shader = nil
        return
    end
    cur_shader = shaders[n]
end

function loadcourse(name)
    if not courselist[name] then return end
    currcourse = courselist[name]
    stages = currcourse.stages
end

function startstage(number, noswitch)
    if not stages[number] then
        return false
    end

    stage = stages[number]
    stageno = number

    curr_rotation = stage.rotation or 'srs'

    if stage.on then
        stage:on()
    end

    if not noswitch then
        switchstate('game')
    end

    return true
end

function saveFile()
    love.filesystem.write('save.json', json.encode(game.save))
end

function love.load()
    local maj, min, rev, cod = love.getVersion()
    if maj < 11 then
        oldver = true
        return
    end
    
    screen_cvs = love.graphics.newCanvas()

    input = Input()

    if love.filesystem.getInfo('keys.json') then
        local data = json.decode(love.filesystem.read('keys.json'))
        for action, keys in pairs(data) do
            for _, k in ipairs(keys) do
                input:bind(k, action)
            end
        end
    else
        local defaultInputBinding = {
            harddrop = 'up',
            softdrop = 'down',
            left = 'left',
            right = 'right',
            rotateLeft = {'s', 'f'},
            rotateRight = {'a', 'd'},
            hold = 'space'
        }
        
        for i, j in pairs(defaultInputBinding) do
            if type(j) == 'string' then
                input:bind(j, i)
            else
                for _, k in ipairs(j) do
                    input:bind(k, i)
                end
            end
        end
    end

    if love.filesystem.getInfo('save.json') then
        local data = json.decode(love.filesystem.read('save.json'))
        game.save = data
    else
        game.save = {
            cleared = {
                introductory = false,
                intermediate = false,
                advanced = false,
                grandmaster = false
            }
        }

        saveFile()
    end

    local e = love.filesystem.getDirectoryItems('rotation/')
    for _, i in ipairs(e) do -- handle rotation loading
        if (love.filesystem.getInfo('rotation/'..i, {type='file'})).type == 'file' then
            local h = i:sub(0, #i-4 --[[.lua]])
            rotationlist[h] = require("./rotation/"..h)
        end
    end

    local e = love.filesystem.getDirectoryItems('course/')
    for _, i in ipairs(e) do -- handle course loading
        if (love.filesystem.getInfo('course/'..i, {type='file'})).type == 'file' then
            local h = i:sub(0, #i-4 --[[.lua]])
            courselist[h] = require("./course/"..h)
        end
    end

    local e = love.filesystem.getDirectoryItems('state/')
    for _, i in ipairs(e) do -- handle state loading
        if (love.filesystem.getInfo('state/'..i, {type='file'})).type == 'file' then
            local h = i:sub(0, #i-4 --[[.lua]])
            states[h] = require("./state/"..h)
        end
    end

    e = love.filesystem.getDirectoryItems('frag/')
    for _, i in ipairs(e) do -- handle shader loading
        if (love.filesystem.getInfo('frag/'..i, {type='file'})).type == 'file' then
            local h = i:sub(0, #i-5 --[[.frag]])
            shaders[h] = love.graphics.newShader('frag/'..i)
        end
    end

    switchstate('warning')

    if cstate.doneLoading then
        cstate:doneLoading()
    end
end

function love.update(dt)
    if oldver then return end

    if cstate and cstate.update then
        cstate:update(dt)
    end

    if cur_shader and cur_shader:hasUniform('u_time') then
        local t = love.timer.getTime() - sh_time
        cur_shader:send('u_time', t)
    end

    if videoplaying and not videoplaying:isPlaying() then
        videoplaying:pause()
    end
end

function love.draw()
    
    love.graphics.setShader()
    love.graphics.clear()
    if oldver then
        love.graphics.setFont(font.big)
        love.graphics.print('OLD VERSION', 20, 20)
        love.graphics.setFont(font.reg)
        love.graphics.print([[Your version of Love2D is too old to run this game.
Please upgrade to Love2D version 11.0 or higher.

Push [SPACEBAR] to open https://love2d.org,
or press [ESCAPE] to quit.]], 20, 80)
        return
    end

    love.graphics.setCanvas({screen_cvs, stencil=true, depth=true})
    love.graphics.clear()
    love.graphics.setBlendMode('alpha')
    
    if cstate and cstate.draw then
        cstate:draw()
    end

    love.graphics.setCanvas()
    if cur_shader then
        love.graphics.setShader(cur_shader)
    else
        love.graphics.setShader() 
    end

    love.graphics.setBlendMode('alpha', 'premultiplied')

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(screen_cvs)


    love.graphics.setBlendMode('alpha')

    if videoplaying then
        love.graphics.setCanvas(vc)
        love.graphics.draw(videoplaying)
        love.graphics.setCanvas()
        love.graphics.setBlendMode('alpha', 'premultiplied')
        love.graphics.setShader(shaders.chroma)
        shaders.chroma:send('pos', videoplaying:tell())
        shaders.chroma:send('playing', videoplaying:isPlaying())
        love.graphics.draw(vc)
        love.graphics.setBlendMode('alpha')
    end
    --love.graphics.present()

    love.graphics.setShader()


    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(font.reg)
    love.graphics.setShader()

    if drawdebug then
        love.graphics.print(([[Puzzle Trial ver. %s
FPS: %d
Current state: %s]]):format(_GAME_VERSION, love.timer.getFPS(), cstate_name), 0, 0)
    end
end

function love.keypressed(k, sc, r)
    if oldver then
        if k == 'escape' then
            love.event.quit()
        end
        if k == 'space' then
            love.system.openURL('https://love2d.org')
        end
        return
    end

    if k == 'f1' then
        drawdebug = not drawdebug
        return
    end

    if cstate and cstate.keydown then
        cstate:keydown(k, sc, r)
    end
end
