modifier_demo_creep_invulnerable = class({})
function modifier_demo_creep_invulnerable:IsPurgeException() return false end
function modifier_demo_creep_invulnerable:IsPurgable() return false end
function modifier_demo_creep_invulnerable:GetTexture() return 'creature_ancient' end

function modifier_demo_creep_invulnerable:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 

end 


function modifier_demo_creep_invulnerable:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end 

function modifier_demo_creep_invulnerable:GetModifierIncomingDamage_Percentage() return -10000 end
