ability_crystal_boss_frost_bite = class({})

LinkLuaModifier( "modifier_ability_crystal_boss_frost_bite", "abilities/bosses/crystal/ability_crystal_boss_frost_bite", LUA_MODIFIER_MOTION_NONE )

function ability_crystal_boss_frost_bite:OnSpellStart()
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_ability_crystal_boss_frost_bite", {duration = 10})
end

modifier_ability_crystal_boss_frost_bite = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_crystal_boss_frost_bite:IsHidden()
	return false
end

function modifier_ability_crystal_boss_frost_bite:IsDebuff()
	return true
end

function modifier_ability_crystal_boss_frost_bite:IsStunDebuff()
	return false
end

function modifier_ability_crystal_boss_frost_bite:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_crystal_boss_frost_bite:OnCreated( kv )
	-- references
	local tick_damage = self:GetParent():GetLevel() * 20
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_ability_crystal_boss_frost_bite:OnRefresh( kv )
	-- references
	local tick_damage = self:GetParent():GetLevel() * 20
	self.interval = 0.1

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_ability_crystal_boss_frost_bite:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
    if not IsServer() then
        return
    end
    self:GetCaster():CastAbilityOnPosition(self:GetParent():GetOrigin(), self:GetCaster():FindAbilityByName("tusk_snowball_meteor"), -1)
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ability_crystal_boss_frost_bite:CheckState()
	return {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_INVISIBLE] = false,
	}
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_crystal_boss_frost_bite:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_crystal_boss_frost_bite:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_ability_crystal_boss_frost_bite:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end