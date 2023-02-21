LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell2", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell2", LUA_MODIFIER_MOTION_NONE )

ability_npc_boss_plague_squirrel_spell2 = class({})

function ability_npc_boss_plague_squirrel_spell2:OnSpellStart()

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell2", { duration = 5 } )
end

-------------------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell2 = class({})

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
    self.reflect = self:GetAbility():GetSpecialValueFor("reflect")
	self.pfx = ParticleManager:CreateParticle("particles/econ/items/spectre/spectre_arcana/spectre_arcana_blademail_v2.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
    EmitSoundOn("DOTA_Item.BladeMail.Activate", self:GetCaster())
end

function modifier_ability_npc_boss_plague_squirrel_spell2:OnDestroy()
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)
    EmitSoundOn("DOTA_Item.BladeMail.Deactivate", self:GetCaster())
end

function modifier_ability_npc_boss_plague_squirrel_spell2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_ability_npc_boss_plague_squirrel_spell2:GetModifierIncomingDamage_Percentage(params)
	local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy,
        damage = params.damage/100*self.reflect,
        damage_type = params.damage_type,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        attacker = self:GetCaster()
		})
	end
	return -self.reflect
end