sven_gods_strength_lua = class({})
LinkLuaModifier( "modifier_sven_gods_strength_lua", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_strength_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_magic_debuff", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_magic_buff", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_child_lua", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_strength_child_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_talents", "heroes/hero_sven/sven_gods_strength_lua/sven_gods_strength_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function sven_gods_strength_lua:GetIntrinsicModifierName()
    return "modifier_sven_gods_strength_talents"
end

function sven_gods_strength_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") then
		return 0.0
	end
    return 150 + math.min(65000, self:GetCaster():GetIntellect()/30)
end

function sven_gods_strength_lua:OnOwnerSpawned()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") then
		local mod = self:GetCaster():FindModifierByName("modifier_sven_gods_strength_talents")
		mod.str50 = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_lua", {})
	end
end

function sven_gods_strength_lua:GetCooldown(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") then
		return 0.0
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_int50") then
		return 0.1
	end
	return self.BaseClass.GetCooldown( self, iLevel ) - 0.5
end

function sven_gods_strength_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function sven_gods_strength_lua:OnSpellStart()
	local gods_strength_duration = self:GetSpecialValueFor( "gods_strength_duration" )
	local radius = self:GetSpecialValueFor( "scepter_aoe" )
	self.caster = self:GetCaster()
	
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength_lua", { duration = gods_strength_duration }  )
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int6")
	if abil ~= nil then 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_magic_debuff", { duration = gods_strength_duration }  )
	end	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int9")
	if abil ~= nil then 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_magic_buff", { duration = gods_strength_duration }  )
	end	
		
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Sven.GodsStrength", self:GetCaster() )

	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_4 );
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int11")
		if abil ~= nil then 
	
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetAbsOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,enemy in pairs(enemies) do
		ApplyDamage({
			attacker = self:GetCaster(), 
			victim = enemy, 
			ability = self, 
			damage = self:GetCaster():GetIntellect()*5, 
			damage_type = DAMAGE_TYPE_MAGICAL 
		})
	end
	end
end

modifier_sven_gods_strength_talents = class({})
--Classifications template
function modifier_sven_gods_strength_talents:IsHidden()
	return true
end

function modifier_sven_gods_strength_talents:IsDebuff()
	return false
end

function modifier_sven_gods_strength_talents:IsPurgable()
	return false
end

function modifier_sven_gods_strength_talents:RemoveOnDeath()
	return false
end

function modifier_sven_gods_strength_talents:OnCreated( kv )
	if not IsServer() then return end
	self:StartIntervalThink(0.5)
end

function modifier_sven_gods_strength_talents:OnRefresh( kv )
	if not IsServer() then return end
	if self.str50 ~= nil then
		self.str50:Destroy()
		self.str50 = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_gods_strength_lua", {})
	end
end

function modifier_sven_gods_strength_talents:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") and self.str50 == nil then
		self.str50 = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_gods_strength_lua", {})
	elseif not self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_str50") and self.str50 ~= nil then
		self.str50:Destroy()
		self.str50 = nil
	end
end

function modifier_sven_gods_strength_talents:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_sven_gods_strength_talents:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			return 1
		end
	end
	return 0
end

function modifier_sven_gods_strength_talents:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityCharges" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_int50") then
                value = 3
            end
            return value
		end
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityChargeRestoreTime", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int8") then
                value = value / 2
            end
            return value
		end
	end
	return 0
end