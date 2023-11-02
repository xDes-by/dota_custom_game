modifier_jakiro_liquid_fire_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_liquid_fire_lua:IsHidden()
	return false
end

function modifier_jakiro_liquid_fire_lua:IsDebuff()
	return true
end

function modifier_jakiro_liquid_fire_lua:IsStunDebuff()
	return false
end

function modifier_jakiro_liquid_fire_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_liquid_fire_lua:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed_pct" )
	
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_int2")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		damage = self:GetAbility():GetSpecialValueFor( "damage" ) + 25
	end

	if not IsServer() then return end
	local interval = 0.5
	-- precache damage
	self.damage = damage * interval
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self.stack_table = {}
	-- ApplyDamage(damageTable)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi13") then
		interval = interval / 2
	end
	self:StartIntervalThink( interval )
end

function modifier_jakiro_liquid_fire_lua:OnRefresh( kv )
end

function modifier_jakiro_liquid_fire_lua:OnRemoved()
end

function modifier_jakiro_liquid_fire_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jakiro_liquid_fire_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_jakiro_liquid_fire_lua:GetModifierAttackSpeedBonus_Constant()
	return self.slow
end

function modifier_jakiro_liquid_fire_lua:OnStackCountChanged(prev_stacks)
	if not IsServer() then return end
	local stacks = self:GetStackCount()
	if stacks > prev_stacks then
		table.insert(self.stack_table, GameRules:GetGameTime())
		self:ForceRefresh()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_jakiro_liquid_fire_lua:OnIntervalThink()
	local repeat_needed = #self.stack_table > 0
	while repeat_needed do
		if GameRules:GetGameTime() - self.stack_table[1] >= 6 then
			table.remove(self.stack_table, 1)
			self:DecrementStackCount()
		else
			repeat_needed = false
		end
	end
	if self:GetStackCount() > 1 then
		local stacks = self:GetStackCount() - 1
		self.damageTable.damage = self.damage + (self.damage * 0.1) * stacks
	end
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jakiro_liquid_fire_lua:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_jakiro_liquid_fire_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end