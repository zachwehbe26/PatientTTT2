AddCSLuaFile()
PATIENT_DATA = {}
PATIENT_DATA.playersInfected = {}


function patAddPlayerInfected( ply )
    print("Adding player ",ply:Nick()," to the infected table ")
    table.insert(playersInfected, ply)
end


net.Receive("ttt2_pat_infect", function()
    EPOP:AddMessage({text =  LANG.TryTranslation("lang_pat_infect_title"), color = PATIENT.color}, {text = LANG.TryTranslation("lang_pat_infect_desc")}, 5, nil, true)
end)

