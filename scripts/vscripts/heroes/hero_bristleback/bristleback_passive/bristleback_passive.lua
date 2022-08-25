bristleback_passive = class({})
LinkLuaModifier( "modifier_bristleback_passive", "heroes/hero_bristleback/bristleback_passive/bristleback_passive.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bristleback_passive_armor", "heroes/hero_bristleback/bristleback_passive/bristleback_passive.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function bristleback_passive:GetIntrinsicModifierName()
	return "modifier_bristleback_passive"
end

modifier_bristleback_passive = class({})

--------------------------------------------------------------------------------
function modifier_bristleback_passive:IsHidden()
	return true
end

function modifier_bristleback_passive:IsPurgable()
	return false
end

function modifier_bristleback_passive:OnCreated( kv )
	self.caster = self:GetCaster()
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )
	self:StartIntervalThink(1)
end

function modifier_bristleback_passive:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.bonus_hp = self:GetAbility():GetSpecialValueFor( "bonus_hp" )
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )	

end

function modifier_bristleback_passive:OnIntervalThink()
	self:OnRefresh()
end

--------------------------------------------------------------------------------
function modifier_bristleback_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_bristleback_passive:OnDeath(params)
    local parent = self:GetParent()
    if IsMyKilledBadGuys(parent, params) then
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi10")
		if abil ~= nil then
		local ability = self:GetParent():FindAbilityByName( "bristleback_quill_spray_lua" )
		if ability~=nil and ability:IsFullyCastable() and ability:GetLevel()>=1 then
			ability:OnSpellStart()
			end
		end
	end
end


function modifier_bristleback_passive:GetModifierConstantHealthRegen()
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str9")
	if abil ~= nil then 
		self.bonus_hpr = self.bonus_hpr * 2
	end
	if not self:GetParent():PassivesDisabled() then
		return self.bonus_hpr  * self.caster:GetStrength()
	end
end

function modifier_bristleback_passive:GetModifierExtraHealthBonus()
	if not self:GetParent():PassivesDisabled() then
		return self:GetAbility():GetSpecialValueFor( "bonus_hp" ) * self.caster:GetStrength()
	end
end

function modifier_bristleback_passive:GetModifierAttackSpeedBonus_Constant()
	self.bonus_hpr = self:GetAbility():GetSpecialValueFor( "bonus_hpr" )	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str9")
	if abil ~= nil then 
		self.bonus_hpr = self.bonus_hpr * 2
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_agi6")
	if abil ~= nil then 
		if not self:GetParent():PassivesDisabled() then
			return self.bonus_hpr  * self.caster:GetStrength()
		end
		end
	return 0
end

function modifier_bristleback_passive:GetModifierConstantManaRegen()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int8")
	if abil ~= nil then 
		if not self:GetParent():PassivesDisabled() then
			return self:GetAbility():GetSpecialValueFor( "bonus_hpr" ) * self.caster:GetStrength() / 2
			end
		end
	return 0
end


function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end