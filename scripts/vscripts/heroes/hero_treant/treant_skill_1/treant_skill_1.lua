LinkLuaModifier("modifier_frostivus_leech_seed_debuff", "heroes/hero_treant/treant_skill_1/treant_skill_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_generic_disarm", "heroes/generic/modifier_generic_disarm", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier("modifier_treant_skill_1_creation_thinker", "heroes/hero_treant/treant_skill_1/treant_skill_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_skill_1_damage", "heroes/hero_treant/treant_skill_1/treant_skill_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_treant_skill_1_auto", "heroes/hero_treant/treant_skill_1/treant_skill_1", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------------------------------------

treant_skill_1 = class({})

function treant_skill_1:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() /100)
end

function treant_skill_1:GetIntrinsicModifierName()
	return "modifier_treant_skill_1_auto"
end

function treant_skill_1:OnSpellStart()
	local cast_position		= self:GetCaster():GetAbsOrigin()
	local cursor_position	= self:GetCursorPosition()
	local unique_string		= DoUniqueString(self:GetName())
	local thicket_thinker	= nil
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int9")	
	if abil ~= nil then 
		if RandomInt(1,100) < 10 then
			self:EndCooldown()
		end
	end
	
	if cursor_position == Vector(0,0,0) then
		cursor_position = self:GetCaster():GetOrigin() + self:GetCaster():GetForwardVector():Normalized() * 100
	end
	
	if not self.thinker_tracker then
		self.thinker_tracker = {}
	end
	
	self:GetCaster():EmitSound("Hero_Treant.NaturesGrasp.Cast")
	
	for thicket = 1, math.floor((self:GetCastRange(cursor_position, self:GetCaster()) - 100) / 105) do
		self:GetCaster():SetContextThink(DoUniqueString("grasp_thinker"), function()
			thicket_thinker = CreateModifierThinker(self:GetCaster(), self, "modifier_treant_skill_1_creation_thinker", {
				duration = self:GetSpecialValueFor("duration"),
				unique_string = unique_string
			}, GetGroundPosition(cast_position + (cursor_position - cast_position):Normalized() * (100 + (175 * (thicket - 1))), nil), self:GetCaster():GetTeamNumber(), false)
			
			thicket_thinker:EmitSound("Hero_Treant.NaturesGrasp.Spawn")
			
			if thicket == math.floor((self:GetCastRange(cursor_position, self:GetCaster()) - 100) / 175) then
				self.thinker_tracker[unique_string] = nil
			end
			
			return nil
		end, 0.1 * (thicket - 1))
	end
end


---------------------------------------------------------

modifier_treant_skill_1_auto = class({})

function modifier_treant_skill_1_auto:IsHidden()
	return true
end

function modifier_treant_skill_1_auto:IsPurgable()
	return false
end

function modifier_treant_skill_1_auto:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_treant_skill_1_auto:GetModifierProcAttack_Feedback(keys)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi_last") ~= nil then
		if keys.attacker == self:GetParent() and not keys.target:IsBuilding() and RandomInt(1, 100) < 10 then
			if not keys.attacker:IsIllusion() then
				if keys.attacker:GetMana() >= self:GetAbility():GetManaCost() then
					local position =  keys.target:GetAbsOrigin()
					self:GetAbility():OnSpellStart()
					self:GetAbility():SetChanneling(true)
					self:GetAbility():EndChannel(true)
					self:GetAbility():UseResources(true, false, false, false)
				end
			end
		end
	end
end

---------------------------------------------------------

modifier_treant_skill_1_creation_thinker = class({})

function modifier_treant_skill_1_creation_thinker:IsHidden()
	return true
end

function modifier_treant_skill_1_creation_thinker:IsPurgable()
	return false
end

function modifier_treant_skill_1_creation_thinker:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end

	if not IsServer() then return end
	
	self.latch_range	= self:GetAbility():GetSpecialValueFor("latch_range")
	self.damage_per_second	= self:GetAbility():GetSpecialValueFor("damage_per_second")
	self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
	
	self.damage_type	= self:GetAbility():GetAbilityDamageType()

	
	self.unique_string	= keys.unique_string
	
	self.bramble_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_bramble_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.bramble_particle, 0, Vector(0, 0, 0))
	self:AddParticle(self.bramble_particle, false, false, -1, false, false)
	
	if not self:GetAbility().thinker_tracker[self.unique_string] and GridNav:IsNearbyTree(self:GetParent():GetAbsOrigin(), self.latch_range, false) then
		self:GetAbility().thinker_tracker[self.unique_string] = true
		
		self.bTouchingTree = true
		
		for _, ent in pairs(Entities:FindAllByName("npc_dota_thinker")) do
			if ent:HasModifier(self:GetName()) and ent:FindModifierByName(self:GetName()).unique_string == self.unique_string and ent:FindModifierByName(self:GetName()).bramble_particle then
				ParticleManager:SetParticleControl(ent:FindModifierByName(self:GetName()).bramble_particle, 1, Vector(1, 0, 0))
				ent:FindModifierByName(self:GetName()).bTouchingTree = true
			end
		end
		
		ParticleManager:SetParticleControl(self.bramble_particle, 1, Vector(1, 0, 0))
	end
end

function modifier_treant_skill_1_creation_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():EmitSound("Hero_Treant.NaturesGrasp.Destroy")
end

function modifier_treant_skill_1_creation_thinker:IsAura()
	return true
end

function modifier_treant_skill_1_creation_thinker:IsAuraActiveOnDeath()
	return false
end

function modifier_treant_skill_1_creation_thinker:GetAuraRadius()
	return self.latch_range
end

function modifier_treant_skill_1_creation_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_treant_skill_1_creation_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_treant_skill_1_creation_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

function modifier_treant_skill_1_creation_thinker:GetModifierAura()
	return "modifier_treant_skill_1_damage"
end

-----------------------------------------------

modifier_treant_skill_1_damage = class({})

function modifier_treant_skill_1_damage:OnCreated()
	if not IsServer() then return end
	
	if self:GetAbility() then
		self.damage_per_second	= self:GetAbility():GetSpecialValueFor("damage_per_second")
		self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow")
		self.damage_type	= self:GetAbility():GetAbilityDamageType()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_int6")	
	if abil ~= nil then 
		self.damage_per_second = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_agi7")	
	if abil ~= nil then 
		self.damage_per_second = self:GetCaster():GetAttackDamage()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_treant_str11")	
	if abil ~= nil then 
		self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_generic_disarm", {duration = 3})
	end
	
	
	self.interval = 0.25
	self.damage_per_tick = self.damage_per_second * self.interval
	
	self:SetStackCount(self.movement_slow * (-1))
	
	self:GetParent():EmitSound("Hero_Treant.NaturesGrasp.Damage")
	


	self:StartIntervalThink(self.interval)
end

function modifier_treant_skill_1_damage:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage_per_tick,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

function modifier_treant_skill_1_damage:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_treant_skill_1_damage:GetModifierMoveSpeedBonus_Percentage()
	if not self:GetParent():IsMagicImmune() then
		return self:GetStackCount()
	end
end