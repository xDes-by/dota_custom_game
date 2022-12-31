modifier_demo_agility = class({})
function modifier_demo_agility:IsPurgeException() return false end
function modifier_demo_agility:IsPurgable() return false end
function modifier_demo_agility:GetTexture() return 'item_book_of_agility_2' end
function modifier_demo_agility:RemoveOnDeath() return false end

function modifier_demo_agility:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 
end 

function modifier_demo_agility:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end 

function modifier_demo_agility:GetModifierBonusStats_Agility() return self:GetStackCount() end
