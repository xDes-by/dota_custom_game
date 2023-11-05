doom_ulti_lua = {}

LinkLuaModifier( "doom_ulti_think_lua", 'heroes/hero_doom_bringer/ulti/ulti.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "doom_ulti_burn_lua", 'heroes/hero_doom_bringer/ulti/ulti.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ulti_intrinsic_lua", 'heroes/hero_doom_bringer/ulti/modifier_ulti_intrinsic_lua.lua', LUA_MODIFIER_MOTION_NONE )

doom_ulti_think_lua = {}

doom_ulti_burn_lua = {}
function doom_ulti_lua:GetIntrinsicModifierName()
	return "modifier_ulti_intrinsic_lua"
end
function doom_ulti_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end
function doom_ulti_lua:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "doom_ulti_think_lua", { duration = self:GetSpecialValueFor("duration") })

    -- StartAnimation(self:GetCaster(), {duration = 5, activity = ACT_DOTA_CHANNEL_ABILITY_4})
end

function doom_ulti_think_lua:RemoveOnDeath()
	return false
end

function doom_ulti_think_lua:IsHidden()
	return false
end

function doom_ulti_think_lua:IsPurgable()
	return false
end

function doom_ulti_think_lua:OnCreated()
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_doom_bringer/doom_bringer_doom_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- ParticleManager:SetParticleControlEnt(self.effect_cast,1,self:GetCaster(),PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0), true)
    EmitSoundOn( "Hero_DoomBringer.Doom", self:GetCaster() )
end

function doom_ulti_think_lua:OnDestroy()
    ParticleManager:DestroyParticle( self.effect_cast, false )
end

function doom_ulti_think_lua:IsAura()
	return true
end

function doom_ulti_think_lua:GetAuraRadius()
	return 300
end

function doom_ulti_think_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function doom_ulti_think_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function doom_ulti_think_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function doom_ulti_think_lua:GetModifierAura()
	return "doom_ulti_burn_lua"
end

function doom_ulti_burn_lua:RemoveOnDeath()
	return false
end

function doom_ulti_burn_lua:IsHidden()
	return false
end

function doom_ulti_burn_lua:IsDebuff()
	return true
end

function doom_ulti_burn_lua:IsPurgable()
	return false
end

function doom_ulti_burn_lua:OnCreated()
	local stacks = self:GetCaster():GetModifierStackCount("modifier_devour_intrinsic_lua", self:GetCaster())
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int6") then
		stacks = stacks * 1.5
	end
    local damage = stacks * (self:GetAbility():GetSpecialValueFor("damage_per_soul"))
	self.interval = 0.2
    self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage * self.interval,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}
    
    ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf", PATTACH_ABSORIGIN, enemy)
	if not IsServer() then return end
	self:StartIntervalThink(self.interval)
end

function doom_ulti_burn_lua:OnIntervalThink()
    ApplyDamage(self.damageTable)
end

function doom_ulti_burn_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function doom_ulti_burn_lua:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str6") then
		return -20
	end
end
function doom_ulti_burn_lua:GetModifierIncomingDamage_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int9") then
		return 20
	end
end
