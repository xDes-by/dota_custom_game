dragon_form_lua = class({})
LinkLuaModifier( "modifier_dragon_form_lua", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_corrosive", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_corrosive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_frost", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_frost", LUA_MODIFIER_MOTION_NONE )


function dragon_form_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect()/30)
end

function dragon_form_lua:GetCooldown( level )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi_last") then
		return 0.1
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int6") 
	if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - self.BaseClass.GetCooldown(self, level) * 0.25
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end
function dragon_form_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function dragon_form_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function dragon_form_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dragon_form_lua", {})
	else
		-- self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_dragon_form_lua", self:GetCaster())
	end
	
end

function dragon_form_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi_last") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function dragon_form_lua:OnSpellStart()

	local caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	-- if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dragon_knight_agi50") ~= nil then
	-- 	duration = -1
	-- end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi11") 
		if abil ~= nil then
		duration = 180
		end
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dragon_form_lua", -- modifier name
		{ duration = duration } -- kv
	)
end