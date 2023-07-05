-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_huskar_berserkers_blood_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_berserkers_blood_lua:IsHidden()
	return true
end

function modifier_huskar_berserkers_blood_lua:IsDebuff()
	return false
end

function modifier_huskar_berserkers_blood_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_huskar_berserkers_blood_lua:OnCreated( kv )
	-- references
	self.max_as = self:GetAbility():GetSpecialValueFor( "maximum_attack_speed" )
	self.max_mr = self:GetAbility():GetSpecialValueFor( "maximum_resistance" )
	self.max_hr = self:GetAbility():GetSpecialValueFor( "maximum_regen" )
	self.max_sr = self:GetAbility():GetSpecialValueFor( "maximum_status_resistance" )
	self.max_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )
	self.range = 100-self.max_threshold
	self.max_size = 35

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi6") then
		self.max_as = self.max_as + 120
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str7") then 
		self.max_mr = self.max_mr + 20
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str9") then
		self.max_threshold = 30
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str10") then
		self.max_hr = self.max_hr * 2
	end
	-- effects
	self:PlayEffects()
end

function modifier_huskar_berserkers_blood_lua:OnRefresh( kv )
	-- references
	self.max_as = self:GetAbility():GetSpecialValueFor( "maximum_attack_speed" )
	self.max_mr = self:GetAbility():GetSpecialValueFor( "maximum_resistance" )
	self.max_hr = self:GetAbility():GetSpecialValueFor( "maximum_regen" )
	self.max_sr = self:GetAbility():GetSpecialValueFor( "maximum_status_resistance" )
	self.max_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )	
	self.range = 100-self.max_threshold

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi6") then
		self.max_as = self.max_as + 120
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str7") then 
		self.max_mr = self.max_mr + 20
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str9") then
		self.max_threshold = 30
	end

	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str10") then
		self.max_hr = self.max_hr * 2
	end

end

function modifier_huskar_berserkers_blood_lua:OnRemoved()
end

function modifier_huskar_berserkers_blood_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_huskar_berserkers_blood_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
	}

	return funcs
end

function modifier_huskar_berserkers_blood_lua:GetModifierStatusResistance()
	-- interpolate missing health
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_sr
end

function modifier_huskar_berserkers_blood_lua:GetModifierMagicalResistanceBonus()
	-- interpolate missing health
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_mr
end

function modifier_huskar_berserkers_blood_lua:GetModifierAttackSpeedBonus_Constant()
	-- interpolate missing health
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_as
end

function modifier_huskar_berserkers_blood_lua:GetModifierConstantHealthRegen()
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*(self:GetParent():GetStrength()/100*self.max_hr)
end

function modifier_huskar_berserkers_blood_lua:GetModifierModelScale()
	if IsServer() then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)

		-- set dynamic effects
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( (1-pct)*100,0,0 ) )

		return (1-pct)*self.max_size
	end
end


function modifier_huskar_berserkers_blood_lua:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi10") then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
		return (1-pct)*100
	end
	return 0
end

function modifier_huskar_berserkers_blood_lua:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str6") then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
		return (1-pct)*(self:GetAbility():GetLevel() * 10)
	end
    return 0
end

function modifier_huskar_berserkers_blood_lua:GetModifierIncomingDamage_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str8") then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
		return (1-pct)*-30
	end
	return 0
end

function modifier_huskar_berserkers_blood_lua:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_int8") then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
		return (1-pct)*(self:GetAbility():GetLevel() * 30)
	end
	return 0
end


function modifier_huskar_berserkers_blood_lua:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		if self:GetParent():FindAbilityByName("npc_dota_hero_huskar_str_last") and params.damage_type == DAMAGE_TYPE_PHYSICAL then
			local burning_spear = self:GetParent():FindAbilityByName("huskar_burning_spear_lua")
			if params.attacker:IsAlive() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and burning_spear and burning_spear:GetLevel() > 0 then
				EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
				params.attacker:AddNewModifier(self:GetParent(), burning_spear, "modifier_huskar_burning_spear_lua", {duration = burning_spear:GetSpecialValueFor("duration"), auto_attack = true})
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_huskar_berserkers_blood_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_berserkers_blood_glow.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

modifier_huskar_berserkers_blood_lua_bkb = class({})

function modifier_huskar_berserkers_blood_lua_bkb:IsHidden()
    return false
end

function modifier_huskar_berserkers_blood_lua_bkb:IsDebuff()
    return false
end

function modifier_huskar_berserkers_blood_lua_bkb:IsPurgable()
    return false
end

function modifier_huskar_berserkers_blood_lua_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_huskar_berserkers_blood_lua_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_huskar_berserkers_blood_lua_bkb:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_huskar_berserkers_blood_lua_bkb:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_huskar_berserkers_blood_lua_bkb:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end