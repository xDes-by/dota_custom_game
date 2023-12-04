dragon_2_skill = class({})

LinkLuaModifier( "modifier_dragon", "heroes/hero_dragon/dragon_2_skill/dragon_2_skill", LUA_MODIFIER_MOTION_NONE )

function dragon_2_skill:GetIntrinsicModifierName()
	return "modifier_dragon"
end

----------------------------------------------
LinkLuaModifier( "modifier_dragon_2_skill", "heroes/hero_dragon/dragon_2_skill/dragon_2_skill", LUA_MODIFIER_MOTION_NONE )

modifier_dragon = class({})

function modifier_dragon:IsHidden()
	return true
end

function modifier_dragon:IsPurgable()
	return false
end

function modifier_dragon:OnCreated( kv )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_dragon:OnRefresh( kv )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_dragon:OnDestroy( kv )

end

function modifier_dragon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_dragon:GetModifierProcAttack_Feedback( params )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi11") ~= nil and self:GetCaster():HasModifier("modifier_dragon_form_lua") then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _, enemy in pairs(enemies) do
			if params.target ~= enemy then
				enemy:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_dragon_2_skill",{ duration = self.duration, res = 0.5 })
			end
		end
	end
	params.target:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_dragon_2_skill",{ duration = self.duration, res = 1 })
end


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

modifier_dragon_2_skill = class({})

function modifier_dragon_2_skill:IsHidden()
	return false
end

function modifier_dragon_2_skill:IsDebuff()
	return true
end

function modifier_dragon_2_skill:IsStunDebuff()
	return false
end

function modifier_dragon_2_skill:IsPurgable()
	return false
end

function modifier_dragon_2_skill:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if not IsServer() then return end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor( "mag_resist" ) * kv.res)

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int7")	
	if abil ~= nil then
	damage = self:GetCaster():GetIntellect()
	end

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	self:StartIntervalThink( 0.5 )
end

function modifier_dragon_2_skill:OnRefresh( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	if not IsServer() then return end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor( "mag_resist" ) * kv.res)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int7")	
	if abil ~= nil then
	damage = self:GetCaster():GetIntellect()
	end
	
	self.damageTable.damage = damage	
end

function modifier_dragon_2_skill:OnRemoved()
end

function modifier_dragon_2_skill:OnDestroy()
end

function modifier_dragon_2_skill:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_dragon_2_skill:GetModifierMagicalResistanceBonus()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int10")	
	if abil ~= nil then 
	return self:GetStackCount() * 2
	end
	return self:GetStackCount()
end

function modifier_dragon_2_skill:GetModifierPhysicalArmorBonus()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi8")	
	if abil ~= nil then 
	return self:GetStackCount()/2
	end
	return 0
end

function modifier_dragon_2_skill:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_dragon_2_skill:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_dragon_2_skill:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end