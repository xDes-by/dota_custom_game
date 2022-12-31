LinkLuaModifier("modifier_creature_dread", "creatures/abilities/regular/creature_dread", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_dread_debuff", "creatures/abilities/regular/creature_dread", LUA_MODIFIER_MOTION_NONE)

creature_dread = class({})

function creature_dread:GetIntrinsicModifierName()
	return "modifier_creature_dread"
end



modifier_creature_dread = class({})

function modifier_creature_dread:OnCreated()
	if IsClient() then return end

	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.damage_down = self.ability:GetSpecialValueFor("damage_down")
end

function modifier_creature_dread:IsHidden() return true end
function modifier_creature_dread:IsDebuff() return false end
function modifier_creature_dread:IsPurgable() return false end
function modifier_creature_dread:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_dread:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_dread:OnAttackLanded(keys)
		if keys.target:IsMagicImmune() then return end
		if not self.ability or self.ability:IsNull() then return end
		
		keys.target:RemoveModifierByName("modifier_creature_dread_debuff")
		keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_dread_debuff", {
			duration = self.duration * (1 - keys.target:GetStatusResistance()), 
			damage_down = self.damage_down,
		})
	end
end



modifier_creature_dread_debuff = class({})

function modifier_creature_dread_debuff:IsHidden() return false end
function modifier_creature_dread_debuff:IsDebuff() return true end
function modifier_creature_dread_debuff:IsPurgable() return true end

function modifier_creature_dread_debuff:GetEffectName()
	return "particles/creature/dread.vpcf"
end

function modifier_creature_dread_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_dread_debuff:OnCreated(keys)
	if IsServer() and keys.damage_down ~= nil then
		self:SetStackCount(keys.damage_down)
	end
end

function modifier_creature_dread_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function modifier_creature_dread_debuff:GetModifierDamageOutgoing_Percentage()
	return (-1) * self:GetStackCount()
end
