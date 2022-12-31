crystal_maiden_brilliance_aura_lua = class({})
LinkLuaModifier('modifier_crystal_maiden_brilliance_aura_lua_global_aura', 'heroes/hero_crystal_maiden/crystal_maiden_brilliance_aura_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_crystal_maiden_brilliance_aura_lua_small_aura', 'heroes/hero_crystal_maiden/crystal_maiden_brilliance_aura_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier('modifier_crystal_maiden_brilliance_aura_lua_buff', 'heroes/hero_crystal_maiden/crystal_maiden_brilliance_aura_lua.lua', LUA_MODIFIER_MOTION_NONE)


function crystal_maiden_brilliance_aura_lua:GetIntrinsicModifierName()
	return 'modifier_crystal_maiden_brilliance_aura_lua_global_aura'
end


modifier_crystal_maiden_brilliance_aura_lua_global_aura = class({})

function modifier_crystal_maiden_brilliance_aura_lua_global_aura:OnCreated()
	if not IsServer() then return end
	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end

	self.parent:AddNewModifier(self.parent, self.ability, "modifier_crystal_maiden_brilliance_aura_lua_small_aura", {})
end

function modifier_crystal_maiden_brilliance_aura_lua_global_aura:OnRefresh()
	self:OnCreated()
end

function modifier_crystal_maiden_brilliance_aura_lua_global_aura:OnDestroy()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end

	local aura = self.parent:FindModifierByName("modifier_crystal_maiden_brilliance_aura_lua_small_aura")
	if aura then
		aura:Destroy()
	end
end

function modifier_crystal_maiden_brilliance_aura_lua_global_aura:IsAura()
	if not IsServer() then return end

	--the tempest double is not the aura provider because it messes up the retraining giving you a free global aura
	--instead we check for it later in giving stats
	if self.parent:IsIllusion() or self.parent:IsTempestDouble() then 
		return false 
	end

	-- Arcane Aura is not emitted when the caster's passives are disabled
	if self.parent:PassivesDisabled() then return false end

	return true 
end

function modifier_crystal_maiden_brilliance_aura_lua_global_aura:IsHidden() return true end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:IsDebuff() return false end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:IsPurgable() return false end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:RemoveOnDeath() return true end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:GetModifierAura() return "modifier_crystal_maiden_brilliance_aura_lua_buff" end
function modifier_crystal_maiden_brilliance_aura_lua_global_aura:GetAuraRadius() return -1 end


modifier_crystal_maiden_brilliance_aura_lua_buff = class({})

function modifier_crystal_maiden_brilliance_aura_lua_buff:IsHidden() return false end
function modifier_crystal_maiden_brilliance_aura_lua_buff:IsDebuff() return false end
function modifier_crystal_maiden_brilliance_aura_lua_buff:IsPurgable() return false end
function modifier_crystal_maiden_brilliance_aura_lua_buff:GetTexture() return "crystal_maiden_brilliance_aura" end

function modifier_crystal_maiden_brilliance_aura_lua_buff:OnCreated()			
	self:StartIntervalThink(0.1)
end

function modifier_crystal_maiden_brilliance_aura_lua_buff:OnRefresh()
	self:OnCreated()
end

function modifier_crystal_maiden_brilliance_aura_lua_buff:OnIntervalThink()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if not self.caster or self.caster:IsNull() then return end
	if not self.parent or self.parent:IsNull() then return end
	if not self.ability or self.ability:IsNull() then return end

	self.multiplier = 1
	local proximity_bonus_radius = self.ability:GetSpecialValueFor("proximity_bonus_radius")
	local distance = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()

	--this makes sure that the main hero gets the multiplier and any-non illusions units that are identical to the hero, (mainly a Tempest Double)
	if self.caster == self.parent or (not self.parent:IsIllusion() and self.caster:GetUnitName() == self.parent:GetUnitName()) then
		self.multiplier = self.ability:GetSpecialValueFor("self_multiplier") or 1
	elseif distance < proximity_bonus_radius then
		self.multiplier = self.ability:GetSpecialValueFor("proximity_bonus_factor") or 2
	end

	self.spell_amplify = self.ability:GetSpecialValueFor("aura_spell_amp") * self.multiplier
	self.mana_regen = self.ability:GetSpecialValueFor("aura_mana_regen") * self.multiplier
end

function modifier_crystal_maiden_brilliance_aura_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_crystal_maiden_brilliance_aura_lua_buff:GetModifierConstantManaRegen()
	if self.caster and not self.caster:IsNull() and not self.caster:PassivesDisabled() then
		return self.mana_regen
	end 
end

function modifier_crystal_maiden_brilliance_aura_lua_buff:GetModifierSpellAmplify_Percentage()
	if self.caster and not self.caster:IsNull() and not self.caster:PassivesDisabled() then
		local int = self.caster:GetIntellect() or 0
		return self.spell_amplify * int
	end
end