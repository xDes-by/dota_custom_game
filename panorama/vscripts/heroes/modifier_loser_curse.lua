modifier_loser_curse = class({})

function modifier_loser_curse:IsDebuff() return true end
function modifier_loser_curse:IsPurgable() return false end
function modifier_loser_curse:IsPermanent() return true end

function modifier_loser_curse:GetTexture()
	return "doom_bringer_doom"
end

function modifier_loser_curse:IsHidden()
	return self:GetParent():HasModifier("modifier_hero_dueling")
end

function modifier_loser_curse:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end

function modifier_loser_curse:OnCreated()
	self.parent = self:GetParent()
	self:OnStackCountChanged()
end

function modifier_loser_curse:OnStackCountChanged()
	local stacks = self:GetStackCount()

	self.incoming_damage = 100 * 1.17 ^ stacks -- +17% on each stack, multiplicative.
	self.outgoing_damage = 100 * 0.83 ^ stacks - 100 -- -17% on each stack, multiplicative.
	self.cooldown_reduction = (1.13 ^ stacks - 1) * 100 -- +13% on each stack, multiplicative.
	self.debuff_reduction = 100 - 100 * 0.87 ^ stacks  -- +13% debuff duration reduction, multiplicative.
end

function modifier_loser_curse:GetModifierIncomingDamage_Percentage()
	if not self.parent or self.parent:IsNull() then return 0 end
	if self.parent:HasModifier("modifier_hero_dueling") then
		return 0
	else
		return self.incoming_damage
	end
end


function modifier_loser_curse:GetModifierTotalDamageOutgoing_Percentage()
	if not self.parent or self.parent:IsNull() then return 0 end
	if self.parent:HasModifier("modifier_hero_dueling") then
		return 0
	else
		return self.outgoing_damage
	end
end


function modifier_loser_curse:GetModifierStatusResistanceCaster()
	if not self.parent or self.parent:IsNull() then return 0 end
	if self.parent:HasModifier("modifier_hero_dueling") then
		return 0
	else
		return self.debuff_reduction
	end
end

function modifier_loser_curse:GetModifierPercentageCooldown()
	if not self.parent or self.parent:IsNull() then return 0 end
	if self.parent:HasModifier("modifier_hero_dueling") then
		return 0
	else
		return self.cooldown_reduction * -1
	end
	
	local ability = params.ability
	if ability and not ability:IsNull() and not ability:IsCooldownReady() then
		ability:EndCooldown()
		ability:StartCooldown(ability:GetEffectiveCooldown(-1) * self.cooldown_reduction)
	end
end


function modifier_loser_curse:OnTooltip()
	return (self.cooldown_reduction - 1) * 100
end


function modifier_loser_curse:OnTooltip()
	return self.cooldown_reduction
end
