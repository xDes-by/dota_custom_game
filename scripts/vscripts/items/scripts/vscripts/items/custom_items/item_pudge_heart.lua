item_pudge_heart_lua1 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua2 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua3 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua4 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua5 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua6 = item_pudge_heart_lua1 or class({})
item_pudge_heart_lua7 = item_pudge_heart_lua1 or class({})

LinkLuaModifier("modifier_item_pudge_heart_passive", 'items/custom_items/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pudge_heart", 'items/custom_items/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_pudge_heart_lua1:GetIntrinsicModifierName()
	return "modifier_item_pudge_heart_passive"
end

function item_pudge_heart_lua1:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function item_pudge_heart_lua1:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function item_pudge_heart_lua1:GetChannelTime()
	self.duration = self:GetSpecialValueFor( "duration" )

	return self.duration 
end

function item_pudge_heart_lua1:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end
	return true
end

function item_pudge_heart_lua1:OnSpellStart()
	if self.hVictim == nil then
		return
	end

	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_item_pudge_heart", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


function item_pudge_heart_lua1:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_item_pudge_heart" )
	end
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart = class({})

function modifier_item_pudge_heart:IsDebuff()
	return true
end

function modifier_item_pudge_heart:IsStunDebuff()
	return true
end

function modifier_item_pudge_heart:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

function modifier_item_pudge_heart:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

function modifier_item_pudge_heart:OnIntervalThink()
	if IsServer() then
	
		local flDamage = self.dismember_damage * self:GetCaster():GetStrength()
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		
		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = flDamage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}

		ApplyDamage( damage )
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
	end
end

function modifier_item_pudge_heart:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_item_pudge_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_item_pudge_heart:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive = class({})

function modifier_item_pudge_heart_passive:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive:OnCreated( kv )
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_pudge_heart_passive:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_pudge_heart_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,        
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_pudge_heart_passive:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end