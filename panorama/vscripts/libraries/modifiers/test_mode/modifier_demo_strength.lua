modifier_demo_strength = class({})
function modifier_demo_strength:IsPurgeException() return false end
function modifier_demo_strength:IsPurgable() return false end
function modifier_demo_strength:GetTexture() return 'item_book_of_strength_2' end
function modifier_demo_strength:RemoveOnDeath() return false end
function modifier_demo_strength:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 
end 

function modifier_demo_strength:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
end 

function modifier_demo_strength:GetModifierBonusStats_Strength() return self:GetStackCount() end
