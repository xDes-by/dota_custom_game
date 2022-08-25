modifier_sniper_headshot_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sniper_headshot_lua:IsHidden()
	return true
end

function modifier_sniper_headshot_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sniper_headshot_lua:OnCreated( kv )
	-- references
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" ) -- special value
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" ) -- special value
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		local abil =self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_agi8")
		if abil ~= nil then 
		self.damage = self:GetAbility():GetAbilityDamage() *2 
		end
	end
	crit = false 
end

function modifier_sniper_headshot_lua:OnRefresh( kv )
	-- references
	self.proc_chance = self:GetAbility():GetSpecialValueFor( "proc_chance" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.bonus_attack_range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )
	self.slow = self:GetAbility():GetSpecialValueFor( "slow" ) -- special value
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_agi8")
		if abil ~= nil then 
			self.damage = self:GetAbility():GetAbilityDamage() *2 
		end
	end
	crit = false 	
end

function modifier_sniper_headshot_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sniper_headshot_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
			MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end

function modifier_sniper_headshot_lua:GetModifierAttackRangeBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_attack_range
	end
end

function modifier_sniper_headshot_lua:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- roll dice
		if RandomInt(1,100)<=self.proc_chance then
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_agi9")
			if abil ~= nil then 
			crit = true
			end

			params.target:AddNewModifier(
				self:GetParent(), -- player source
				self, -- ability source
				"modifier_sniper_headshot_lua_slow", -- modifier name
				{ 
					duration = self.slow_duration,
					slow = self.slow, 
				} -- kv
			)
			return self.damage
		else
		crit = false 	
		end
	end
end

function modifier_sniper_headshot_lua:GetModifierPreAttack_CriticalStrike( params )
		if IsServer() and (not self:GetParent():PassivesDisabled()) then

		if crit == true then
			return 200
		end
	end
end