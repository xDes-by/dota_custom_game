pudge_dismember_hero_lua = class({})
LinkLuaModifier( "modifier_dismember_lua", "heroes/hero_pudge/dismember/spell_dismember.lua" ,LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function pudge_dismember_hero_lua:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function pudge_dismember_hero_lua:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function pudge_dismember_hero_lua:GetChannelTime()
	self.duration = self:GetSpecialValueFor( "duration" )
	return self.duration
end

function pudge_dismember_hero_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

function pudge_dismember_hero_lua:GetManaCost(iLevel)
	return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end


function pudge_dismember_hero_lua:OnSpellStart()
	if self.hVictim == nil then
		return
	end
	target = self:GetCursorTarget()
	
	if target:TriggerSpellAbsorb(self) then
		--self:PlayEffects( target )
		return 
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi_last") == nil then		
		target:AddNewModifier( self:GetCaster(), self, "modifier_dismember_lua", { duration = self:GetChannelTime() } )
	else
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCursorTarget():GetAbsOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_dismember_lua", { duration = self:GetChannelTime() } )
		end
	end
end

function pudge_dismember_hero_lua:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_dismember_lua" )
	end
end

--------------------------------------------------------------------------------

modifier_dismember_lua = class({})

function modifier_dismember_lua:IsDebuff()
	return true
end

function modifier_dismember_lua:IsStunDebuff()
	return true
end

function modifier_dismember_lua:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.statdmg = self:GetCaster():GetStrength()
		
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi9") ~= nil then
		self.statdmg = self:GetCaster():GetAgility()
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str11") ~= nil then
		self.statdmg = self.statdmg * 2
	end
	
	self.true_damage = self.dismember_damage + self.statdmg
	
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_dismember_lua:OnIntervalThink()
	if IsServer() then

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.true_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )

		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
	end
end

function modifier_dismember_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_dismember_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_dismember_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end