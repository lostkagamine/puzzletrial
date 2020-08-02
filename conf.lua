function love.conf(f)
    f.window.title = "Puzzle Trial"
    f.window.width = 800
    f.window.height = 600
    f.window.vsync = 0
    f.identity = "puzzletrial"
end

local choices = {
    'fuck',
    'dammit, hailey!!!!!',
    'because the world would be dull without error',
    'but it was me! the crash screen!',
    'we don\'t make mistakes. we make happy accidents!',
    'turn it off and back on',
    'oops',
    'that\'s unexpected',
    'what the fuck did you just do',
    'h',
    'why',
    'l',
    '',
    'on misdrop: error()',
    'aaaaaaaaa',
    ':b:',
    'just blame love2d',
    'it\'s not alright',
    'can rin even code'
}

function love.errorhandler(err)
    local maj, min, patch, codename = love.getVersion()
    local it = choices[love.math.random(1, #choices)]
    local report = ([[-- PUZZLE TRIAL CRASH REPORT --
Ver. %s

"%s"

Love2D %d.%d.%d "%s"
on "%s" (%s, %d processors)
On fire? %s

Technical information below.

%s]]):format(_GAME_VERSION, it,
            maj, min, patch, codename, love.system.getOS(), jit.arch, love.system.getProcessorCount(),
            is_computer_on_fire() and 'yes' or 'no',
            err)
    print(report)

    local w, h, f = love.window.getMode()

    local txt = 'hit C to copy text to clipboard, hit any other key to quit'

    local draw = function()
        love.graphics.setFont(game.font.big)
        love.graphics.print('it\'s not alright', 20, 20)
        love.graphics.setFont(game.font.med)
        love.graphics.printf(report, 20, 90, w-20)

        love.graphics.print(txt, 20, h-40)
    end

    return function()
        love.event.pump()
        for a, b, c, d, e, f in love.event.poll() do
            if a == 'quit' then
                return 1
            end

            if a == 'keypressed' and b == 'c' then
                love.system.setClipboardText(report)
                txt = 'copied! hit any other key to quit'
            elseif a == 'keypressed' and b ~= 'c' then
                return 1
            end
        end

        love.graphics.clear()
        draw()
        love.graphics.present()

        love.timer.sleep(0.01)
    end
end
