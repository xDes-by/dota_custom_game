wisp_overcharge_lua = class({})
LinkLuaModifier("modifier_wisp_overcharge_lua", "heroes/hero_wisp/wisp_overcharge/wisp_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wisp_overcharge_lua_heal", "heroes/hero_wisp/wisp_overcharge/wisp_overcharge", LUA_MODIFIER_MOTION_NONE)


function wisp_overcharge_lua:ProcsMagicStick() return false end

function wisp_overcharge_lua:GetCastRange()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str7")	
	if abil ~= nil then 
	return 35000
	end
	return 700
end

function wisp_overcharge_lua:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end

function wisp_overcharge_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() /100)
end

function wisp_overcharge_lua:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_Wisp.Overcharge", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_wisp_overcharge_lua", {})
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi9")	
			if abil ~= nil then 
			self:GetCaster():AddAbility("wisp_split"):SetLevel(1)
			end		
	else
		StopSoundEvent("Hero_Wisp.Overcharge", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_wisp_overcharge_lua")
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi9")	
			if abil ~= nil then 
			self:GetCaster():RemoveAbility("wisp_split")
			end		
	end
end


modifier_wisp_overcharge_lua = class({})

function modifier_wisp_overcharge_lua:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("interval")
		self.manacost = ability:GetSpecialValueFor("mp_loss") * self.interval
		self.radius = ability:GetSpecialValueFor("radius")
		
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_int7")	
		if abil ~= nil then 
		self.manacost = 0.1
		end			

		self.mainParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

		self:StartIntervalThink( self.interval )
	
	end
end

function modifier_wisp_overcharge_lua:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle then
			ParticleManager:DestroyParticle(self.mainParticle, false)
			ParticleManager:ReleaseParticleIndex(self.mainParticle)
		end
	end
end

function modifier_wisp_overcharge_lua:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end
	local hp_loss = self:GetAbility():GetSpecialValueFor("hp_loss") * 2
	local hAbility = self:GetAbility()
	if not self:GetCaster():IsAlive() then return end
		
		if self:GetCaster():GetMana() >= hAbility:GetManaCost(-1) then
			local current_health 	= self:GetCaster():GetHealth() 
			local health_drain 		= current_health * hp_loss *0.01
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str10")	
			if abil ~= nil then 
			health_drain = health_drain /2
			end
			
			self:GetCaster():ModifyHealth(current_health - health_drain, self:GetAbility(), true, 0)
			self:GetCaster():Script_ReduceMana(self.manacost, nil)--ReduceMana(self.manacost)
		else
			hAbility:ToggleAbility()
	end
end

function modifier_wisp_overcharge_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
end

function modifier_wisp_overcharge_lua:GetModifierIncomingDamage_Percentage()
	-- if self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str_last") ~= nil then
	-- 	return -30
	-- else
    --     return 0
	-- end
	
end
function modifier_wisp_overcharge_lua:IsAura()
	return true
end

function modifier_wisp_overcharge_lua:IsAuraActiveOnDeath()
	return false
end

function modifier_wisp_overcharge_lua:GetAuraRadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_str7")	
	if abil ~= nil then 
	return 35000
	end
	return 700
end

function modifier_wisp_overcharge_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_wisp_overcharge_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_wisp_overcharge_lua:GetModifierAura()
	return "modifier_wisp_overcharge_lua_heal"
end

function modifier_wisp_overcharge_lua:IsHidden()
	return false
end

-------------------------------------------

modifier_wisp_overcharge_lua_heal = class({})

function modifier_wisp_overcharge_lua_heal:IsDebuff() return false end
function modifier_wisp_overcharge_lua_heal:IsHidden() return false end

function modifier_wisp_overcharge_lua_heal:RemoveOnDeath() return true end

function modifier_wisp_overcharge_lua_heal:OnCreated()
	self.heal					= self:GetAbility():GetSpecialValueFor("hp_ampl")
	self.bonus_attack_speed		= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed		= self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_wisp_agi11")	
	if abil ~= nil then 
	self.bonus_attack_speed = self.bonus_attack_speed * 2
	end	
end

function modifier_wisp_overcharge_lua_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_wisp_overcharge_lua_heal:GetModifierHealthRegenPercentage()
	return self.heal
end

function modifier_wisp_overcharge_lua_heal:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_wisp_overcharge_lua_heal:GetModifierMoveSpeedBonus_Constant()
return self.bonus_move_speed
end
