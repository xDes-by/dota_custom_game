pudge_dismember_hero_lua = class({})

LinkLuaModifier( "modifier_dismember_lua", "heroes/hero_pudge/dismember/spell_dismember.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dismember_lua_aura", "heroes/hero_pudge/dismember/spell_dismember.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_pudge_agi50", "heroes/hero_pudge/dismember/spell_dismember.lua" ,LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function pudge_dismember_hero_lua:GetIntrinsicModifierName()
	return "modifier_dismember_lua_aura"
end

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

function pudge_dismember_hero_lua:GetCastRange()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pudge_agi50") then
		return 400
	end
	return 160
end

function pudge_dismember_hero_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pudge_agi50") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function pudge_dismember_hero_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

function pudge_dismember_hero_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pudge_agi50") then
		return 0
	end
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
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}
end

function modifier_dismember_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_dismember_lua:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_dismember_lua:GetModifierPhysicalArmorBonus()
	return self.armor or 0
end

modifier_dismember_lua_aura = class({})
--Classifications template
function modifier_dismember_lua_aura:IsHidden()
	return true
end

function modifier_dismember_lua_aura:IsDebuff()
	return false
end

function modifier_dismember_lua_aura:IsPurgable()
	return false
end

function modifier_dismember_lua_aura:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_dismember_lua_aura:IsStunDebuff()
	return false
end

function modifier_dismember_lua_aura:RemoveOnDeath()
	return false
end

function modifier_dismember_lua_aura:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_dismember_lua_aura:IsAura()
	if self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_pudge_agi50") then
		return true
	end
	return false
end

function modifier_dismember_lua_aura:GetModifierAura()
	return "modifier_special_bonus_unique_npc_dota_hero_pudge_agi50"
end

function modifier_dismember_lua_aura:GetAuraRadius()
	return 400
end

function modifier_dismember_lua_aura:GetAuraDuration()
	return 0.5
end

function modifier_dismember_lua_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_dismember_lua_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dismember_lua_aura:GetAuraSearchFlags()
	return 0
end

modifier_special_bonus_unique_npc_dota_hero_pudge_agi50 = class({})

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:IsDebuff()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:IsStunDebuff()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:OnCreated( kv )
	self.statdmg = self:GetCaster():GetStrength()
		
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi9") ~= nil then
		self.statdmg = self:GetCaster():GetAgility()
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_str11") ~= nil then
		self.statdmg = self.statdmg * 2
	end
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.true_damage = self.dismember_damage + self.statdmg
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )

	if IsServer() then
		self:StartIntervalThink( 0.2 )
	end
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:OnIntervalThink()
	if IsServer() then

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.true_damage * self.tick_rate,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		ApplyDamage( damage )

		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false,
	}
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:GetModifierMoveSpeedBonus_Percentage()
	return -50
end

function modifier_special_bonus_unique_npc_dota_hero_pudge_agi50:GetModifierAttackSpeedBonus_Constant()
	return -60
end