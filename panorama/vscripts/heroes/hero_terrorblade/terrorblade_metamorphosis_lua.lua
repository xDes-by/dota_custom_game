---@class terrorblade_metamorphosis_lua:CDOTA_Ability_Lua
terrorblade_metamorphosis_lua = class({})

LinkLuaModifier("modifier_terrorblade_metamorphosis_lua", "heroes/hero_terrorblade/terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_metamorphosis_lua_transform", "heroes/hero_terrorblade/terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_terrorblade_metamorphosis_lua_passive", "heroes/hero_terrorblade/terrorblade_metamorphosis_lua", LUA_MODIFIER_MOTION_NONE)

function terrorblade_metamorphosis_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_unique_terrorblade_3")	-- +20s meta duration, does not affect scepter
	caster:AddNewModifier(caster, self, "modifier_terrorblade_metamorphosis_lua", { duration = duration } )
	self:ApplyToIllusions()
end

function terrorblade_metamorphosis_lua:GetIntrinsicModifierName()
	return "modifier_terrorblade_metamorphosis_lua_passive"
end

function terrorblade_metamorphosis_lua:ApplyToIllusions()
	local caster = self:GetCaster()

	local modifier = caster:FindModifierByName("modifier_terrorblade_metamorphosis_lua")
	if not modifier then return end

	local duration = modifier:GetRemainingTime()

	local illusions = Entities:FindAllByClassname(caster:GetClassname()) ---@type CDOTA_BaseNPC[]
	for _,unit in pairs(illusions) do
		local modifier_illusion = unit:FindModifierByName("modifier_illusion")
		if modifier_illusion and modifier_illusion:GetCaster() == caster then
			unit:AddNewModifier(caster, self, "modifier_terrorblade_metamorphosis_lua", {duration = duration})
		end
	end
end


--This modifier implements Metamorphosis after Terror Wave cast
---@class modifier_terrorblade_metamorphosis_lua_passive:CDOTA_Modifier_Lua
modifier_terrorblade_metamorphosis_lua_passive = class({})
function modifier_terrorblade_metamorphosis_lua_passive:IsHidden() return true end
function modifier_terrorblade_metamorphosis_lua_passive:IsPurgable() return false end
function modifier_terrorblade_metamorphosis_lua_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_terrorblade_metamorphosis_lua_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}
end

function modifier_terrorblade_metamorphosis_lua_passive:OnAbilityFullyCast(event) 
	local parent = self:GetParent()
	local cast_ability = event.ability
	
	local ability = self:GetAbility()
	if not ability then return end

	if parent == event.unit and ability:IsTrained() and cast_ability and cast_ability:GetAbilityName() == "terrorblade_terror_wave" then
		local duration = cast_ability:GetSpecialValueFor("scepter_meta_duration")
		local modifier = parent:FindModifierByName("modifier_terrorblade_metamorphosis_lua")

		if modifier then
			modifier:SetDuration(modifier:GetRemainingTime() + duration, true)
		else 
			parent:AddNewModifier(parent, ability, "modifier_terrorblade_metamorphosis_lua", {duration = duration})
		end

		ability:ApplyToIllusions()
	end
end


---@class modifier_terrorblade_metamorphosis_lua:CDOTA_Modifier_Lua
modifier_terrorblade_metamorphosis_lua = class({})

function modifier_terrorblade_metamorphosis_lua:IsPurgable() return false end
function modifier_terrorblade_metamorphosis_lua:AllowIllusionDuplicate() return true end

function modifier_terrorblade_metamorphosis_lua:OnCreated()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	
	if not self.already_transformed then
		local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(transform_particle)
		if IsServer() then
			parent:EmitSound("Hero_Terrorblade.Metamorphosis")
			parent:AddNewModifier(self:GetCaster(), ability, "modifier_terrorblade_metamorphosis_lua_transform", {duration = ability:GetSpecialValueFor("transformation_time")})
		end
	end

	self.already_transformed = true
	self.base_attack_time = ability:GetSpecialValueFor("base_attack_time")
	self.bonus_range = ability:GetSpecialValueFor("bonus_range")
	self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")

	if IsServer() then
		-- Should there ever be multiple casts of this ability,
		-- The logical operators make sure that these variables dont override default values
		self.original_projectile = self.original_projectile or parent:GetRangedProjectileName()
		self.projectile_base = self.projectile_base or GetUnitKV(parent:GetUnitName(), "ProjectileSpeed")

		if not self.projectile_base then
			self.projectile_base = 900
		end

		parent:SetAttackCapability( DOTA_UNIT_CAP_RANGED_ATTACK )
		parent:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")

		--Adjust modifier duration to corresponding modifier of illusion owner
		if parent:IsIllusion() then
			local caster = ability:GetCaster()
			local modifier = caster:FindModifierByName("modifier_terrorblade_metamorphosis_lua")

			if not modifier then 
				self:Destroy()
				return 
			end

			self:SetDuration(modifier:GetRemainingTime(), true)
		end
	end
end

function modifier_terrorblade_metamorphosis_lua:OnRefresh()
	self:OnCreated()
end

function modifier_terrorblade_metamorphosis_lua:OnRemoved()
	if IsServer() then
		local parent = self:GetParent()
		if parent.original_attack_capability then
			parent:SetAttackCapability( parent.original_attack_capability )
			parent:SetRangedProjectileName( self.original_projectile )
		end
	end
end

function modifier_terrorblade_metamorphosis_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
end


function modifier_terrorblade_metamorphosis_lua:GetModifierBaseAttackTimeConstant()
	-- This sets base attack time to the returned time
	-- e.g. returning 1.0 makes unit BAT 1.0
	return self.base_attack_time
end

function modifier_terrorblade_metamorphosis_lua:GetModifierAttackRangeBonus()
	return self.bonus_range
end

function modifier_terrorblade_metamorphosis_lua:GetModifierBaseAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_terrorblade_metamorphosis_lua:GetModifierModelChange()
	return "models/heroes/terrorblade/demon.vmdl"
end

function modifier_terrorblade_metamorphosis_lua:GetModifierProjectileSpeedBonus()
	if IsClient() then return end

	if not self.projectile_base then
		return 0
	end
	
	return 900 - self.projectile_base
end

modifier_terrorblade_metamorphosis_lua_transform = class({})
function modifier_terrorblade_metamorphosis_lua_transform:IsHidden() return true end
function modifier_terrorblade_metamorphosis_lua_transform:IsDebuff() return false end
function modifier_terrorblade_metamorphosis_lua_transform:IsPurgable() return false end
function modifier_terrorblade_metamorphosis_lua_transform:IsPurgeException() return false end

function modifier_terrorblade_metamorphosis_lua_transform:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_terrorblade_metamorphosis_lua_transform:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_terrorblade_metamorphosis_lua_transform:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_3
end
