modifier_sniper_shrapnel_lua = class({})

function modifier_sniper_shrapnel_lua:IsHidden()
	return false
end

function modifier_sniper_shrapnel_lua:IsDebuff()
	return true
end

function modifier_sniper_shrapnel_lua:IsPurgable()
	return false
end

function modifier_sniper_shrapnel_lua:OnCreated( kv )
	self.caster = self:GetAbility():GetCaster()
	self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" ) -- special value
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" ) -- special value

	

	local interval = 1
	

	if IsServer() then
	
		local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_str11")
		if abil ~= nil then 
		self.damage = self.caster:GetStrength()
		end
		
		local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_agi10")
		if abil ~= nil then 
		self.damage = self.caster:GetBaseDamageMin()
		end
		
		local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_int10")
		if abil ~= nil then 
		self.damage = self.damage + (self.caster:GetStrength() + self.caster:GetAgility() + self.caster:GetIntellect() )/3
		end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_int_last") ~= nil then
			self.damage = self.damage + self.caster:GetIntellect()
		end

		damage_type = DAMAGE_TYPE_PHYSICAL
		
		local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_int9")
		if abil ~= nil	then 
		damage_type = DAMAGE_TYPE_MAGICAL
		end		
		
		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self.caster,
			damage = self.damage,
			damage_type = damage_type,
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
	end
end

function modifier_sniper_shrapnel_lua:OnRefresh( kv )
	
end

function modifier_sniper_shrapnel_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_shrapnel_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_sniper_shrapnel_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_sniper_shrapnel_lua:GetModifierAttackSpeedBonus_Constant()
	local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_str6")
	if abil ~= nil then 
	return -15--0
end
end

function modifier_sniper_shrapnel_lua:GetModifierPhysicalArmorBonus()
	local abil = self.caster:FindAbilityByName("npc_dota_hero_sniper_agi7")
	if abil ~= nil then 
	return -5
end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sniper_shrapnel_lua:OnIntervalThink()
	-- if self.caster:IsAlive() then
		ApplyDamage(self.damageTable)
	-- end
end