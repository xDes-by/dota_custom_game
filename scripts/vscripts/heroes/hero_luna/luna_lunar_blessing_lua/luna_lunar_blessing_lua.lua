LinkLuaModifier( "modifier_luna_lunar_blessing_lua", "heroes/hero_luna/luna_lunar_blessing_lua/luna_lunar_blessing_lua", LUA_MODIFIER_MOTION_NONE )

luna_lunar_blessing_lua = class({})

function luna_lunar_blessing_lua:GetIntrinsicModifierName()
	return "modifier_luna_lunar_blessing_lua"
end

function luna_lunar_blessing_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_luna_agi50") then
		return 0
	end
end

---------------------------------------------------------------------

modifier_luna_lunar_blessing_lua = class({})

function modifier_luna_lunar_blessing_lua:IsHidden()
	return true 
end

function modifier_luna_lunar_blessing_lua:IsDebuff()
	return false
end

function modifier_luna_lunar_blessing_lua:IsPurgable()
	return false
end

function modifier_luna_lunar_blessing_lua:OnCreated( kv )
	if IsServer() then
		local primary = self:GetCaster():GetPrimaryAttribute()
		if primary==DOTA_ATTRIBUTE_STRENGTH then
			self.strength = 1
			self.agility = 0
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_AGILITY then
			self.strength = 0
			self.agility = 1
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_INTELLECT then
			self.strength = 0
			self.agility = 0
			self.intelligence = 1
		end
	end
	self:StartIntervalThink(0.1)
end

function modifier_luna_lunar_blessing_lua:OnIntervalThink()
    if IsServer() then
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.caster = self:GetCaster()
	self.bonus_night_vision = self:GetAbility():GetSpecialValueFor( "bonus_night_vision" )
		local primary = self:GetCaster():GetPrimaryAttribute()
		if primary==DOTA_ATTRIBUTE_STRENGTH then
			self.strength = 1
			self.agility = 0
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_AGILITY then
			self.strength = 0
			self.agility = 1
			self.intelligence = 0
		elseif primary==DOTA_ATTRIBUTE_INTELLECT then
			self.strength = 0
			self.agility = 0
			self.intelligence = 1
		end
	 
	count = 1
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_luna_agi8") ~= nil then 
		count = 2
	end

	bonus = 0
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_luna_str10") ~= nil then 
		bonus = 18
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_luna_str_last") ~= nil then 
		bonus = bonus + 100
	end

	primary_attribute = (self:GetAbility():GetSpecialValueFor( "primary_attribute" ) + bonus ) / 100
	
	
	agility = self.agility * self:GetCaster():GetBaseAgility() * count
	intelligence = self.intelligence * self:GetCaster():GetBaseIntellect() * count
	strength = self.strength * self:GetCaster():GetBaseStrength() * count
	strength2 = self:GetCaster():GetBaseStrength() * count
		if self:GetCaster():GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then
			strength2 = self:GetCaster():GetBaseStrength() * count * 2
		end
	end
end

function modifier_luna_lunar_blessing_lua:OnRefresh( kv )
end

function modifier_luna_lunar_blessing_lua:OnRemoved()
end

function modifier_luna_lunar_blessing_lua:OnDestroy()
end

--------------------------------------------------------------------------------
function modifier_luna_lunar_blessing_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end

function modifier_luna_lunar_blessing_lua:GetBonusNightVision()
	return self.bonus_night_vision
end

if IsServer() then
	function modifier_luna_lunar_blessing_lua:GetModifierBaseAttack_BonusDamage()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_luna_agi11")
		if abil ~= nil then 
		if self:GetParent():PassivesDisabled() then return 0 end
		if  self:GetParent()==self:GetCaster() then return  self:GetCaster():GetAgility()  end
		if  self:GetParent()~=self:GetCaster() then 
			if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_luna_agi50") then
				return self:GetParent():GetAgility()
			end
		end
		end
	end
	
	function modifier_luna_lunar_blessing_lua:GetModifierBonusStats_Agility()
		if self:GetParent():PassivesDisabled() then return 0 end
		if  self:GetParent()==self:GetCaster() then return agility end
		if  self:GetParent()~=self:GetCaster() then return self:GetParent():GetBaseAgility() * primary_attribute end
	end
	
	function modifier_luna_lunar_blessing_lua:GetModifierBonusStats_Intellect()
		if self:GetParent():PassivesDisabled() then return 0 end
		if  self:GetParent()==self:GetCaster() then return intelligence end
		if  self:GetParent()~=self:GetCaster() then return self:GetParent():GetBaseIntellect() * primary_attribute end
	end
	
	function modifier_luna_lunar_blessing_lua:GetModifierBonusStats_Strength()
		if self:GetParent():PassivesDisabled() then return 0 end
		if self:GetParent()==self:GetCaster() and not self:GetCaster():HasAbility("npc_dota_hero_luna_str9") then return strength end
		if self:GetParent()==self:GetCaster() and self:GetCaster():HasAbility("npc_dota_hero_luna_str9") then return strength2 end
		if self:GetParent()~=self:GetCaster() then return self:GetParent():GetBaseStrength() * primary_attribute end
	end
end

function modifier_luna_lunar_blessing_lua:IsAura()
	return self:GetParent() == self:GetCaster()
end

function modifier_luna_lunar_blessing_lua:GetModifierAura()
	return "modifier_luna_lunar_blessing_lua"
end

function modifier_luna_lunar_blessing_lua:GetAuraRadius()
	if self:GetParent():PassivesDisabled() then return 0 end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_luna_agi50") then
		return FIND_UNITS_EVERYWHERE
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_luna_str8")
	if abil ~= nil then 
		return self.radius + 700
	end
	return self.radius
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_luna_lunar_blessing_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end