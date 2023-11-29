LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_dummy_ability", "abilities/dummy", LUA_MODIFIER_MOTION_NONE)

lina_stun = class({})

function lina_stun:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int7") ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function lina_stun:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	if target then
		point = target:GetOrigin()
	end
	
	local particle = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local direction = (point - caster_pos):Normalized()
	local distance =self:GetSpecialValueFor("distance")
	local points = self:GetSpecialValueFor("points")
	local radius = self:GetSpecialValueFor("radius")
	local delay = self:GetSpecialValueFor("delay")
	local damage = self:GetSpecialValueFor("damage")
	local duration = self:GetSpecialValueFor("duration")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_str8")	
	if abil ~= nil then 
		duration = duration + 3 
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int6")	
	if abil ~= nil then 
		points = points + 3 
	end
	
	local spacing = distance / points
	local range = 0
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int11")	
	if abil ~= nil then 
	damage = damage + self:GetCaster():GetIntellect()/2
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_int50")	
	if abil ~= nil then 
		damage = damage + self:GetCaster():GetIntellect() * 0.5
	end
	local dummies = {}
	-- destroyunits = false
	Timers:CreateTimer(function()
			range = range + spacing
			point_loc = caster_pos + direction * range
			local dummy = CreateUnitByName("npc_dummy_unit", point_loc, false, caster, caster, caster:GetTeamNumber())
			table.insert( dummies, dummy )
			dummy:AddNewModifier(nil,nil,"modifier_dummy_ability",{})
			EmitSoundOn("Ability.PreLightStrikeArray", dummy)
			local particleIndex = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, dummy)
			local units = FindUnitsInRadius(caster:GetTeam(), point_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
			for k, unit in ipairs(units) do
				
					local damageTable = {
					victim = unit,
					attacker = self:GetCaster(),
					damage = damage,
					damage_type = self:GetAbilityDamageType(),
					ability = self, --Optional.
				}
				ApplyDamage( damageTable )
				
				unit:AddNewModifier(
				unit, -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = duration } -- kv
			)
		
			end
			points = points - 1
			if points > 0 then
				return delay
			-- elseif not destroyunits then
				-- destroyunits = true
				-- return 3
			else
				for _,unit in ipairs(dummies) do
					UTIL_Remove(unit)
				end
			end
		end
	)
end












