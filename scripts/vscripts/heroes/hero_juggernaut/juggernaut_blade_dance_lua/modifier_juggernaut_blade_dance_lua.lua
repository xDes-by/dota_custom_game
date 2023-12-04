modifier_juggernaut_blade_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_juggernaut_blade_dance_lua:IsHidden()
	return true
end

function modifier_juggernaut_blade_dance_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_juggernaut_blade_dance_lua:OnCreated( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
	self:StartIntervalThink(0.1)
end

function modifier_juggernaut_blade_dance_lua:OnRefresh( kv )
	-- references
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "blade_dance_crit_mult" )
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_agi11") 
		if abil ~= nil then
		self.crit_chance = self.crit_chance +17
		end
		self.special_bonus_unique_npc_dota_hero_juggernaut_int50 = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_int50")
		self.npc_dota_hero_juggernaut_int_last = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_int_last")
		self.rand = 10
		if self.special_bonus_unique_npc_dota_hero_juggernaut_int50 then
			self.rand = self.rand + 15
		end
end

function modifier_juggernaut_blade_dance_lua:OnIntervalThink()
self:OnRefresh()
end

function modifier_juggernaut_blade_dance_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_juggernaut_blade_dance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_juggernaut_blade_dance_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100)<self.crit_chance then
			self.record = params.record
			return self.crit_mult
		end
	end
end

function modifier_juggernaut_blade_dance_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil

			-- Play effects
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end

function modifier_juggernaut_blade_dance_lua:OnAttackLanded(params)
	if self.npc_dota_hero_juggernaut_int_last and RollPercentage(self.rand) and params.attacker:FindAbilityByName("juggernaut_requiem") ~= nil and params.attacker:FindAbilityByName("juggernaut_requiem"):IsTrained() then
		self:GetAbility():GetCaster():FindAbilityByName("juggernaut_requiem"):OnSpellStart()
	end
end