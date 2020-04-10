-- Zancudo Gates (GTAO like): (-1600.301 2806.731 18.796)

ZancudoGates = {
    Gates = {
        Open = function()
            EnableIpl('CS3_07_MPGates', false)
        end,
        Close = function()
            EnableIpl('CS3_07_MPGates', true)
        end,
    },

    LoadDefault = function()
        ZancudoGates.Gates.Open()
    end
}