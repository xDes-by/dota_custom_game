LinkLuaModifier("modifier_ancient_apparition_cold_feet_lua_freeze", "heroes/hero_ancient_apparition/ancient_apparition_cold_feet_lua/ancient_apparition_cold_feet_lua", LUA_MODIFIER_MOTION_NONE)

ancient_apparition_cold_feet_lua = class({})

function ancient_apparition_cold_feet_lua:GetManaCost(iLevel)
	return math.min(65000, self:GetCaster():GetIntellect())
end

function ancient_apparition_cold_feet_lua:GetAOERadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str10") ~= nil	then 
		return 700
	end
	return 250
end

function ancient_apparition_cold_feet_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str10") ~= nil then 
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

function ancient_apparition_cold_feet_lua:OnSpellStart()
	if not IsServer() then return end
	
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Ancient_Apparition.ColdFeetCast")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str10") == nil then 	
		local target_point = self:GetCursorPosition()
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), target_point, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		for _, hEnemy in pairs( enemies ) do
			hEnemy:AddNewModifier(caster, self, "modifier_ancient_apparition_cold_feet_lua_freeze", {duration = duration})
		end
	else
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
		for _, hEnemy in pairs( enemies ) do
			hEnemy:AddNewModifier(caster, self, "modifier_ancient_apparition_cold_feet_lua_freeze", {duration = duration})
		end
	end
end

---------------------------------------------------------------------------------------------------
modifier_ancient_apparition_cold_feet_lua_freeze = class({})

function modifier_ancient_apparition_cold_feet_lua_freeze:IsHidden() return true end
function modifier_ancient_apparition_cold_feet_lua_freeze:IsPurgable() return false end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_ancient_apparition_cold_feet_lua_freeze:OnCreated()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Ancient_Apparition.ColdFeetFreeze")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str7") ~= nil then 	
		self.damage = self.damage + self:GetCaster():GetStrength()
	end
	self:StartIntervalThink(0.5)
end

function modifier_ancient_apparition_cold_feet_lua_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
	return state
end

function modifier_ancient_apparition_cold_feet_lua_freeze:OnIntervalThink()
	if not IsServer() then return end
	ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage/2, damage_type = DAMAGE_TYPE_MAGICAL})
end

function modifier_ancient_apparition_cold_feet_lua_freeze:DeclareFunctions()
	local decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return decFuncs
end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetModifierPhysicalArmorBonus()
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str11") ~= nil then 	
		self.resist = self.resist * 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str_last") ~= nil then 
		self.armor = self:GetParent():GetPhysicalArmorBaseValue()/100 * self.resist * (-1)
		return self.armor
	end
	return 0
end

function modifier_ancient_apparition_cold_feet_lua_freeze:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str_last") ~= nil then 
		return 0
	end
	self.resist = self:GetAbility():GetSpecialValueFor( "resist" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_str11") ~= nil then 	
		self.resist = self.resist * 2
	end
		self.magic_resist = self.resist * (-1)
	return self.magic_resist
end