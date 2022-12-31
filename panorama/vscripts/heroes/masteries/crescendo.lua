modifier_chc_mastery_crescendo = class({})

function modifier_chc_mastery_crescendo:IsHidden() return self:GetStackCount() <= 0 end
function modifier_chc_mastery_crescendo:IsDebuff() return false end
function modifier_chc_mastery_crescendo:IsPurgable() return false end
function modifier_chc_mastery_crescendo:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_crescendo:GetTexture() return "masteries/crescendo" end

function modifier_chc_mastery_crescendo:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
	else
		return {
			MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
		}
	end
end

function modifier_chc_mastery_crescendo:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * (self.bonus_damage or 0)
end

function modifier_chc_mastery_crescendo:GetModifierProcAttack_Feedback(keys)
	if keys.attacker:GetTeam() == keys.target:GetTeam() or (not keys.target:IsAlive()) then return end

	if self:GetStackCount() >= self.stack_limit then return end

	self:IncrementStackCount()
end

function modifier_chc_mastery_crescendo:OnRoundEndForTeam(keys)
	if IsClient() then return end
	if Enfos:IsEnfosMode() then return end

	self:SetStackCount(0)
end

function modifier_chc_mastery_crescendo:OnPvpEndedForDuelists(keys)
	if IsClient() then return end
	if Enfos:IsEnfosMode() then return end
	
	self:SetStackCount(0)
end


if GetMapName() == "enfos" and IsServer() then

	function modifier_chc_mastery_crescendo:OnPvpStart(keys)
		local parent = self:GetParent()
		local team = parent:GetTeam()
	
		for _, hero in pairs(EnfosPVP.dueling_heroes[team]) do
			if parent == hero then
				self:SetStackCount(0)
				return
			end
		end
	end

end


modifier_chc_mastery_crescendo_1 = class(modifier_chc_mastery_crescendo)
modifier_chc_mastery_crescendo_2 = class(modifier_chc_mastery_crescendo)
modifier_chc_mastery_crescendo_3 = class(modifier_chc_mastery_crescendo)

function modifier_chc_mastery_crescendo_1:OnCreated(keys)
	self.bonus_damage = 0.4
	self.stack_limit = 200
end

function modifier_chc_mastery_crescendo_2:OnCreated(keys)
	self.bonus_damage = 0.8
	self.stack_limit = 200
end

function modifier_chc_mastery_crescendo_3:OnCreated(keys)
	self.bonus_damage = 1.6
	self.stack_limit = 200
end
