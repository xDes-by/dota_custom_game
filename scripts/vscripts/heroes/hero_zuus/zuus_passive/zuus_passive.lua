LinkLuaModifier( "modifier_zuus_passive_lua", "heroes/hero_zuus/zuus_passive/zuus_passive.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_nimbus", "heroes/hero_zuus/zuus_passive/modifier_zuus_nimbus.lua", LUA_MODIFIER_MOTION_NONE )

zuus_passive_lua = class({})

function zuus_passive_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int11") ~= nil then 
		return self.BaseClass.GetCooldown(self, level) / 2
	end
end

function zuus_passive_lua:GetCastRange(level)
	self:GetSpecialValueFor("radius")
end

function zuus_passive_lua:GetIntrinsicModifierName()
	return "modifier_zuus_passive_lua"
end

-------------------------------------------------------------------

modifier_zuus_passive_lua = class({})

function modifier_zuus_passive_lua:IsHidden()
	return true
end

function modifier_zuus_passive_lua:RemoveOnDeath()
	return true
end

function modifier_zuus_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function modifier_zuus_passive_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "dmg_per_int" then
			return 1
		end
		if data.ability_special_value == "radius" then
			return 1
		end
	end
	return 0
end

function modifier_zuus_passive_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "dmg_per_int" then
			local dmg_per_int = self:GetAbility():GetLevelSpecialValueNoOverride( "dmg_per_int", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int12") then
                dmg_per_int = dmg_per_int + 1
            end
            return dmg_per_int
		end
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
			damage = damage + self:GetCaster():GetIntellect() * self:GetAbility():GetSpecialValueFor("dmg_per_int")
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str6") then
                damage = damage + self:GetCaster():GetStrength() * 0.5
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int13") then
                damage = damage + self:GetCaster():GetIntellect() * 1.0
            end
            return damage
		end
		if data.ability_special_value == "radius" then
			local radius = self:GetAbility():GetLevelSpecialValueNoOverride( "radius", data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str9") then
				radius = 800
			end
            return radius
		end
	end
	return 0
end

function modifier_zuus_passive_lua:OnCreated()	
	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.2)
end

function modifier_zuus_passive_lua:OnIntervalThink()
	local caster = self:GetCaster()	
	local ability = self:GetAbility()
	
	if IsServer() and caster:IsRealHero() and caster:IsAlive() and not caster:PassivesDisabled() and not caster:HasModifier("modifier_fountain_invulnerability") and ability:IsFullyCastable() then

		local radius = ability:GetSpecialValueFor("radius")
		local hEnemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		if #hEnemies > 0 then
			for _,unit in pairs(hEnemies) do
				self:ApplyDamage(unit)
			end
			self:GetAbility():UseResources(false, false,false, true)
		end
	end
end

function modifier_zuus_passive_lua:ApplyDamage(target)
	ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE})
	local zuus_static_field = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(zuus_static_field, 1, target:GetAbsOrigin() * 100)	
end

function modifier_zuus_passive_lua:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		if self:GetParent():FindAbilityByName("npc_dota_hero_zuus_str12") and params.damage_type == DAMAGE_TYPE_PHYSICAL then
			if params.attacker:IsAlive() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and RandomInt(1, 100) <= 20 then
				self:ApplyDamage(params.attacker)
			end
		end
	end
end