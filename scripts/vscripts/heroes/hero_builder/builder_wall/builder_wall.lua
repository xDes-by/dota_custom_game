LinkLuaModifier( "modifier_blade_mail", "heroes/hero_builder/modifier_blade_mail", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dispersion_lua", "heroes/hero_builder/builder_wall/builder_wall", LUA_MODIFIER_MOTION_NONE )
function build(data)
	local caster = data.caster
	local ability = data.ability
	
	local sound_cast = "DOTA_Item.RepairKit.Target"
	EmitSoundOn( sound_cast, caster )
	local position = caster:GetCursorPosition()
	dummy_unit_wall = CreateUnitByName("npc_wall", position, true, caster, nil, caster:GetTeam())
	
	dummy_unit_wall:SetControllableByPlayer(caster:GetPlayerID(), true)
	dummy_unit_wall:SetOwner(caster)
	local hp_mnoz = ability:GetLevelSpecialValueFor( "hp", ability:GetLevel() - 1 )
	hero_health = caster:GetMaxHealth()	* (hp_mnoz / 100)
	
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_str6")
		if abil ~= nil then
		hero_health = hero_health * 2
		end
	
	local max_hp = dummy_unit_wall:GetMaxHealth()
	dummy_unit_wall:SetBaseMaxHealth(max_hp + (hero_health- 100))
	dummy_unit_wall:SetMaxHealth(max_hp + (hero_health- 100))
	dummy_unit_wall:SetHealth(max_hp + (hero_health- 100))
	
		local armor = ability:GetLevelSpecialValueFor( "armor", ability:GetLevel() - 1 )
	
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_str9")
		if abil ~= nil then
		armor = armor * 2
		end
	
	local hero_armor = caster:GetPhysicalArmorBaseValue() * 0.01
	
	dummy_unit_wall:SetPhysicalArmorBaseValue(hero_armor * armor)	
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_int6")
	if abil ~= nil then
	dummy_unit_wall:AddNewModifier(caster,ability,"modifier_magic_immune",{}	)
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_str11")
	if abil ~= nil then
		dummy_unit_wall:AddNewModifier(caster,ability,"modifier_blade_mail",{}	)
	end
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_tinker_str50") then
		dummy_unit_wall:AddNewModifier(caster, ability, "modifier_dispersion_lua", {})
	end
	dummy_unit_wall:SetModelScale(0.01)	
	if dummy_unit_wall ~= nil then
	 Timers:CreateTimer(0.03, function()
			if dummy_unit_wall:GetModelScale() < 1.2 then
			dummy_unit_wall:SetModelScale(dummy_unit_wall:GetModelScale()  + 0.015)	
	   return 0.03
	   end
	   if dummy_unit_wall:GetModelScale() >= 1.2 then 
	   end
    end)	
	end
end

function sbit(data)
	local caster = data.caster
		dummy_unit_wall:SetModel("models/development/invisiblebox.vmdl")
	   dummy_unit_wall:ForceKill(false)
		caster:StopSound("DOTA_Item.RepairKit.Target")
end

modifier_dispersion_lua = class({})

function modifier_dispersion_lua:IsHidden()
	return true
end

function modifier_dispersion_lua:IsPurgable() 			
	return false 
end

function modifier_dispersion_lua:RemoveOnDeath() 	
	return false 
end

function modifier_dispersion_lua:DeclareFunctions()
    return {
	MODIFIER_EVENT_ON_TAKEDAMAGE, 
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_dispersion_lua:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
		local damageTable = {
			victim = params.attacker,
			attacker = self:GetCaster(),
			damage = params.damage * 0.125,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self:GetAbility(),
		}
		ApplyDamage(damageTable)
	end
end

function modifier_dispersion_lua:GetModifierIncomingDamage_Percentage()
	return -12.5
end

