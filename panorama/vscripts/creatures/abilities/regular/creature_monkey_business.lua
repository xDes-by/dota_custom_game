LinkLuaModifier("modifier_creature_monkey_business", "creatures/abilities/regular/creature_monkey_business", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_monkey_business_debuff", "creatures/abilities/regular/creature_monkey_business", LUA_MODIFIER_MOTION_NONE)

creature_monkey_business = class({})

function creature_monkey_business:GetIntrinsicModifierName()
	return "modifier_creature_monkey_business"
end



modifier_creature_monkey_business = class({})

function modifier_creature_monkey_business:OnCreated()
	if IsClient() then return end

	self.ability = self:GetAbility()
	self.damage_up = self.ability:GetSpecialValueFor("damage_up")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creature_monkey_business:IsHidden() return true end
function modifier_creature_monkey_business:IsDebuff() return false end
function modifier_creature_monkey_business:IsPurgable() return false end
function modifier_creature_monkey_business:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_monkey_business:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
		return funcs
	end

	function modifier_creature_monkey_business:GetModifierProcAttack_Feedback(keys)
		local modifier = keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_monkey_business_debuff", {
			duration = self.duration
		})
		if not modifier then return end

		modifier:SetStackCount(modifier:GetStackCount() + self.damage_up)
		ApplyDamage({
			attacker = keys.attacker, 
			victim = keys.target, 
			damage = modifier:GetStackCount(), 
			damage_type = DAMAGE_TYPE_PHYSICAL,	
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
		})
	end
end



modifier_creature_monkey_business_debuff = class({})

function modifier_creature_monkey_business_debuff:IsHidden() return false end
function modifier_creature_monkey_business_debuff:IsDebuff() return true end
function modifier_creature_monkey_business_debuff:IsPurgable() return false end

function modifier_creature_monkey_business_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_creature_monkey_business_debuff:OnTooltip()
	return self:GetStackCount()
end
