ability_npc_boss_plague_squirrel_spell2 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell2", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell2", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell2:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_plague_squirrel_spell2"
end

function ability_npc_boss_plague_squirrel_spell2:OnSpellStart()
    self.mod.reflect = 100
    self.mod:StartIntervalThink(5)
    self.mod.pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail_v2.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
    EmitSoundOn("DOTA_Item.BladeMail.Activate", self:GetCaster())
end

modifier_ability_npc_boss_plague_squirrel_spell2 = class({})
--Classifications template
function modifier_ability_npc_boss_plague_squirrel_spell2:IsHidden()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell2:IsDebuff()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell2:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell2:OnCreated()
    self:GetAbility().mod = self
    self.radius = self:GetAbility():GetSpecialValueFor("radius")
    self.reflect = self:GetAbility():GetSpecialValueFor("reflect")
end

function modifier_ability_npc_boss_plague_squirrel_spell2:OnIntervalThink()
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    EmitSoundOn("DOTA_Item.BladeMail.Deactivate", self:GetCaster())
    self.reflect = self:GetAbility():GetSpecialValueFor("reflect")
    self:StartIntervalThink(-1)
end

function modifier_ability_npc_boss_plague_squirrel_spell2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell2:GetModifierIncomingDamage_Percentage(params)
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		local distance = (enemy:GetOrigin()-self:GetParent():GetOrigin()):Length2D()
		local pct = self.radius-distance * 0.01
		pct = math.min( pct, 1 )
		ApplyDamage({victim = enemy,
        damage = params.damage * pct * self.reflect/100,
        damage_type = params.damage_type,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
	end
	return -self.reflect
end