modifier_demo_free_spells = class({})
function modifier_demo_free_spells:IsPurgeException() return false end
function modifier_demo_free_spells:IsPurgable() return false end
function modifier_demo_free_spells:GetTexture() return 'dazzle_weave' end
function modifier_demo_free_spells:RemoveOnDeath() return false end

function modifier_demo_free_spells:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 
end 

function modifier_demo_free_spells:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end 

function modifier_demo_free_spells:GetModifierPercentageCooldown() return 100 end
function modifier_demo_free_spells:GetModifierPercentageManacost() return 100 end
