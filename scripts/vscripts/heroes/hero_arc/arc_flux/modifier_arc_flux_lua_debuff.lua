modifier_arc_flux_lua_debuff = class({})


function modifier_arc_flux_lua_debuff:IsHidden()
	return false
end

function modifier_arc_flux_lua_debuff:IsDebuff()
	return true
end

function modifier_arc_flux_lua_debuff:IsStunDebuff()
	return false
end

function modifier_arc_flux_lua_debuff:IsPurgable()
	return false
end

function modifier_arc_flux_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end


function modifier_arc_flux_lua_debuff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" ) * (-1)
	self.attackspeed = self:GetAbility():GetSpecialValueFor( "attackspeed" ) * (-1)
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str8")
	if abil ~= nil then
	self.movespeed = self.movespeed*3
	self.attackspeed = self.attackspeed*3
	end

	self:StartIntervalThink(1)
	if not IsServer() then return end
end

function modifier_arc_flux_lua_debuff:OnIntervalThink()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str7")
	if abil ~= nil then
	damage = self:GetCaster():GetHealth()
	ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION })
	end
end

function modifier_arc_flux_lua_debuff:OnRefresh( kv )	
end

function modifier_arc_flux_lua_debuff:OnRemoved()
end

function modifier_arc_flux_lua_debuff:OnDestroy()
end

function modifier_arc_flux_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		
	}

	return funcs
end

function modifier_arc_flux_lua_debuff:GetModifierIncomingDamage_Percentage()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_agi8")
	if abil ~= nil then
	return 25
	else
	return 0
	end	
end

function modifier_arc_flux_lua_debuff:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end

function modifier_arc_flux_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end