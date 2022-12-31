abaddon_borrowed_time_lua = class({})
LinkLuaModifier("modifier_abaddon_borrowed_time_lua", "heroes/hero_abaddon/modifier_abaddon_borrowed_time_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_abaddon_borrowed_time_absorbtion", "heroes/hero_abaddon/modifier_abaddon_borrowed_time_absorbtion", LUA_MODIFIER_MOTION_NONE)

function abaddon_borrowed_time_lua:GetIntrinsicModifierName()
	return "modifier_abaddon_borrowed_time_lua"
end

function abaddon_borrowed_time_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_abaddon_5")
end

function abaddon_borrowed_time_lua:OnSpellStart()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local duration
	if caster:HasScepter() then
		duration = self:GetSpecialValueFor("duration_scepter")
	else
		duration = self:GetSpecialValueFor("duration")
	end
	caster:AddNewModifier(caster, self, "modifier_abaddon_borrowed_time_absorbtion", {duration=duration})
end

function abaddon_borrowed_time_lua:FireHealingProjectile(target)
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local coil_ability = caster:FindAbilityByName("abaddon_death_coil")
	if not coil_ability or coil_ability:IsNull() or coil_ability:GetLevel() <= 0 then return end

	-- since valve loves changing ability specials names, providing default values is a good idea
	local coil_movespeed = coil_ability:GetSpecialValueFor("missile_speed") or 1300
	local coil_heal 	 = coil_ability:GetSpecialValueFor("heal_amount") or 255

	self.base_projecetile_info.Target = target
	self.base_projecetile_info.iMoveSpeed = coil_movespeed
	self.base_projecetile_info.ExtraData = {heal = coil_heal}

	ProjectileManager:CreateTrackingProjectile( self.base_projecetile_info )
end

function abaddon_borrowed_time_lua:OnProjectileHit_ExtraData(target, location, extra_data)
	if not IsServer() then return end
	if not target or target:IsNull() then return end

	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	target:Heal(extra_data.heal, caster)
	target:EmitSound("Hero_Abaddon.DeathCoil.Target")
end

function abaddon_borrowed_time_lua:OnUpgrade()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local modifier = caster:FindModifierByName("modifier_abaddon_borrowed_time_lua")
	if not modifier then return end

	modifier:Init()

	self.base_projecetile_info = {
		Source = caster,
		Ability = self,
		EffectName = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf",
		bDodgeable = false,
		bProvidesVision = false,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	}
end
