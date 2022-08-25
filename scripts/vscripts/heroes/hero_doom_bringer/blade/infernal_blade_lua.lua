ability_infernal_blade_lua = class({})

LinkLuaModifier( "modifier_ability_infernal_blade_attack", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_infernal_blade_stun", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_infernal_blade_lua", 'heroes/hero_doom_bringer/blade/infernal_blade_lua.lua', LUA_MODIFIER_MOTION_NONE )

function ability_infernal_blade_lua:GetIntrinsicModifierName()
	return "modifier_ability_infernal_blade_lua"
end

modifier_ability_infernal_blade_lua = class({})

modifier_ability_infernal_blade_attack = class({})

modifier_ability_infernal_blade_stun = class({})

function modifier_ability_infernal_blade_lua:RemoveOnDeath()
	return false
end

function modifier_ability_infernal_blade_lua:IsHidden()
	return true
end

function modifier_ability_infernal_blade_lua:IsDebuff()
	return false
end

function modifier_ability_infernal_blade_lua:IsPurgable()
	return false
end

function modifier_ability_infernal_blade_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_ability_infernal_blade_lua:OnAttackLanded(keys)
	if self:GetCaster():HasModifier("modifier_ability_infernal_blade_lua") and keys.attacker == self:GetParent() and not keys.target:IsBuilding() and not keys.target:IsOther() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetAbility():IsCooldownReady() then
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_infernal_blade_attack",  {duration = 5})
			keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_infernal_blade_stun",  {duration = 0.6})
		local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_infernal_blade_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,keys.target)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_DoomBringer.InfernalBlade.Target", self:GetParent() )
	self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(self:GetAbility():GetLevel()))
	end
end

function modifier_ability_infernal_blade_attack:IsHidden()
	return false
end

function modifier_ability_infernal_blade_attack:IsDebuff()
	return true
end

function modifier_ability_infernal_blade_attack:IsStunDebuff()
	return false
end

function modifier_ability_infernal_blade_attack:IsPurgable()
	return true
end

function modifier_ability_infernal_blade_attack:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" ) 

	self.damageTable_base = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	self.damageTable_pct = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		--damage = ,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	self:StartIntervalThink( 1 )

end

function modifier_ability_infernal_blade_attack:OnIntervalThink()
	if IsServer()then
		self.damageTable_pct.damage = self:GetParent():GetHealth()/100*1.5
		ApplyDamage( self.damageTable_base )
		ApplyDamage( self.damageTable_pct )
	end
end

function modifier_ability_infernal_blade_stun:IsDebuff()
	return true
end

function modifier_ability_infernal_blade_stun:IsStunDebuff()
	return true
end

function modifier_ability_infernal_blade_stun:IsPurgable()
	return true
end

function modifier_ability_infernal_blade_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end

function modifier_ability_infernal_blade_stun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_ability_infernal_blade_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_ability_infernal_blade_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_ability_infernal_blade_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end