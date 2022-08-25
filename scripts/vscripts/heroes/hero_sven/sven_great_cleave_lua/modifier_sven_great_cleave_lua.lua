LinkLuaModifier("modifier_magic_debuff", "heroes/hero_sven/modifier_magic_debuff.lua", LUA_MODIFIER_MOTION_NONE )

modifier_sven_great_cleave_lua = class({})

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnCreated( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
	self:StartIntervalThink(0.1)
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnRefresh( kv )
	self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
	self.great_cleave_radius = self:GetAbility():GetSpecialValueFor( "great_cleave_radius" )
	self.cleave_starting_width = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
	self.cleave_ending_width = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi9")
				if abil ~= nil then 
				self.great_cleave_damage = self.great_cleave_damage + 50
				end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi_last")
				if abil ~= nil then 
				self.great_cleave_damage = self.great_cleave_damage + 200
				end
end

function modifier_sven_great_cleave_lua:OnIntervalThink()
self:OnRefresh()
end


--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:OnAttackLanded( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int7")
				if abil ~= nil then 
				params.target:AddNewModifier(self:GetCaster(), ability, "modifier_magic_debuff", {duration = 2})
				end
				
				local cleaveDamage = ( self.great_cleave_damage * params.damage ) / 100.0
				DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.great_cleave_radius, self.cleave_starting_width, self.cleave_ending_width, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
	return 0
end

----------------------------------------------------------------------------------------------------

function modifier_sven_great_cleave_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi8")
		if abil ~= nil then 
		if self:RollChance( 10) then
			self.record = params.record
			return 200
		end
		end
	end
end

function modifier_sven_great_cleave_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
		end
	end
end

function modifier_sven_great_cleave_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end