PillboxHospital = {
    LoadDefault = function()
        RequestIpl('gabz_pillbox_milo_')

        local interior = GetInteriorAtCoords(311.2546, -592.4204, 42.32737)

        local ipls = {
            'rc12b_fixed',
            'rc12b_destroyed',
            'rc12b_default',
            'rc12b_hospitalinterior_lod',
            'rc12b_hospitalinterior'
        }

        Wait(1000)

        for i = 1, #ipls, 1 do
		    if IsIplActive(ipls[i]) then
			    RemoveIpl(ipls[i])
		    end
        end

	    RefreshInterior(interior)
	    LoadInterior(interior)
    end
}