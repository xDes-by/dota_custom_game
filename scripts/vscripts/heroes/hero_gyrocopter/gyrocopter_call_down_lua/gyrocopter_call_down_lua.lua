LinkLuaModifier("modifier_gyrocopter_call_down_lua_thinker", "heroes/hero_gyrocopter/gyrocopter_call_down_lua/gyrocopter_call_down_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_call_down_lua_slow", "heroes/hero_gyrocopter/gyrocopter_call_down_lua/gyrocopter_call_down_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyrocopter_call_down_lua_flame", "heroes/hero_gyrocopter/gyrocopter_call_down_lua/gyrocopter_call_down_lua", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------------------------------------

gyrocopter_call_down_lua = gyrocopter_call_down_lua or class({})

function gyrocopter_call_down_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect()*3)
    end
end

function gyrocopter_call_down_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Gyrocopter.CallDown.Fire")
	if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" then
		if not self.responses then
			self.responses = 
			{
				"gyrocopter_gyro_call_down_03",
				"gyrocopter_gyro_call_down_04",
				"gyrocopter_gyro_call_down_05",
				"gyrocopter_gyro_call_down_06",
				"gyrocopter_gyro_call_down_09"
			}
		end	
		EmitSoundOnClient(self.responses[RandomInt(1, #self.responses)], self:GetCaster():GetPlayerOwner())
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str_last") ~= nil then 
		local caster_pos = self:GetCaster():GetAbsOrigin()
		for i=1, 5 do
			local angle = RandomInt(0, 360)
			local variance = RandomInt(-600, 600)
			local dy = math.sin(angle) * variance
			local dx = math.cos(angle) * variance
			local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
			CreateModifierThinker(self:GetCaster(), self, "modifier_gyrocopter_call_down_lua_thinker", {duration = self:GetSpecialValueFor("missile_delay_tooltip") * 2}, target_point, self:GetCaster():GetTeamNumber(), false)
		end
	else
		CreateModifierThinker(self:GetCaster(), self, "modifier_gyrocopter_call_down_lua_thinker", {duration = self:GetSpecialValueFor("missile_delay_tooltip") * 2}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end
end

------------------------------------------------

modifier_gyrocopter_call_down_lua_thinker = modifier_gyrocopter_call_down_lua_thinker or class({})

function modifier_gyrocopter_call_down_lua_thinker:OnCreated()
	self.slow_duration	= self:GetAbility():GetSpecialValueFor("slow_duration")
	self.damage_first			= self:GetAbility():GetSpecialValueFor("damage_first")
	self.damage_second			= self:GetAbility():GetSpecialValueFor("damage_second")
	self.slow_first				= self:GetAbility():GetSpecialValueFor("slow_first")
	self.slow_second			= self:GetAbility():GetSpecialValueFor("slow_second")
	self.radius					= self:GetAbility():GetSpecialValueFor("radius")
	self.missile_delay_tooltip	= self:GetAbility():GetSpecialValueFor("missile_delay_tooltip")


	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str8") ~= nil then 
		self.slow_duration = self.slow_duration + 2
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str9") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetStrength()
		self.damage_second = self.damage_second + self:GetCaster():GetStrength()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int7") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetIntellect()
		self.damage_second = self.damage_second + self:GetCaster():GetIntellect()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi11") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetAgility()
		self.damage_second = self.damage_second + self:GetCaster():GetAgility()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int10") ~= nil then 
		if self:GetCaster():GetIntellect() > self:GetCaster():GetStrength() and self:GetCaster():GetIntellect() > self:GetCaster():GetAgility() then
			self.damage_first = self.damage_first * 2
			self.damage_second = self.damage_second * 2
		end
	end	
	
	if not IsServer() then return end
	
	self.damage_type = self:GetAbility():GetAbilityDamageType()
	
	self.first_missile_impact	= false
	self.second_missile_impact	= false
	
	self.marker_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_marker.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(self.marker_particle, 0, self:GetParent():GetAbsOrigin())
	
	ParticleManager:SetParticleControl(self.marker_particle, 1, Vector(self.radius, 1, self.radius * (-1)))
	self:AddParticle(self.marker_particle, false, false, -1, false, false)
	
	local calldown_first_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_first.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_first_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket1")))
	ParticleManager:SetParticleControl(calldown_first_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_first_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_first_particle)
	
	local calldown_second_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_second.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(calldown_second_particle, 0, self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_rocket2")))
	ParticleManager:SetParticleControl(calldown_second_particle, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(calldown_second_particle, 5, Vector(self.radius, self.radius, self.radius))
	ParticleManager:ReleaseParticleIndex(calldown_second_particle)
	
	self:StartIntervalThink(self.missile_delay_tooltip)
end

function modifier_gyrocopter_call_down_lua_thinker:OnIntervalThink()
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Gyrocopter.CallDown.Damage", self:GetCaster())
	
	if not self.first_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_call_down_lua_slow", {duration = self.slow_duration * (1 - enemy:GetStatusResistance()), slow = self.slow_first})
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.slow_duration-2 * (1 - enemy:GetStatusResistance()), slow = self.slow_first})
			
			if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str11") ~= nil then 
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_call_down_lua_flame", {duration = 5 * (1 - enemy:GetStatusResistance())})
			end	
			
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_first,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
			end
		end
		
		self.first_missile_impact = true
	elseif not self.second_missile_impact then
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_gyrocopter_call_down_lua_slow", {duration = self.slow_duration * (1 - enemy:GetStatusResistance()), slow = self.slow_second})
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.slow_duration-2 * (1 - enemy:GetStatusResistance()), slow = self.slow_first})
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.damage_second,
				damage_type		= self.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			if self:GetCaster():GetName() == "npc_dota_hero_gyrocopter" and (enemy:IsRealHero() or enemy:IsClone()) and not enemy:IsAlive() then
				EmitSoundOnClient("gyrocopter_gyro_call_down_1"..RandomInt(1, 2), self:GetCaster():GetPlayerOwner())
			end
		end
	
		self.second_missile_impact = true
	end
end

---------------------------------------------

modifier_gyrocopter_call_down_lua_flame = class({})

function modifier_gyrocopter_call_down_lua_flame:IsHidden()
	return false
end

function modifier_gyrocopter_call_down_lua_flame:IsDebuff()
	return true
end

function modifier_gyrocopter_call_down_lua_flame:IsStunDebuff()
	return false
end

function modifier_gyrocopter_call_down_lua_flame:IsPurgable()
	return true
end

function modifier_gyrocopter_call_down_lua_flame:OnCreated( kv )
	self.damage_first = self:GetAbility():GetSpecialValueFor("damage_first")

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_str9") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetStrength()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int7") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetIntellect()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_agi11") ~= nil then 
		self.damage_first = self.damage_first + self:GetCaster():GetAgility()
	end	

	if self:GetCaster():FindAbilityByName("npc_dota_hero_gyrocopter_int10") ~= nil then 
		if self:GetCaster():GetIntellect() > self:GetCaster():GetStrength() and self:GetCaster():GetIntellect() > self:GetCaster():GetAgility() then
			self.damage_first = self.damage_first * 2
		end
	end	

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage_first/10,
		damage_type = DAMAGE_TYPE_MAGICAL,
	}
	self:StartIntervalThink(1)
end

function modifier_gyrocopter_call_down_lua_flame:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_gyrocopter_call_down_lua_flame:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_gyrocopter_call_down_lua_flame:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------

modifier_gyrocopter_call_down_lua_slow = modifier_gyrocopter_call_down_lua_slow or class({})

function modifier_gyrocopter_call_down_lua_slow:OnCreated(keys)
	if keys and keys.slow then
		self:SetStackCount(keys.slow * (-1))
	end
end

function modifier_gyrocopter_call_down_lua_slow:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_gyrocopter_call_down_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end