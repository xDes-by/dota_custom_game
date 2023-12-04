modifier_leshrac_pulse_nova_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_leshrac_pulse_nova_lua:IsHidden()
	return false
end

function modifier_leshrac_pulse_nova_lua:IsDebuff()
	return false
end

function modifier_leshrac_pulse_nova_lua:IsPurgable()
	return false
end

function modifier_leshrac_pulse_nova_lua:IsAura() 
	return true 
end

function modifier_leshrac_pulse_nova_lua:GetModifierAura() 
	return "modifier_leshrac_pulse_nova_burn_lua" 
end

function modifier_leshrac_pulse_nova_lua:GetAuraRadius()
	return self.radius
end

function modifier_leshrac_pulse_nova_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_leshrac_pulse_nova_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_leshrac_pulse_nova_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

-- function modifier_leshrac_pulse_nova_lua:GetAuraDuration() 
-- 	if slef:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi6") then
-- 		return 2
-- 	end
-- 	return 0.5
-- end
-- -- 


--------------------------------------------------------------------------------
-- Initializations
function modifier_leshrac_pulse_nova_lua:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.parent = self:GetParent()
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.manacost = self:GetAbility():GetSpecialValueFor( "mana_cost_per_second" )
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	
	self:StartIntervalThink( 1 )

	-- play effects
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_pulse_nova_lua:OnRefresh( kv )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi12") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_pulse_nova_burn_lua", {duration = 2})
	end
end

function modifier_leshrac_pulse_nova_lua:OnRemoved()
end

function modifier_leshrac_pulse_nova_lua:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Leshrac.Pulse_Nova"
	StopSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_pulse_nova_lua:OnIntervalThink()
	self.parent:SpendMana( self.manacost, self:GetAbility() )
	-- check mana
	local mana = self.parent:GetMana()
	if mana < self.manacost then
		-- turn off
		if self:GetAbility():GetToggleState() then
			self:GetAbility():ToggleAbility()
		end
		return
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_leshrac_pulse_nova_lua:GetEffectName()
	return "particles/units/heroes/hero_leshrac/leshrac_pulse_nova_ambient.vpcf"
end

function modifier_leshrac_pulse_nova_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_leshrac_pulse_nova_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_leshrac_pulse_nova_lua:GetModifierIncomingDamage_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_str7") then
		return -30
	end
end