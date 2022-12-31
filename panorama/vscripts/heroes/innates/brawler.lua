innate_brawler = class({})

LinkLuaModifier("modifier_innate_brawler", "heroes/innates/brawler", LUA_MODIFIER_MOTION_NONE)

function innate_brawler:GetIntrinsicModifierName()
	return "modifier_innate_brawler"
end





modifier_innate_brawler = class({})

function modifier_innate_brawler:IsHidden() return self:GetStackCount() == 0 end
function modifier_innate_brawler:IsDebuff() return false end
function modifier_innate_brawler:IsPurgable() return false end
function modifier_innate_brawler:RemoveOnDeath() return true end
function modifier_innate_brawler:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_brawler:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_brawler:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.stacks_creep = ability:GetSpecialValueFor("stacks_creep") or 0
	self.stacks_hero = ability:GetSpecialValueFor("stacks_hero") or 0
	self.attack_speed_stack = ability:GetSpecialValueFor("attack_speed_stack") or 0
	self.damage_stack = ability:GetSpecialValueFor("damage_stack") or 0
	self.move_speed_stack = ability:GetSpecialValueFor("move_speed_stack") or 0
	self.buff_duration = ability:GetSpecialValueFor("buff_duration") or 0
end

function modifier_innate_brawler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_innate_brawler:OnAttackLanded(keys)
	if IsClient() or keys.target ~= self:GetParent() then return end

	if keys.attacker:IsHero() then
		self:AddIndependentStack(self.buff_duration, nil, false, {stacks = self.stacks_hero})
	else
		self:AddIndependentStack(self.buff_duration, nil, false, {stacks = self.stacks_creep})
	end
end

-- ability exceptions:
-- tombstone
function modifier_innate_brawler:OnAbilityExceptionHit()
	self:AddIndependentStack(self.buff_duration, nil, false, {stacks = self.stacks_creep})
end

function modifier_innate_brawler:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * self.attack_speed_stack
end

function modifier_innate_brawler:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * self.damage_stack
end

function modifier_innate_brawler:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount() * self.move_speed_stack
end

function modifier_innate_brawler:GetModifierIgnoreMovespeedLimit()
	return 1
end


if GetMapName() == "enfos" and IsServer() then

	function modifier_innate_brawler:OnPvpStart(keys)
		local parent = self:GetParent()
		local team = parent:GetTeam()
	
		for _, hero in pairs(EnfosPVP.dueling_heroes[team]) do
			if parent == hero then
				self:CancelIndependentStacks()
				return
			end
		end
	end

end
