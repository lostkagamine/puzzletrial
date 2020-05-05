require('util')

local c = {
    I = hue(180),
    J = hue(240),
    L = hue(30),
    T = hue(270),
    S = hue(120),
    Z = hue(0),
    O = hue(60)
}

local o = [[piececolours = {
]]

for p, c in pairs(c) do
    o = o .. ("    %s = Color.new(%d, %d, %d),\n"):format(p, c[1] * 255, c[2] * 255, c[3] * 255)
end
print(o .. '}')