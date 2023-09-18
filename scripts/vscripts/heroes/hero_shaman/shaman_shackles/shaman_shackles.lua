LinkLuaModifier("modifier_shaman_shackles_handler",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shaman_shackles_target_handler",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shaman_shackles",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shaman_shackles_chariot",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shakle_resist",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shakle_armor",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shakle_damage",  "heroes/hero_shaman/shaman_shackles/shaman_shackles", LUA_MODIFIER_MOTION_NONE)

shaman_shackles								= class({})
modifier_shaman_shackles_handler			= class({})
modifier_shaman_shackles_target_handler		= class({})
modifier_shaman_shackles					= class({})
modifier_shaman_shackles_chariot			= class({})

function shaman_shackles:GetManaCost(iLevel)          
	if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int7")  ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end


function shaman_shackles:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function shaman_shackles:GetIntrinsicModifierName()
	return "modifier_shaman_shackles_handler"
end

function shaman_shackles:CastFilterResultTarget(target)
	if not self:GetCaster():HasModifier("modifier_shaman_shackles_target_handler") or target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() or target == self:GetCaster() then
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	else
		-- IMBAfication: Chariot
		return UF_SUCCESS
	end
end

function shaman_shackles:GetChannelTime()
	return self:GetCaster():GetModifierStackCount("modifier_shaman_shackles_handler", self:GetCaster()) * 0.01
end

