-------------------------------------------
--			GHOST SHROUD
-------------------------------------------

imba_necrolyte_ghost_shroud = imba_necrolyte_ghost_shroud or class({})
LinkLuaModifier("modifier_imba_ghost_shroud_active", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_aura", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_aura_debuff", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_buff", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_ghost_shroud_debuff", "heroes/hero_necrolyte/necrolyte_ghost_shroud/necrolyte_ghost_shroud", LUA_MODIFIER_MOTION_NONE)

function imba_necrolyte_ghost_shroud:GetAbilityTextureName()
	return "necrolyte_sadist"
end

function imba_necrolyte_ghost_shroud:GetCooldown(level)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self:GetSpecialValueFor("cooldown_scepter")
	end
end

function imba_necrolyte_ghost_shroud:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()

		-- Params
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		local healing_amp_pct = self:GetSpecialValueFor("healing_amp_pct")
		local slow_pct = self:GetSpecialValueFor("slow_pct")

		caster:EmitSound("Hero_Necrolyte.SpiritForm.Cast")

		caster:StartGesture(ACT_DOTA_NECRO_GHOST_SHROUD)
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_active", { duration = duration })
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_aura", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
		caster:AddNewModifier(caster, self, "modifier_imba_ghost_shroud_aura_debuff", { duration = duration, radius = radius, healing_amp_pct = healing_amp_pct, slow_pct = slow_pct})
	end
end

function imba_necrolyte_ghost_shroud:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_necrolyte_ghost_shroud:IsHiddenWhenStolen()
	return false
end

---------------------------------------------
-- Ghost Shroud Active Modifier (Purgable) --
---------------------------------------------

modifier_imba_ghost_shroud_active = class({})

function modifier_imba_ghost_shroud_active:IsHidden() return false end
function modifier_imba_ghost_shroud_active:IsPurgable() return true end

function modifier_imba_ghost_shroud_active:GetEffectName()
	return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf"
end

function modifier_imba_ghost_shroud_active:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE 
	}
end

function modifier_imba_ghost_shroud_active:GetModifierMagicalResistanceDecrepifyUnique( params )
	return self:GetAbility():GetSpecialValueFor("magic_amp_pct") * (-1)
end

function modifier_imba_ghost_shroud_active:GetAbsoluteNoDamagePhysical()
	if self:GetCaster() == self:GetParent() then return 1
	else return nil end
end

function modifier_imba_ghost_shroud_active:GetModifierMPRegenAmplify_Percentage()
	return self.healing_amp_pct
end

function modifier_imba_ghost_shroud_active:GetModifierMPRestoreAmplify_Percentage()
	return self.healing_amp_pct
end

function modifier_imba_ghost_shroud_active:CheckState()
	return
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		}
end

-- IntervalThink to remove active if magic immune (so you can't stack the two)
function modifier_imba_ghost_shroud_active:OnCreated()
	self.healing_amp_pct	= self:GetAbility():GetSpecialValueFor("healing_amp_pct")

	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_imba_ghost_shroud_active:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent():IsMagicImmune() then self:Destroy()	end
end

-----------------------------------------------------
-- Ghost Shroud Positive Aura Handler (Unpurgable) --
-----------------------------------------------------

modifier_imba_ghost_shroud_aura = class({})

function modifier_imba_ghost_shroud_aura:IsHidden() return false end
function modifier_imba_ghost_shroud_aura:IsPurgable() return false end
function modifier_imba_ghost_shroud_aura:IsAura() return true end

function modifier_imba_ghost_shroud_aura:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
		self.healing_amp_pct = params.healing_amp_pct
		self.slow_pct = params.slow_pct
	end
end

function modifier_imba_ghost_shroud_aura:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit.vpcf"
end

function modifier_imba_ghost_shroud_aura:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_ghost_shroud_aura:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_imba_ghost_shroud_aura:GetAuraEntityReject(target)
	if IsServer() then
		return false
	end
end

function modifier_imba_ghost_shroud_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_ghost_shroud_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_ghost_shroud_aura:GetModifierAura()
	return "modifier_imba_ghost_shroud_buff"
end

------------------------------------------------
-- Ghost Shroud Positive Aura Buff (Heal Amp) --
------------------------------------------------

modifier_imba_ghost_shroud_buff = modifier_imba_ghost_shroud_buff or class({})

function modifier_imba_ghost_shroud_buff:IsHidden()
	if self:GetParent() == self:GetCaster() then return true end
	return false
end
function modifier_imba_ghost_shroud_buff:IsDebuff()	return false end

function modifier_imba_ghost_shroud_buff:OnCreated()
	self.healing_amp_pct = self:GetAbility():GetSpecialValueFor("healing_amp_pct")
	
	if self:GetCaster() ~= self:GetParent() then
		self.healing_amp_pct = self.healing_amp_pct * 0.5
	end
end

function modifier_imba_ghost_shroud_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	}
end

function modifier_imba_ghost_shroud_buff:GetModifierHealAmplify_PercentageTarget()
	return self.healing_amp_pct
end

function modifier_imba_ghost_shroud_buff:GetModifierHPRegenAmplify_Percentage()
	return self.healing_amp_pct
end

-- function modifier_imba_ghost_shroud_buff:Custom_AllHealAmplify_Percentage()
	-- return self.healing_amp_pct
-- end

----------------------------------------
-- Ghost Shroud Negative Aura Handler --
----------------------------------------

modifier_imba_ghost_shroud_aura_debuff = modifier_imba_ghost_shroud_aura_debuff or class({})

function modifier_imba_ghost_shroud_aura_debuff:IsHidden() return true end
function modifier_imba_ghost_shroud_aura_debuff:IsPurgable() return false end
function modifier_imba_ghost_shroud_aura_debuff:IsAura() return true end

function modifier_imba_ghost_shroud_aura_debuff:OnCreated( params )
	if IsServer() then
		self.radius = params.radius
	end
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraRadius()
	return self.radius
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_ghost_shroud_aura_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_imba_ghost_shroud_aura_debuff:GetModifierAura()
	return "modifier_imba_ghost_shroud_debuff"
end

-------------------------------------------------------
-- Ghost Shroud Negative Aura Debuff (Movement Slow) --
-------------------------------------------------------

modifier_imba_ghost_shroud_debuff = modifier_imba_ghost_shroud_debuff or class({})

function modifier_imba_ghost_shroud_debuff:IsHidden() return false end
function modifier_imba_ghost_shroud_debuff:IsDebuff() return true end

function modifier_imba_ghost_shroud_debuff:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_spirit_debuff.vpcf"
end

function modifier_imba_ghost_shroud_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_imba_ghost_shroud_debuff:GetModifierMoveSpeedBonus_Percentage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("slow_pct") * (-1)
	end
end