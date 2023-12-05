freezing_field_lua = class({})
LinkLuaModifier( "modifier_freezing_field_lua", "heroes/hero_crystal/freezing_field_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_manacost_lua", "heroes/hero_crystal/freezing_field_lua", LUA_MODIFIER_MOTION_NONE )


function freezing_field_lua:OnSpellStart()
	local caster = self:GetCaster()
end

function freezing_field_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 200)
end

function freezing_field_lua:GetIntrinsicModifierName()
	return "modifier_manacost_lua_cm"
end

modifier_manacost_lua_cm = class({})

function modifier_manacost_lua_cm:IsHidden()
	return true
end

function modifier_manacost_lua_cm:IsDebuff()
	return false
end

function modifier_manacost_lua_cm:IsPurgable()
	return false
end

function modifier_manacost_lua_cm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
	}
	return funcs
end

function modifier_manacost_lua_cm:GetModifierPercentageManacost()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int10") ~= nil then
		return 50
	end	
end	

function freezing_field_lua:OnToggle()
	self:StartCooldown(1)
	if self:GetToggleState() then
		self.modifier = self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_freezing_field_lua",{})
	else
		if self.modifier and not self.modifier:IsNull() then
			self.modifier:Destroy()
		end
		self.modifier = nil
	end
end

modifier_freezing_field_lua = class({})

function modifier_freezing_field_lua:IsHidden()
	return false
end

function modifier_freezing_field_lua:IsDebuff()
	return false
end

function modifier_freezing_field_lua:IsPurgable()
	return false
end

function modifier_freezing_field_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_freezing_field_lua:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int9")	
		if abil ~= nil then 
		self.radius = self.radius * 1.5
		end
	
	self.manacost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())

	if self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int10") ~= nil then
		self.manacost = self.manacost/2
	end
	interval = 1
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_crystal_maiden_int50") or self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_crystal_maiden_str50") then
		interval = interval / 2
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_str11")	
		if abil ~= nil then 
		self.damage = self.damage + self:GetCaster():GetStrength()
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int6")	
		if abil ~= nil then 
		self.damage = self.damage + self:GetCaster():GetIntellect()/2
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_crystal_maiden_int_last")	
	if abil ~= nil then 
		self.damage = self.damage * 2
	end

	-- precache
	
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:Burn()
	self:StartIntervalThink( interval )

    EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_freezing_field_lua:GetEffectName()
    return "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
end

function modifier_freezing_field_lua:GetEffectAttachType()
    return PATTACH_POINT_FOLLOW
end

function modifier_freezing_field_lua:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "hero_Crystal.freezingField.explosion"
	StopSoundOn( sound_loop, self:GetParent() )
end

function modifier_freezing_field_lua:OnIntervalThink()
	local mana = self:GetParent():GetMana()
	if mana < self.manacost then
		-- turn off
		if self:GetAbility():GetToggleState() then
			self:GetAbility():ToggleAbility()
		end
		return
	end
	self:Burn()
end

function modifier_freezing_field_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_freezing_field_lua:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_crystal_maiden_int50") ~= nil then
		return 550
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_crystal_maiden_str50") ~= nil then
		return -550
	end
end

function modifier_freezing_field_lua:Burn()
	self:GetParent():SpendMana( self.manacost, self:GetAbility() )
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end
end