function shaman_shackles:OnSpellStart()
	local target = self:GetCursorTarget()
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str8")             
	if abil ~= nil then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_magic_immune", {duration = self:GetChannelTime()})
	end
	

	if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		if not target:TriggerSpellAbsorb(self) then
			self:GetCaster():EmitSound("Hero_ShadowShaman.Shackles.Cast")
			
			if self:GetCaster():GetName() == "npc_dota_hero_shadow_shaman" and RollPercentage(75) then
				local responses = {
					"shadowshaman_shad_ability_shackle_01",
					"shadowshaman_shad_ability_shackle_02",
					"shadowshaman_shad_ability_shackle_03",
					"shadowshaman_shad_ability_shackle_04",
					"shadowshaman_shad_ability_shackle_05",
					"shadowshaman_shad_ability_shackle_06",
					"shadowshaman_shad_ability_shackle_08",
					"shadowshaman_shad_ability_entrap_02",
					"shadowshaman_shad_ability_entrap_03",
				}
				
				self:GetCaster():EmitSound(responses[RandomInt(1, #responses)])
			end
			
			-- IMBAfication: Stronghold
			local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("stronghold_width"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS)
			
			for _, enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_shaman_shackles", {duration = self:GetChannelTime()})
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int11")             
				if abil ~= nil then 
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_shakle_resist", {duration = self:GetChannelTime()})
				end

				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_agi8")             
				if abil ~= nil then 
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_shakle_armor", {duration = self:GetChannelTime()})
				end
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str11")             
				if abil ~= nil then 
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_shakle_damage", {duration = self:GetChannelTime()})
				end
		
			end
		else
			self:GetCaster():Interrupt()
		end
	else
		target:AddNewModifier(self:GetCaster(), self, "modifier_shaman_shackles_chariot", {duration = self:GetChannelTime()})
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int11")             
		if abil ~= nil then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_shakle_resist", {duration = self:GetChannelTime()})
		end

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_agi8")             
		if abil ~= nil then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_shakle_armor", {duration = self:GetChannelTime()})
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_str11")             
		if abil ~= nil then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_shakle_damage", {duration = self:GetChannelTime()})
		end
	end
	
	target:EmitSound("Hero_ShadowShaman.Shackles.Cast")
end

function shaman_shackles:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	
	local target = self:GetCursorTarget()
	
	if self:GetCaster():HasModifier("modifier_magic_immune") then
	self:GetCaster():RemoveModifierByName("modifier_magic_immune")
	end
	
	if target then
		target:StopSound("Hero_ShadowShaman.Shackles.Cast")

		if target:FindModifierByNameAndCaster("modifier_shaman_shackles", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_shaman_shackles", self:GetCaster())
		elseif target:FindModifierByNameAndCaster("modifier_shaman_shackles_chariot", self:GetCaster()) then
			target:RemoveModifierByNameAndCaster("modifier_shaman_shackles_chariot", self:GetCaster())
		end
	end
end

-------------------------------
-- SHACKLES HANDLER MODIFIER --
-------------------------------

function modifier_shaman_shackles_handler:IsHidden()		return true end
function modifier_shaman_shackles_handler:IsPurgable()		return false end
function modifier_shaman_shackles_handler:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shaman_shackles_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ORDER
	}	
end


function modifier_shaman_shackles_handler:OnAbilityExecuted(keys)
	if not IsServer() then return end
	
	if keys.ability == self:GetAbility() then
		if keys.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			self:GetCaster():SetModifierStackCount("modifier_shaman_shackles_handler", self:GetCaster(), self:GetAbility():GetSpecialValueFor("channel_time") * (1 - keys.target:GetStatusResistance()) * 100)
		else
			self:GetCaster():SetModifierStackCount("modifier_shaman_shackles_handler", self:GetCaster(), self:GetAbility():GetSpecialValueFor("channel_time") * self:GetAbility():GetSpecialValueFor("chariot_channel_multiplier") * 100)
		end
	end
end

function modifier_shaman_shackles_handler:OnOrder(keys)
	if not IsServer() or keys.unit ~= self:GetParent() or keys.order_type ~= DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO or keys.ability ~= self:GetAbility() then return end
	
	-- Due to logic order, this is actually reversed
	if self:GetAbility():GetAutoCastState() then
		self:GetParent():RemoveModifierByName("modifier_shaman_shackles_target_handler")
	else
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_shaman_shackles_target_handler", {})
	end
end

--------------------------------------
-- SHACKLES TARGET HANDLER MODIFIER --
--------------------------------------

function modifier_shaman_shackles_target_handler:IsHidden()			return true end
function modifier_shaman_shackles_target_handler:IsPurgable()		return false end
function modifier_shaman_shackles_target_handler:RemoveOnDeath()	return false end

function modifier_shaman_shackles_target_handler:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end

function modifier_shaman_shackles_target_handler:OnOrder()
	if not self:GetAbility() or self:GetAbility():IsNull() then
		self:Destroy()
	end
end

-----------------------
-- SHACKLES MODIFIER --
-----------------------

-- Doesn't actually ignore status resist, but this is handled in the channel time function
function modifier_shaman_shackles:IgnoreTenacity()		return true end
function modifier_shaman_shackles:IsPurgable()			return false end
function modifier_shaman_shackles:IsPurgeException()	return true end
function modifier_shaman_shackles:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shaman_shackles:OnCreated()
	if not IsServer() then return end
	
	-- Create shackle particle (yeah this is like 100% wrong but I can't be assed to figure out what exactly goes where)
	local shackle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
	
	self.tick_interval			= self:GetAbility():GetSpecialValueFor("tick_interval")
	self.total_damage			= self:GetAbility():GetSpecialValueFor("total_damage")
	self.channel_time			= self:GetAbility():GetSpecialValueFor("channel_time")
	
	
	self.damage_per_tick	= self.total_damage / (self.channel_time / self.tick_interval)
	
	self:StartIntervalThink(self.tick_interval * (1 - self:GetParent():GetStatusResistance()))
end

function modifier_shaman_shackles:OnIntervalThink()
	if not IsServer() then return end
	
	if not self:GetAbility():IsChanneling() then
		self:Destroy()
	else
		local damageTable = {
			victim 			= self:GetParent(),
			damage 			= self.damage_per_tick,
			damage_type		= self:GetAbility():GetAbilityDamageType(),
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		}

		ApplyDamage(damageTable)
		
	end
end

function modifier_shaman_shackles:CheckState()
	return {[MODIFIER_STATE_STUNNED] = true}
end

function modifier_shaman_shackles:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_shaman_shackles:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

-------------------------------
-- SHACKLES CHARIOT MODIFIER --
-------------------------------

function modifier_shaman_shackles_chariot:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_shaman_shackles_chariot:OnCreated()
	self.chariot_break_distance		= self:GetAbility():GetSpecialValueFor("chariot_break_distance")
	self.chariot_bonus_move_speed	= self:GetAbility():GetSpecialValueFor("chariot_bonus_move_speed")

	if not IsServer() then return end
	
	-- Create shackle particle (yeah this is like 100% wrong but I can't be assed to figure out what exactly goes where)
	local shackle_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_shackle.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(shackle_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 5, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(shackle_particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	self:AddParticle(shackle_particle, true, false, -1, true, false)
	
	self.chariot_max_length	= self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
	self.vector				= self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()
	self.current_position	= self:GetParent():GetAbsOrigin()
	
	self:StartIntervalThink(FrameTime())
end

function modifier_shaman_shackles_chariot:OnIntervalThink()
	if not IsServer() then return end
	
	if not self:GetAbility():IsChanneling() or (self:GetParent():GetAbsOrigin() - self.current_position):Length2D() > self.chariot_break_distance then
		self:GetAbility():SetChanneling(false)
		self:Destroy()
	else
		-- This variable gets updated every frame because the cast range can change at any time technically
		self.chariot_max_length = self:GetAbility():GetCastRange(self:GetParent():GetAbsOrigin(), self:GetParent())
		self.vector				= self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()
		self.current_position	= self:GetParent():GetAbsOrigin()
		
		if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() > self.chariot_max_length then
			FindClearSpaceForUnit(self:GetCaster(), self:GetParent():GetAbsOrigin() + self.vector:Normalized() * self.chariot_max_length, false)
		end
	end
end

function modifier_shaman_shackles_chariot:OnDestroy()
	if not IsServer() then return end
	
	if self:GetAbility() and self:GetAbility():IsChanneling() then
		self:GetAbility():SetChanneling(false)
	end
end

function modifier_shaman_shackles_chariot:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT}
end

function modifier_shaman_shackles_chariot:GetModifierMoveSpeedBonus_Constant()
	return self.chariot_bonus_move_speed
end

------------------------------------------------------------------------------------


modifier_shakle_resist = class({})

function modifier_shakle_resist:IsHidden()
	return false
end

function modifier_shakle_resist:IsDebuff()
	return true
end

function modifier_shakle_resist:IsStunDebuff()
	return false
end

function modifier_shakle_resist:IsPurgable()
	return false
end

function modifier_shakle_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_shakle_resist:GetModifierMagicalResistanceBonus()
	return -50
end

--------------------------------------------------------

modifier_shakle_armor = class({})

function modifier_shakle_armor:IsHidden()
	return false
end

function modifier_shakle_armor:IsDebuff()
	return true
end

function modifier_shakle_armor:IsStunDebuff()
	return false
end

function modifier_shakle_armor:IsPurgable()
	return false
end

function modifier_shakle_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_shakle_armor:GetModifierPhysicalArmorBonus()
level = self:GetAbility():GetLevel()
	return -level
end

--------------------------------------------------------

modifier_shakle_damage = class({})

function modifier_shakle_damage:IsHidden()
	return false
end

function modifier_shakle_damage:IsDebuff()
	return true
end

function modifier_shakle_damage:IsStunDebuff()
	return false
end

function modifier_shakle_damage:IsPurgable()
	return false
end

function modifier_shakle_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_shakle_damage:GetModifierIncomingDamage_Percentage()
	return 15
end