RepeatableSound = class('RepeatableSound')
function RepeatableSound:initialize(sound)
    self.source = sound 
end
function RepeatableSound:play()
    self.source:clone():play()
end
function RepeatableSound.static.buildTable(tb, path)
    local nt = {}
    for i, j in pairs(tb) do
        nt[i] = RepeatableSound:new(love.audio.newSource(path..'/'..j, 'static'))
    end
    return nt
end