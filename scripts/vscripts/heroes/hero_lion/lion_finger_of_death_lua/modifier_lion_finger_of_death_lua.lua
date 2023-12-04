LinkLuaModifier( "modifier_lion_soul_collector", "heroes/hero_lion/lion_soul_collector/lion_soul_collector", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

modifier_lion_finger_of_death_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lion_finger_of_death_lua:IsHidden()
	return true
end

function modifier_lion_finger_of_death_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_lion_finger_of_death_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lion_finger_of_death_lua:OnCreated( kv )
	local caster = self:GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	local fleshHeapStackModifier = "modifier_lion_soul_collector"
    local currentStacks = caster:GetModifierStackCount(fleshHeapStackModifier, caster)
	print('currentStacks', currentStacks)
	local ability = self:GetCaster():FindAbilityByName( "lion_soul_collector" )
	if ability~=nil and ability:GetLevel()>=1 then
		stack_damage = ability:GetSpecialValueFor( "stack_bonus_dmg" )
	
		if self:GetCaster():FindAbilityByName("npc_dota_hero_lion_int7") ~= nil then
			stack_damage = stack_damage * 2
		end
		print('stack_damage', stack_damage)
		self.damage = self.damage + (currentStacks * stack_damage)
		
	end
	print('self.damage', self.damage)
end

function modifier_lion_finger_of_death_lua:OnDestroy( kv )
	if IsServer() then
		-- check if it's still valid target
		if not self:GetParent():IsAlive() then return end
		local nResult = UnitFilter(
			self:GetParent(),
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
			0,
			self:GetCaster():GetTeamNumber()
		)
		if nResult ~= UF_SUCCESS then
			return
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lion_str6")	
		if abil ~= nil then 
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = 3 } -- kv
		)
		end

		-- damage
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
	end
end