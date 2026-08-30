if SERVER then
	AddCSLuaFile()	
end

SWEP.HoldType               = "normal"

if CLIENT then
   SWEP.PrintName           = "Patient Cough"
   SWEP.Slot                = 8
   SWEP.ViewModelFlip       = false
   SWEP.ViewModelFOV        = 90
   SWEP.DrawCrosshair       = false
	
   SWEP.EquipMenuData = {
      type = "item_weapon",
      desc = "Cough on other players to get them infected. Infected move slower, reduced vision, and have an audible cough"
   };

   SWEP.Icon                = "vgui/ttt/icon_pat"
   SWEP.IconLetter          = "j"

   function SWEP:Initialize()
		self:AddTTT2HUDHelp("Cough on other players to infect them. Eventually they will develop an immunity.")
	end
end

SWEP.Base                   = "weapon_tttbase"

SWEP.UseHands               = true
SWEP.ViewModel              = "models/weapons/c_arms.mdl"
SWEP.WorldModel             = ""

SWEP.Primary.Damage         = 0
SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Delay          = 2
SWEP.Primary.Ammo           = "none"

SWEP.Kind                   = WEAPON_CLASS
SWEP.AllowDrop              = false -- Is the player able to drop the swep

SWEP.IsSilent               = false

-- Pull out faster than standard guns
SWEP.DeploySpeed            = 2


--Removes the SWEP on death or drop
function SWEP:OnDrop()
	self:Remove()
end

if CLIENT then

    hook.Add("PostDrawTranslucentRenderables", "DrawPlayerCircle", function()

            --only render sphere for patients, and have the cough equipped
            if GetRoundState() ~= ROUND_ACTIVE then return end
            local client = LocalPlayer()
            if not client:IsValid() then return end
            if not client:Alive() or client:IsSpec() then return end
            if client:GetSubRole() ~= ROLE_PATIENT then return end
            if client:GetActiveWeapon() == NULL then return end
            if client:GetActiveWeapon():GetClass() ~= "ttt_patient_cough" then return end

            --Initialize colorsphere as the color of the role
            local colorSphere = util.ColorLighten(roles.PATIENT.color, 120)

            --alpha value for the sphere
            colorSphere.a = 3
            local pos = client:GetPos()

            --size of the sphere
            local maxRenderDistance = 200

            --set the color
            render.SetColorMaterial()

            --render both the back and front site of the sphere
            render.CullMode(MATERIAL_CULLMODE_CW)

            render.DrawSphere(pos, maxRenderDistance, 30, 30, colorSphere)
            render.CullMode(MATERIAL_CULLMODE_CCW)

    end)
end

--function that checks if players are in the infection sphere
function checkIfPlyInSphere(patient)
    local patPos = patient:GetPos()
    for _, ply in ipairs( player.GetAll() ) do
        --valid player checks
        if not ply:Alive() or ply:IsSpec() then return end
        --skip patient player
        if patient == ply then continue end
            --if in radius, infect!
            if ply:GetPos():Distance(patPos) <= 200 then
                makePlayerPatientSick(ply)
                print("Player: ",ply:Nick()," is in the radius!\nInfecting Player....")
                --add to global values
                --PATIENT_DATA:AddInfected(ply) TODO: FIX

            end
    end
end

-- Override original primary attack

function SWEP:PrimaryAttack()
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

    if not IsValid(self:GetOwner()) then return end

    self:GetOwner():LagCompensation(true)


    --play cough sound
    self:GetOwner():EmitSound("coof.wav")

    if SERVER then
        --Check if anyone is in the sphere
        checkIfPlyInSphere(self:GetOwner())
    end


end








