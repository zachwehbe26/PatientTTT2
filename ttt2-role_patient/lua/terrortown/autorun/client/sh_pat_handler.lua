AddCSLuaFile()


net.Receive("ttt2_pat_infect", function()
    EPOP:AddMessage({text =  LANG.TryTranslation("lang_pat_infect_title"), color = PATIENT.color}, {text = LANG.TryTranslation("lang_pat_infect_desc")}, 5, nil, true)
end)


