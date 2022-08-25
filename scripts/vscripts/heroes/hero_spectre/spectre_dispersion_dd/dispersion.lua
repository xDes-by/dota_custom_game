LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_dd/dispersion.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_debuff_disp", "heroes/hero_spectre/spectre_dispersion_dd/dispersion", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_dispersion_pulse_lua", "heroes/hero_spectre/spectre_dispersion_dd/dispersion.lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_dispersion_pulse_dmg_lua", "heroes/hero_spectre/spectre_dispersion_dd/dispersion.lua" ,LUA_MODIFIER_MOTION_NONE )

spectre_dispersion_dd = class({})

modifier_spectre_dispersion_pulse_lua = {}
modifier_spectre_dispersion_lua = {}

function spectre_dispersion_dd:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

function spectre_dispersion_dd:OnToggle()
    if self:GetToggleState() then
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_spectre_dispersion_pulse_lua", nil)
		self:GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):StartIntervalThink(1)
    else
        self:GetCaster():RemoveModifierByName("modifier_spectre_dispersion_pulse_lua")
		self:GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):StartIntervalThink(-1)
    end
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int10") ~= nil then
	    dmg = math.floor(self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):GetStackCount() * 0.1)
    else
        dmg = math.floor(self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):GetStackCount() * 0.05)
    end
	self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):SetStackCount(self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):GetStackCount() - dmg)
end

--------------------------------------------------------------------------------
function modifier_spectre_dispersion_lua:DeclareFunctions()
    return {MODIFIER_EVENT_ON_TAKEDAMAGE, 
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE }
end

function modifier_spectre_dispersion_lua:OnTakeDamage(params)
    if self:GetStackCount() > self:GetAbility():GetSpecialValueFor("max_stack_dmg") then 
        self:SetStackCount(self:GetAbility():GetSpecialValueFor("max_stack_dmg"))
    end
	if params.unit == self:GetParent() and self:GetParent():FindModifierByName("modifier_spectre_dispersion_pulse_lua") == nil then
		if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
			
		self:SetStackCount(self:GetStackCount() + math.floor(params.damage * 0.05))
	end
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str_last") ~= nil then
        return self:GetAbility():GetSpecialValueFor("damage_reflection_pct") * -1 * 5
    end
    if self:GetParent():FindModifierByName("modifier_spectre_dispersion_pulse_lua") == nil then
        return self:GetAbility():GetSpecialValueFor("damage_reflection_pct") * -1
    else
        return 0
    end
end

function modifier_spectre_dispersion_pulse_lua:IsDebuff()			
	return false 
end

function modifier_spectre_dispersion_pulse_lua:IsHidden() 			
	return false 
end

function modifier_spectre_dispersion_pulse_lua:IsPurgable() 			
	return false 
end

function modifier_spectre_dispersion_pulse_lua:IsPurgeException() 	
	return false 
end

function modifier_spectre_dispersion_pulse_lua:IsAura() 
	return true 
end

function modifier_spectre_dispersion_pulse_lua:GetModifierAura() 
	return "modifier_spectre_dispersion_pulse_dmg_lua" 
end

function modifier_spectre_dispersion_pulse_lua:GetAuraRadius() 
	return 700
end

function modifier_spectre_dispersion_pulse_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_spectre_dispersion_pulse_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_spectre_dispersion_pulse_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC 
end

function modifier_spectre_dispersion_pulse_lua:OnDestroy()
	if IsServer() then
		if self:GetAbility():GetToggleState() then
			self:GetAbility():ToggleAbility()
		end
	end
end

modifier_spectre_dispersion_pulse_dmg_lua = class({})

function modifier_spectre_dispersion_pulse_dmg_lua:IsDebuff()			
	return true 
end

function modifier_spectre_dispersion_pulse_dmg_lua:IsHidden() 			
	return false 
end

function modifier_spectre_dispersion_pulse_dmg_lua:IsPurgable() 		
	return false 
end

function modifier_spectre_dispersion_pulse_dmg_lua:IsPurgeException() 	
	return false 
end

function modifier_spectre_dispersion_pulse_dmg_lua:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_spectre_dispersion_pulse_dmg_lua:OnIntervalThink()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int10") ~= nil then
	    dmg = math.floor(self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):GetStackCount() * 0.1)
    else
        dmg = math.floor(self:GetAbility():GetCaster():FindModifierByName("modifier_spectre_dispersion_lua"):GetStackCount() * 0.05)
    end
    local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int11")             
    if abil ~= nil then 
    self:GetParent():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_debuff_disp",{ duration = 1 })
    end
	local damageTable = {
						victim = self:GetParent(),
						attacker = self:GetCaster(),
						damage = dmg,
						damage_type = DAMAGE_TYPE_MAGICAL,
						damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
						ability = self:GetAbility(), --Optional.
						}
	ApplyDamage(damageTable)
end

modifier_debuff_disp = class({})

function modifier_debuff_disp:IsHidden()
	return true
end

function modifier_debuff_disp:IsDebuff()
	return false
end

function modifier_debuff_disp:IsPurgable()
	return false
end

function modifier_debuff_disp:OnCreated( kv )

end

function modifier_debuff_disp:OnRefresh( kv )

end

function modifier_debuff_disp:OnIntervalThink()

end


function modifier_debuff_disp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_debuff_disp:GetModifierMagicalResistanceBonus()
	return -15
end