LinkLuaModifier("modifier_zuus_arc_lightning_lua", "heroes/hero_zuus/zuus_lighting/arc_lightning", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_lightning_intrinsic", "heroes/hero_zuus/zuus_lighting/modifier_arc_lightning_intrinsic", LUA_MODIFIER_MOTION_NONE)

zuus_arc_lightning_lua = zuus_arc_lightning_lua or class({})
modifier_zuus_arc_lightning_lua	= modifier_zuus_arc_lightning_lua or class({})

function zuus_arc_lightning_lua:GetIntrinsicModifierName()
	return "modifier_arc_lightning_intrinsic"
end

function zuus_arc_lightning_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi6") then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
end

function zuus_arc_lightning_lua:GetManaCost(iLevel)
	local caster = self:GetCaster()
	local mana_cost = 50 + math.min(65000, caster:GetIntellect()/200)
	if caster:FindAbilityByName("npc_dota_hero_zuus_agi9") then
		if IsClient() then return 0 end
		local as = caster:GetDisplayAttackSpeed()
		local perc = (100-as/18)/100
		mana_cost = mana_cost * perc
	end
	return mana_cost
end

function zuus_arc_lightning_lua:GetCooldown(level)
	local caster = self:GetCaster()
	local cooldown = self.BaseClass.GetCooldown( self, level )
	if caster:FindAbilityByName("npc_dota_hero_zuus_agi9") then
		if IsClient() then return 0 end
		local as = caster:GetDisplayAttackSpeed()
		local perc = (100-as/18)/100
		cooldown = cooldown * perc
	end
    return cooldown
end

function zuus_arc_lightning_lua:OnSpellStart()
	if _G.arctatget == nil then
		target = self:GetCursorTarget()
	else
		target = _G.arctatget
	end
	
	self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
	
	if not target:TriggerSpellAbsorb(self) then
		local head_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(head_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(head_particle, 62, Vector(2, 0, 2))
		
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

modifier_zuus_arc_lightning_lua = class({})

function modifier_zuus_arc_lightning_lua:IsHidden() return true end
function modifier_zuus_arc_lightning_lua:IsPurgable() return false end
function modifier_zuus_arc_lightning_lua:RemoveOnDeath() return false end
function modifier_zuus_arc_lightning_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_zuus_arc_lightning_lua:OnCreated(keys)
	self.static_damage		= self:GetAbility():GetSpecialValueFor("arc_damage")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("radius")
	self.static_strikes		= self:GetAbility():GetSpecialValueFor("jump_count") - 1
	self.jump_delay			= self:GetAbility():GetSpecialValueFor("jump_delay")

	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	self.units_affected = {}
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit = EntIndexToHScript(self.starting_unit_entindex)
		self.units_affected[self.current_unit]	= 1
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi11") ~= nil then 
			self.static_damage = self:GetCaster():GetAgility()
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str6") ~= nil then 
			self.static_damage = self:GetCaster():GetStrength()
		end
		
		ApplyDamage({
			victim 			= self.current_unit,
			damage 			= self.static_damage,
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
		})
	else
		self:Destroy()
		return
	end
	
	self.unit_counter = 0
	
	self:StartIntervalThink(self.jump_delay)
end

function modifier_zuus_arc_lightning_lua:OnIntervalThink()
	self.zapped = false
	
	if (self.unit_counter >= self.static_strikes and self.static_strikes > 0) or not self.zapped then

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
			if not self.units_affected[enemy] and enemy ~= self.current_unit and enemy ~= self.previous_unit then
				enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
				
				self.lightning_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(self.lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(self.lightning_particle, 62, Vector(2, 0, 2))
				ParticleManager:ReleaseParticleIndex(self.lightning_particle)
				
				self.unit_counter = self.unit_counter + 1
				self.previous_unit = self.current_unit
				self.current_unit = enemy
				
				if self.units_affected[self.current_unit] then
					self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
				else
					self.units_affected[self.current_unit]	= 1
				end
				
				self.zapped = true
			
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.static_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
				})
				break
			end
		end
		
		if (self.unit_counter >= self.static_strikes and self.static_strikes > 0) or not self.zapped then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
	end
end