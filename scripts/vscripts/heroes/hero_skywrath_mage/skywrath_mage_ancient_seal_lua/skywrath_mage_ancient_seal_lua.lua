skywrath_mage_ancient_seal_lua = class({})
LinkLuaModifier( "modifier_skywrath_mage_ancient_seal_lua", "heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_lua/modifier_skywrath_mage_ancient_seal_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_root", "heroes/generic/modifier_generic_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skywrath_mage_int_per_cast", "heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_lua/skywrath_mage_ancient_seal_lua", LUA_MODIFIER_MOTION_NONE )

function skywrath_mage_ancient_seal_lua:GetIntrinsicModifierName()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int_last") ~= nil then
		return "modifier_skywrath_mage_int_per_cast"
	end
end

function skywrath_mage_ancient_seal_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int10") ~= nil then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function skywrath_mage_ancient_seal_lua:IsHiddenWhenStolen()
	return false
end

function skywrath_mage_ancient_seal_lua:GetAOERadius()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int7")
		if abil ~= nil	then 
		return self:GetSpecialValueFor("radius")
	end
	return 0
end

function skywrath_mage_ancient_seal_lua:GetBehavior()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int7")
		if abil ~= nil	then 
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function skywrath_mage_ancient_seal_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self

	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_int7")
	if abil ~= nil	then 
		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("seal_duration")
		local target_point = self:GetCursorPosition()
		local target = self:GetCursorTarget()

		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,unit in pairs(units) do
			unit:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_skywrath_mage_ancient_seal_lua", -- modifier name
			{ duration = duration })

		if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_str_last") ~= nil and self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua") ~= nil then
			if self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua"):IsTrained() then
				_G.mystictarget = target
				self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua"):OnSpellStart()
			end
		end
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_agi6")
			if abil ~= nil	then 
				unit:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_generic_root", -- modifier name
				{ duration = duration })
			end
		end
	else
		local duration = ability:GetSpecialValueFor("seal_duration")
		local target = self:GetCursorTarget()

		if self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_str_last") ~= nil and self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua") ~= nil then
			if self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua"):IsTrained() then
				_G.mystictarget = target
				self:GetCaster():FindAbilityByName("skywrath_mage_mystic_flare_lua"):OnSpellStart()
			end
		end

		target:AddNewModifier( caster, self, "modifier_skywrath_mage_ancient_seal_lua", { duration = duration }	)
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skywrath_mage_agi6")
		if abil ~= nil	then 
			target:AddNewModifier( caster, self, "modifier_generic_root", { duration = duration })
		end
	end
end

modifier_skywrath_mage_int_per_cast = class({})

function modifier_skywrath_mage_int_per_cast:GetTexture()
	return "skywrath_mage_ancient_seal"
end

function modifier_skywrath_mage_int_per_cast:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_SPENT_MANA,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_skywrath_mage_int_per_cast:OnSpentMana(keys)
	if keys.unit == self:GetParent() and not keys.ability:IsToggle() and not keys.ability:IsItem() then
    local parent = self:GetParent()
        self:IncrementStackCount()
        parent:CalculateStatBonus(true)
    end
end

function modifier_skywrath_mage_int_per_cast:GetModifierBonusStats_Intellect(params)
    return math.floor(self:GetStackCount() / 2)
end

function modifier_skywrath_mage_int_per_cast:IsHidden()
	return false
end

function modifier_skywrath_mage_int_per_cast:IsPurgable()
    return false
end
 
function modifier_skywrath_mage_int_per_cast:RemoveOnDeath()
    return false
end