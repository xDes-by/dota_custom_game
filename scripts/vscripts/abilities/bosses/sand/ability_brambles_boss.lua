ability_brambles_boss = class({})

function ability_brambles_boss:GetIntrinsicModifierName()
    return "modifier_ability_brambles_boss"
end

modifier_ability_brambles_boss = class({})

LinkLuaModifier("modifier_ability_brambles_boss", "abilities/bosses/sand/ability_brambles_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_brambles_boss_thinker", "abilities/bosses/sand/ability_brambles_boss", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_brambles_boss_root", "abilities/bosses/sand/ability_brambles_boss", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_brambles_boss:IsHidden()
    return true
end

function modifier_ability_brambles_boss:IsDebuff()
    return false
end

function modifier_ability_brambles_boss:IsPurgable()
    return false
end

function modifier_ability_brambles_boss:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_brambles_boss:IsStunDebuff()
    return false
end

function modifier_ability_brambles_boss:RemoveOnDeath()
    return false
end

function modifier_ability_brambles_boss:DestroyOnExpire()
    return false
end

function modifier_ability_brambles_boss:OnCreated()
    if not IsServer() then
        return
    end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.spawn_delay = self:GetAbility():GetSpecialValueFor("spawn_delay")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    self:StartIntervalThink(self.spawn_delay)
end

function modifier_ability_brambles_boss:OnIntervalThink()
    CreateModifierThinker(self.parent, self.ability, "modifier_ability_brambles_boss_thinker", {duration = self.duration}, self.parent:GetAbsOrigin() + RandomVector(RandomInt(300, 800)), self.parent:GetTeamNumber(), false)
end

modifier_ability_brambles_boss_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_brambles_boss_thinker:IsHidden()
	return false
end

function modifier_ability_brambles_boss_thinker:IsDebuff()
	return false
end

function modifier_ability_brambles_boss_thinker:IsStunDebuff()
	return false
end

function modifier_ability_brambles_boss_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_brambles_boss_thinker:OnCreated( kv )
	if not IsServer() then return end
	-- references
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.radius = 90
	self.root = 2
	self.damage = 10000
	local delay = 0.5
	self:StartIntervalThink( delay )
	self:PlayEffects()
end

function modifier_ability_brambles_boss_thinker:OnDestroy()
	if not IsServer() then return end
	StopSoundOn( "Hero_DarkWillow.BrambleLoop", self:GetParent() )
	EmitSoundOn( "Hero_DarkWillow.Bramble.Destroy", self:GetParent() )
	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_brambles_boss_thinker:OnIntervalThink()
	if not self.caster or not self.ability or self.caster:IsNull() or not self.caster:IsAlive() then
		self:Destroy()
		return
	end
	if not self.delay then
		self.delay = true

		-- start search interval
		local interval = 0.03
		self:StartIntervalThink( interval )
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local target = nil
	for _,enemy in pairs(enemies) do
		-- find the first occurence
		target = enemy
		break
	end
	if not target then return end

	target:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_ability_brambles_boss_root",{duration = self.root,damage = self.damage,})

	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_brambles_boss_thinker:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/boses/sand_boss/sand_boss_bramble_main.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	self:AddParticle(effect_cast,false,false, -1,false,false)

	-- EmitSoundOn( "Hero_DarkWillow.Bramble.Spawn", self:GetParent() )
	EmitSoundOn( "Hero_DarkWillow.BrambleLoop", self:GetParent() )
end

modifier_ability_brambles_boss_root = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_brambles_boss_root:IsHidden()
	return false
end

function modifier_ability_brambles_boss_root:IsDebuff()
	return true
end

function modifier_ability_brambles_boss_root:IsStunDebuff()
	return false
end

function modifier_ability_brambles_boss_root:IsPurgable()
	return true
end

function modifier_ability_brambles_boss_root:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_brambles_boss_root:OnCreated( kv )

	if not IsServer() then return end
	-- references
	local duration = kv.duration
	local damage = kv.damage
	local interval = 0.5

	local instances = duration/interval
	local dps = damage/instances

	self:StartIntervalThink( interval )
    self:OnIntervalThink()
	EmitSoundOn( "Hero_DarkWillow.Bramble.Target", self:GetParent() )
	EmitSoundOn( "Hero_DarkWillow.Bramble.Target.Layer", self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ability_brambles_boss_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_brambles_boss_root:OnIntervalThink()
	ApplyDamage({
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = dps,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	})
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_brambles_boss_root:GetEffectName()
	return "particles/boses/sand_boss/sand_boss_bramble_status.vpcf"
end

function modifier_ability_brambles_boss_root:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end