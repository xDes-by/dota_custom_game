item_warsong = class({})

LinkLuaModifier("modifier_item_warsong", "items/warsong", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_warsong_unique_passive", "items/warsong", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_warsong_buff", "items/warsong", LUA_MODIFIER_MOTION_NONE)

function item_warsong:GetIntrinsicModifierName()
	return "modifier_item_warsong"
end

modifier_item_warsong = class({})

function modifier_item_warsong:IsHidden() return true end
function modifier_item_warsong:IsDebuff() return false end
function modifier_item_warsong:IsPurgable() return false end
function modifier_item_warsong:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_warsong:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_warsong:OnRefresh(keys)
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if (not parent) or (not ability) or parent:IsNull() or ability:IsNull() then return end

	self.bonus_dmg = ability:GetSpecialValueFor("bonus_dmg") or 0
	self.bonus_as = ability:GetSpecialValueFor("bonus_as") or 0
	self.bonus_agi = ability:GetSpecialValueFor("bonus_agi") or 0
	self.bonus_evasion = ability:GetSpecialValueFor("bonus_evasion") or 0
	self.bonus_ms = ability:GetSpecialValueFor("bonus_ms") or 0

	if IsServer() then
		parent:AddNewModifier(parent, ability, "modifier_item_warsong_unique_passive", {})
		parent:CalculateStatBonus(false)
	end
end

function modifier_item_warsong:OnDestroy()
	if IsClient() then return end

    local parent = self:GetParent()

	if parent and (not parent:IsNull()) and (not parent:HasModifier("modifier_item_warsong")) then
		parent:RemoveModifierByName("modifier_item_warsong_unique_passive")
	end
end

function modifier_item_warsong:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_item_warsong:GetModifierPreAttack_BonusDamage() return self.bonus_dmg end
function modifier_item_warsong:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end
function modifier_item_warsong:GetModifierBonusStats_Agility() return self.bonus_agi end
function modifier_item_warsong:GetModifierEvasion_Constant() return self.bonus_evasion end
function modifier_item_warsong:GetModifierMoveSpeedBonus_Percentage() return self.bonus_ms end



modifier_item_warsong_unique_passive = class({})

function modifier_item_warsong_unique_passive:IsHidden() return true end
function modifier_item_warsong_unique_passive:IsDebuff() return false end
function modifier_item_warsong_unique_passive:IsPurgable() return false end
function modifier_item_warsong_unique_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_warsong_unique_passive:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_warsong_unique_passive:OnRefresh(keys)
	if IsClient() then return end

	local ability = self:GetAbility()

	if ability and (not ability:IsNull()) then
		self.proc_chance = ability:GetSpecialValueFor("proc_chance") or 0
		self.proc_dmg = ability:GetSpecialValueFor("proc_dmg") or 0
	end
end

function modifier_item_warsong_unique_passive:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_EVENT_ON_ATTACK_FAIL
		}
	end
end

function modifier_item_warsong_unique_passive:OnAttackStart(keys)
	if keys.attacker and keys.attacker == self:GetParent() and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull()) and RollPercentage(self.proc_chance) then
		keys.attacker:AddNewModifier(keys.attacker, nil, "modifier_item_warsong_buff", {duration = 1.5, damage = self.proc_dmg})
	end
end

function modifier_item_warsong_unique_passive:OnAttackFail(keys)
	if keys.target and keys.target == self:GetParent() and keys.attacker and not (keys.attacker:IsNull() or keys.target:IsNull()) then
		keys.target:PerformAttack(keys.attacker, true, true, true, false, true, false, false)
	end
end



modifier_item_warsong_buff = class({})

function modifier_item_warsong_buff:IsHidden() return true end
function modifier_item_warsong_buff:IsDebuff() return false end
function modifier_item_warsong_buff:IsPurgable() return false end

function modifier_item_warsong_buff:OnCreated(keys)
	if IsClient() then return end

	self.bonus_damage = keys.damage
end

function modifier_item_warsong_buff:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
end

function modifier_item_warsong_buff:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
	end
end

function modifier_item_warsong_buff:GetModifierProcAttack_Feedback(keys)
	if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull()) then
		keys.attacker:PerformAttack(keys.target, false, false, true, false, false, false, false)
		ApplyDamage({victim = keys.target, attacker = keys.attacker, damage = self.bonus_damage, damage_type = DAMAGE_TYPE_MAGICAL})
		self:Destroy()
	end
end
