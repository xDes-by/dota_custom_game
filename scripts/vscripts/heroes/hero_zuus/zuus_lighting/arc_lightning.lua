LinkLuaModifier("modifier_zuus_arc_lightning_lua", "heroes/hero_zuus/zuus_lighting/arc_lightning", LUA_MODIFIER_MOTION_NONE)

zuus_arc_lightning_lua = zuus_arc_lightning_lua or class({})
modifier_zuus_arc_lightning_lua	= modifier_zuus_arc_lightning_lua or class({})



function zuus_arc_lightning_lua:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10")	
	if abil ~= nil then 
        return math.min(65000, self:GetCaster():GetIntellect()/2)
		end
        return math.min(65000, self:GetCaster():GetIntellect())
end

function zuus_arc_lightning_lua:OnSpellStart()
	if _G.arctatget == nil then
		target = self:GetCursorTarget()
	else
		target = _G.arctatget
	end
	
	self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
	
		if not target:TriggerSpellAbsorb(self) then
			local head_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
			ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
			-- No reason for this CP besides that I like colours
			ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))

			ParticleManager:ReleaseParticleIndex(head_particle)
			if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi_last") ~= nil then
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
				for _, enemy in pairs(enemies) do
					self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_lua", {starting_unit_entindex	= enemy:entindex()})
				end
			else
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_arc_lightning_lua", {starting_unit_entindex	= target:entindex()})
			end
		end
	_G.arctatget = nil
end

--------------------------------------
-- MODIFIER_zuus_arc_lightning_lua --
--------------------------------------

function modifier_zuus_arc_lightning_lua:IsHidden()		return true end
function modifier_zuus_arc_lightning_lua:IsPurgable()		return false end
function modifier_zuus_arc_lightning_lua:RemoveOnDeath()	return false end
function modifier_zuus_arc_lightning_lua:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_arc_lightning_lua:OnCreated(keys)
	if not IsServer() or not self:GetAbility() then return end

	self.arc_damage			= self:GetAbility():GetSpecialValueFor("arc_damage")
	self.radius				= self:GetAbility():GetSpecialValueFor("radius")
	self.jump_count			= self:GetAbility():GetSpecialValueFor("jump_count")
	self.jump_delay			= self:GetAbility():GetSpecialValueFor("jump_delay")
	self.static_chain_mult	= self:GetAbility():GetSpecialValueFor("static_chain_mult")
	
	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	self.units_affected			= {}
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		-- Using a previous unit and current unit variable to track n-1 and n-2 unit hit in current Arc Lightning jump, with previous unit being used for the Master of Lightning talent (can only chain if the next target is not current or previous target)
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1
		
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi11")	
				if abil ~= nil then 
				--	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					self.arc_damage = self.arc_damage + self:GetCaster():GetAgility()
				end
				
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str6")	
				if abil ~= nil then 
					self.arc_damage = self:GetCaster():GetStrength()
				end
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.arc_damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= damage_flags,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
	else
		self:Destroy()
		return
	end
	
	self.unit_counter			= 0
	
	self:StartIntervalThink(self.jump_delay)
end

function modifier_zuus_arc_lightning_lua:OnIntervalThink()
	self.zapped = false
	
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] and enemy ~= self.current_unit and enemy ~= self.previous_unit then
			enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
			
			self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(2, 0, 2))
			ParticleManager:ReleaseParticleIndex(self.lightning_particle)
		
			self.unit_counter						= self.unit_counter + 1
			self.previous_unit						= self.current_unit
			self.current_unit						= enemy
			
			if self.units_affected[self.current_unit] then
				self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
			else
				self.units_affected[self.current_unit]	= 1
			end
			
			self.zapped								= true
			
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi11")	
				if abil ~= nil then 
			--	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				self.arc_damage = self.arc_damage + self:GetCaster():GetAgility()
				end
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str6")	
				if abil ~= nil then 
				self.arc_damage = self:GetCaster():GetStrength()
				end
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.arc_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= damage_flags,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			break
		end
	end
	
	if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius * self.static_chain_mult, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
			if not self.units_affected[enemy] and enemy ~= self.current_unit and enemy ~= self.previous_unit then
				enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
				
				self.lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(2, 0, 2))
				ParticleManager:ReleaseParticleIndex(self.lightning_particle)
				
				self.unit_counter						= self.unit_counter + 1
				self.previous_unit						= self.current_unit
				self.current_unit						= enemy
				
				if self.units_affected[self.current_unit] then
					self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
				else
					self.units_affected[self.current_unit]	= 1
				end
				
				self.zapped								= true
				
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi11")	
				if abil ~= nil then 
			--	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				self.arc_damage = self.arc_damage + self:GetCaster():GetAgility()
				end
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str6")	
				if abil ~= nil then 
				self.arc_damage = self:GetCaster():GetStrength()
				end
								
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.arc_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= damage_flags,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
				
				break
			end
		end
		
		-- Check again...
		if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end