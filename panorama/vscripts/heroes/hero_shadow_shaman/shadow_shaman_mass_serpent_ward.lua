---@class shadow_shaman_mass_serpent_ward_lua:CDOTA_Ability_Lua
shadow_shaman_mass_serpent_ward_lua = class({})
LinkLuaModifier("modifier_shadow_shaman_serpent_ward_chc", "heroes/hero_shadow_shaman/modifier_shadow_shaman_serpent_ward_chc", LUA_MODIFIER_MOTION_NONE)

function shadow_shaman_mass_serpent_ward_lua:GetAOERadius()
	return 150
end

function shadow_shaman_mass_serpent_ward_lua:OnSpellStart()
	local caster            =   self:GetCaster()
	local target_point      =   self:GetCursorPosition()
	local ward_level        =   self:GetLevel()

	local ward_name         =   "npc_dota_shadow_shaman_ward_" 
	local spawn_particle    =   "particles/units/heroes/hero_shadowshaman/shadowshaman_ward_spawn.vpcf"

	--local ward_count    =   self:GetSpecialValueFor("ward_count")
	local ward_duration =   self:GetSpecialValueFor("duration")
	
	caster:EmitSound("Hero_ShadowShaman.SerpentWard")

	local spawn_particle_fx = ParticleManager:CreateParticle(spawn_particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( spawn_particle_fx, 0, target_point )

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end
	
	local ward = self:SummonWard(target_point, multicast)

	ResolveNPCPositions(ward:GetAbsOrigin(), 64)
end

function shadow_shaman_mass_serpent_ward_lua:SummonWard(position, multicast_factor)
	local caster = self:GetCaster()
	local new_hp = self:GetSpecialValueFor("hits_to_destroy_tooltip") + caster:FindTalentValue("special_bonus_custom_shadow_shaman_1", "value2")
	local duration	= self:GetSpecialValueFor("duration")

	local unit_name = "npc_dota_shadow_shaman_ward_"..self:GetLevel()
	
	local ward = CreateUnitByName(unit_name, position, true, caster, caster, caster:GetTeamNumber())
	ward:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	ward:SetForwardVector(caster:GetForwardVector())
	
	ward:SetBaseMaxHealth(new_hp)
	
	ward:SetBaseDamageMin(self:GetSpecialValueFor("damage_tooltip") + caster:FindTalentValue("special_bonus_custom_shadow_shaman_4", "value2"))
	ward:SetBaseDamageMax(self:GetSpecialValueFor("damage_tooltip") + caster:FindTalentValue("special_bonus_custom_shadow_shaman_4", "value2"))

	ward:SetBaseMaxHealth(ward:GetBaseMaxHealth() * multicast_factor)
	ward:SetBaseDamageMin(ward:GetBaseDamageMin() * multicast_factor)
	ward:SetBaseDamageMax(ward:GetBaseDamageMax() * multicast_factor)

	ward:SetHealth(ward:GetMaxHealth())

	ward:AddAbility("summon_buff")
	ward:AddNewModifier(caster, self, "modifier_shadow_shaman_serpent_ward_chc", {duration = duration, ward_count = 10})

	--unit.multicast_multiplier = multicast_factor

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	if multicast_factor > 1 and multicast_modifier then
		multicast_modifier:PlaySummonFX(ward, multicast_factor)
	end

	return ward
end