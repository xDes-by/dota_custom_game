modifier_sven_gods_strength_lua = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:StatusEffectPriority()
	return 1000
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:HeroEffectPriority()
	return 100
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:IsAura()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int10")
	if abil ~= nil then 
	return true
	end
	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetModifierAura()
	return "modifier_sven_gods_strength_child_lua"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraRadius()
	return self.scepter_aoe
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		if self:GetParent() == hEntity then
			return true
		end
	end

	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:OnCreated( kv )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi10")
	if abil ~= nil then
		self.gods_strength_damage = self.gods_strength_damage + 150
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_int_last")
	if abil ~= nil then
		self.gods_strength_damage = self.gods_strength_damage + 400
	end
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" )

	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
		ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
		self:AddParticle( nFXIndex, false, false, -1, false, true )
	end
	
	str = 0
	income = 0
	mnoj = 0
	str = math.floor(self:GetAbility():GetCaster():GetStrength())
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str7")
	if abil ~= nil then
	mnoj = mnoj + 0.4
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str_last")
	if abil ~= nil then
	mnoj = mnoj + 1
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_str10")
	if abil ~= nil then
	income = -25
	end
	str = self:GetAbility():GetCaster():GetStrength() * mnoj
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:OnRefresh( kv )
	self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "gods_strength_damage" )
	self.scepter_aoe = self:GetAbility():GetSpecialValueFor( "scepter_aoe" )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_gods_strength_lua:GetModifierBaseDamageOutgoing_Percentage()
	return self.gods_strength_damage
end

--------------------------------------------------------------------------------
function modifier_sven_gods_strength_lua:GetModifierBonusStats_Strength()
return str
end
--------------------------------------------------------------------------------
function modifier_sven_gods_strength_lua:GetModifierIncomingDamage_Percentage()
return income
end
