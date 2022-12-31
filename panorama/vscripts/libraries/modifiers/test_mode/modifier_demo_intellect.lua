modifier_demo_intellect = class({})
function modifier_demo_intellect:IsPurgeException() return false end
function modifier_demo_intellect:IsPurgable() return false end
function modifier_demo_intellect:GetTexture() return 'item_book_of_intelligence_2' end
function modifier_demo_intellect:RemoveOnDeath() return false end

function modifier_demo_intellect:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 
end 

function modifier_demo_intellect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end 

function modifier_demo_intellect:GetModifierBonusStats_Intellect() return self:GetStackCount() end
