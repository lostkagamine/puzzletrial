require('util')

local c = {
    I = hue(0),
    J = hue(240),
    L = hue(30),
    T = hue(180),
    S = hue(300),
    Z = hue(120),
    O = hue(60),
    FLAT = {1, 1, 1, 1}
}

local o = [[piececolours = {
]]

for p, c in pairs(c) do
    o = o .. ("    %s = Color.new(%d, %d, %d),\n"):format(p, c[1] * 255, c[2] * 255, c[3] * 255)
end
print(o .. '}')