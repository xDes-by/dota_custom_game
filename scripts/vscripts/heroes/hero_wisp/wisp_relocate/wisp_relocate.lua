wisp_relocate_lua = class({})
LinkLuaModifier("modifier_wisp_relocate_lua", "heroes/hero_wisp/wisp_relocate/wisp_relocate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_relocate_lua_cast_delay", "heroes/hero_wisp/wisp_relocate/wisp_relocate", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_relocate_lua_talent", "heroes/hero_wisp/wisp_relocate/wisp_relocate", LUA_MODIFIER_MOTION_NONE)

function wisp_relocate_lua:GetCooldown(level)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int10")	
		if abil ~= nil then 
	return 5
	end
	return self.BaseClass.GetCooldown(self, level)
end


function wisp_relocate_lua:GetManaCost(iLevel)
    return 100+ math.min(65000, self:GetCaster():GetIntellect() /100)
end

function wisp_relocate_lua:OnSpellStart()
	if IsServer() then
		local unit 					= self:GetCursorTarget()
		local damage 				= self:GetSpecialValueFor("damage")
		local cast_delay 			= self:GetSpecialValueFor("cast_delay")
		local destroy_tree_radius	= self:GetSpecialValueFor("destroy_tree_radius")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi11")	
		if abil ~= nil then 
		damage = self:GetCaster():GetAgility() * 2
		end
			
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int6")	
		if abil ~= nil then 
		damage = damage + self:GetCaster():GetIntellect()
		end		
		
		
		local positon = unit:GetAbsOrigin()
	
		EmitSoundOn("Hero_Wisp.Relocate", self:GetCaster())


		local channel_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(channel_pfx, 0, self:GetCaster():GetAbsOrigin())

		local endpoint_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_relocate_marker_endpoint.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(endpoint_pfx, 0, positon)


		damage_type = DAMAGE_TYPE_PHYSICAL
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int11")	
		if abil ~= nil then
		damage_type = DAMAGE_TYPE_MAGICAL
		end
	

		damage_flags = DOTA_UNIT_TARGET_FLAG_NONE
		damage_type = DAMAGE_TYPE_PHYSICAL
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str11")	
		if abil ~= nil then
		damage = self:GetCaster():GetMaxHealth()
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end
		
		

		Timers:CreateTimer({
			endTime = cast_delay,
			callback = function()
				ParticleManager:DestroyParticle(channel_pfx, false)
				ParticleManager:DestroyParticle(endpoint_pfx, false)
				
				local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
					EmitSoundOn("Hero_Wisp.Spirits.Destroy", self:GetCaster())
				if #enemies > 0 then        
					for _,unit in pairs(enemies) do
						ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = damage_type, damage_flags = damage_flags })
							
					end
				end	

				local point = unit:GetAbsOrigin()
				local point_closed_zone = Entities:FindByName( nil, "closed_zone") 
				local closed_zone_point = point_closed_zone:GetAbsOrigin()
					
				local flDist = (point - closed_zone_point):Length2D()
				if flDist < 3500 then return end
				
				local point_closed_zone2 = Entities:FindByName( nil, "silent") 
				local closed_zone_point2 = point_closed_zone2:GetAbsOrigin()
					
				local flDist = (point - closed_zone_point2):Length2D()
				if flDist < 2500 then return end
				
				self:GetCaster():SetAbsOrigin( point )
				FindClearSpaceForUnit(self:GetCaster(), point, false)
				self:GetCaster():Stop() 
				PlayerResource:SetCameraTarget(self:GetCaster():GetPlayerOwnerID(), self:GetCaster())
				Timers:CreateTimer(0.1, function()
				PlayerResource:SetCameraTarget(self:GetCaster():GetPlayerOwnerID(), nil)
				
					local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self:GetCaster():GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
						EmitSoundOn("Hero_Wisp.Spirits.Destroy", self:GetCaster())
					if #enemies > 0 then        
						for _,unit in pairs(enemies) do
							ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = damage, damage_type = damage_type, damage_flags = damage_flags})
								
						end
					end	
				return nil
				end)	
				
			end
		})
	end
end

function wisp_relocate_lua:InterruptRelocate(caster, ability, tether_ability)
	if not self:GetCaster():IsAlive() or self:GetCaster():IsStunned() or self:GetCaster():IsHexed() or self:GetCaster():IsNightmared() or self:GetCaster():IsOutOfGame() or self:GetCaster():IsRooted() then
		return true
	end
	return false
end