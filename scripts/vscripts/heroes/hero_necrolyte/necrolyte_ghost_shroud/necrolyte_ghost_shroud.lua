-------------------------------------------
--			GHOST SHROUD
-------------------------------------------

necrolyte_ghost_shroud_lua = class({})
LinkLuaModifier("modifier_ghost_shroud_active_lua", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_shroud_aura_debuff_lua", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_shroud_buff_lua", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ghost_shroud_debuff_lua", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)

function necrolyte_ghost_shroud_lua:GetAbilityTextureName()
	return "necrolyte_sadist"
end

function necrolyte_ghost_shroud_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int11") then
		return self.BaseClass.GetCooldown( self, level ) - 6
	end
end

function necrolyte_ghost_shroud_lua:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		-- Params
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		local healing_amp_pct = self:GetSpecialValueFor("healing_amp_pct")
		local slow_pct = self:GetSpecialValueFor("slow_pct")

		caster:EmitSound("Hero_Necrolyte.SpiritForm.Cast")

		caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
		caster:AddNewModifier(caster, self, "modifier_ghost_shroud_active_lua", { duration = duration })
		caster:AddNewModifier(caster, self, "modifier_ghost_shroud_aura_debuff_lua", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})

		if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str11") then
			necrolyte_death_pulse_lua = self:GetCaster():FindAbilityByName("necrolyte_death_pulse_lua")
			if necrolyte_death_pulse_lua and necrolyte_death_pulse_lua:GetLevel() > 0 then
				necrolyte_death_pulse_lua:OnSpellStart(
					self:GetCaster():GetAbsOrigin(),
					necrolyte_death_pulse_lua:GetSpecialValueFor("radius")
				)
			end
		end
	end
end

function necrolyte_ghost_shroud_lua:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function necrolyte_ghost_shroud_lua:IsHiddenWhenStolen()
	return false
end

---------------------------------------------
-- Ghost Shroud Active Modifier (Purgable) --
---------------------------------------------

modifier_ghost_shroud_active_lua = class({})

function modifier_ghost_shroud_active_lua:IsHidden() return false end
function modifier_ghost_shroud_active_lua:IsPurgable() return true end

function modifier_ghost_shroud_active_lua:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_ghost_shroud_active_lua:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_ghost_shroud_active_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_ghost_shroud_active_lua:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self:GetAbility():GetSpecialValueFor("magic_amp_pct") * (-1)
end

function modifier_ghost_shroud_active_lua:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end

function modifier_ghost_shroud_active_lua:GetModifierMPRegenAmplify_Percentage()
	return self.healing_amp_pct
end
function modifier_ghost_shroud_active_lua:GetModifierMPRestoreAmplify_Percentage()
	return self.healing_amp_pct
end
function modifier_ghost_shroud_active_lua:GetModifierHPRegenAmplify_Percentage()
	return self.healing_amp_pct
end

function modifier_ghost_shroud_active_lua:GetModifierAttackSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_agi11") then
		return 150
	end
end

function modifier_ghost_shroud_active_lua:CheckState()
	return
		{
			[MODIFIER_STATE_DISARMED] = self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_agi8") == nil,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end

-- IntervalThink to remove active if magic immune (so you can't stack the two)
function modifier_ghost_shroud_active_lua:OnCreated()
	self.healing_amp_pct	= self:GetAbility():GetSpecialValueFor("healing_amp_pct")
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_ghost_shroud_active_lua:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then self:Destroy()	end
end

----------------------------------------
-- Ghost Shroud Negative Aura Handler --
----------------------------------------

modifier_ghost_shroud_aura_debuff_lua = class({})

function modifier_ghost_shroud_aura_debuff_lua:IsHidden() return true end
function modifier_ghost_shroud_aura_debuff_lua:IsPurgable() return false end
function modifier_ghost_shroud_aura_debuff_lua:IsAura() return true end

function modifier_ghost_shroud_aura_debuff_lua:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
	end
end

function modifier_ghost_shroud_aura_debuff_lua:GetAuraRadius()
	return self.radius
end

function modifier_ghost_shroud_aura_debuff_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_ghost_shroud_aura_debuff_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ghost_shroud_aura_debuff_lua:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_ghost_shroud_aura_debuff_lua:GetModifierAura()
	return "modifier_ghost_shroud_debuff_lua"
end

function modifier_ghost_shroud_aura_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

-------------------------------------------------------
-- Ghost Shroud Negative Aura Debuff (Movement Slow) --
-------------------------------------------------------

modifier_ghost_shroud_debuff_lua = class({})

function modifier_ghost_shroud_debuff_lua:IsHidden() return false end
function modifier_ghost_shroud_debuff_lua:IsDebuff() return true end

function modifier_ghost_shroud_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_ghost_shroud_debuff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_ghost_shroud_debuff_lua:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() and not self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str8") then
		return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
	end
end

function modifier_ghost_shroud_debuff_lua:OnCreated( kv )
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int8") then
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetIntellect() * 0.5 * 0.2,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
		}
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_ghost_shroud_debuff_lua:OnIntervalThink()
	ApplyDamage(self.damageTable)
end