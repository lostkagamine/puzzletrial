return {
    init = function(self)
    end,
    draw = function(self)
        love.graphics.draw(gfx.background)
    end,
    doneLoading = function(self)
        videoplaying = fmv.ronaldinho
        fmv.ronaldinho:play()
    end
}