LinkLuaModifier("modifier_creature_heavy_weapon", "creatures/abilities/regular/creature_heavy_weapon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_heavy_weapon_effect", "creatures/abilities/regular/creature_heavy_weapon", LUA_MODIFIER_MOTION_NONE)

creature_heavy_weapon = class({})

function creature_heavy_weapon:GetIntrinsicModifierName()
	return "modifier_creature_heavy_weapon"
end

modifier_creature_heavy_weapon = class({})

function modifier_creature_heavy_weapon:IsHidden() return true end
function modifier_creature_heavy_weapon:IsDebuff() return false end
function modifier_creature_heavy_weapon:IsPurgable() return false end
function modifier_creature_heavy_weapon:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_heavy_weapon:OnCreated(keys)
	if IsServer() then
		local parent = self:GetParent()
		self.ability = self:GetAbility()
		self.crit_damage = self.ability:GetSpecialValueFor("crit_damage")
		parent:AddNewModifier(parent, self:GetAbility(), "modifier_creature_heavy_weapon_effect", {})
	end
end

function modifier_creature_heavy_weapon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
	return funcs
end

if IsServer() then
	function modifier_creature_heavy_weapon:GetModifierProcAttack_Feedback(keys)
		if not self.ability:IsCooldownReady() then return end

		local unit_damage = 0.5 * (keys.attacker:GetBaseDamageMax() + keys.attacker:GetBaseDamageMin())
		local bonus_damage = unit_damage * (0.01 * self.crit_damage - 1)

		keys.target:EmitSound("HeavyWeapon.Proc")

		ApplyDamage({
			attacker = keys.attacker, 
			victim = keys.target, 
			damage = bonus_damage, 
			damage_type = DAMAGE_TYPE_PHYSICAL, 
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK
		})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, keys.target, unit_damage * self.crit_damage * 0.01, nil)
		self.ability:UseResources(false, false, true)

		keys.attacker:RemoveModifierByName("modifier_creature_heavy_weapon_effect")
		Timers:CreateTimer(self.ability:GetCooldownTimeRemaining(), function()
			if (not keys.attacker:IsNull()) and keys.attacker:IsAlive() then
				keys.attacker:AddNewModifier(keys.attacker, self.ability, "modifier_creature_heavy_weapon_effect", {})
			end
		end)
	end
end



modifier_creature_heavy_weapon_effect = class({})

function modifier_creature_heavy_weapon_effect:IsHidden() return true end
function modifier_creature_heavy_weapon_effect:IsDebuff() return false end
function modifier_creature_heavy_weapon_effect:IsPurgable() return false end
function modifier_creature_heavy_weapon_effect:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_heavy_weapon_effect:GetEffectName()
	return "particles/creature/heavy_weaponry.vpcf"
end

function modifier_creature_heavy_weapon_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
