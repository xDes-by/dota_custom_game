modifier_demo_free_gold = class({})
function modifier_demo_free_gold:IsPurgeException() return false end
function modifier_demo_free_gold:IsPurgable() return false end
function modifier_demo_free_gold:GetTexture() return 'alchemist_goblins_greed' end
function modifier_demo_free_gold:RemoveOnDeath() return false end

function modifier_demo_free_gold:OnCreated()
	if IsClient() then return end
	if not TestMode:IsTestMode() then 
		self:Destroy()
		return
	end 

	self:GetParent():SetGold(99999, true)
end 
