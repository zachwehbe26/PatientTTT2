AddCSLuaFile()

PATIENT_DATA = {}
PATIENT_DATA.playersInfected = {}


function patAddPlayerInfected( ply )
    --("Adding player ",ply:Nick()," to the infected table ")
    table.insert(PATIENT_DATA.playersInfected, ply)
end

net.Receive("ttt2_pat_infect", function()
    EPOP:AddMessage({text =  LANG.TryTranslation("lang_pat_infect_title"), color = PATIENT.color}, {text = LANG.TryTranslation("lang_pat_infect_desc")}, 5, nil, true)
end)

net.Receive("ttt2_pat_cure", function()
    EPOP:AddMessage({text =  LANG.TryTranslation("lang_pat_cure_title"), color = PATIENT.color}, {text = LANG.TryTranslation("lang_pat_cure_desc")}, 5, nil, true)
end)

--Cure infected player and make him
if SERVER then
    hook.Add("TTTPlayerUsedHealthStation", "PatientHealthStation", function(ply)
        if ply:GetNWBool("patient_poisoned") and GetConVar("ttt2_pat_healstation_cure"):GetBool() then
            makePlayerPatientImmune(ply)
        end
    end)
end
