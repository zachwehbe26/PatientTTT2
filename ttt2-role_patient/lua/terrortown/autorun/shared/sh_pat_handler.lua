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


-- Function that gives immune traits to a player
function makePlayerPatientImmune(sickPlayer)
    timer.Remove("ttt2_sick_ply_cough" .. sickPlayer:SteamID64())
    if sickPlayer:HasEquipmentItem("item_pat_immunity") then return end
    sickPlayer:SetNWBool("patient_poisoned", false)
    STATUS:RemoveStatus(sickPlayer, "ttt2_pat_infection_status")
    if SERVER then --replace infection items with immunity items
        sickPlayer:GiveItem("item_pat_immunity")
        sickPlayer:RemoveItem("item_pat_infection")
        STATUS:AddStatus(sickPlayer, "ttt2_pat_immune_status")
        SendFullStateUpdate()
        net.Start("ttt2_pat_cure")
        net.Send( sickPlayer )
    end

end



--Cure infected player and make him
if SERVER then
    hook.Add("TTTPlayerUsedHealthStation", "PatientHealthStation", function(ply)
        if ply:GetNWBool("patient_poisoned") and GetConVar("ttt2_pat_healstation_cure"):GetBool() then
            makePlayerPatientImmune(ply)
        end
    end)
end
