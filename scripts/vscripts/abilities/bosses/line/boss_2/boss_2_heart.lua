LinkLuaModifier("modifier_boss_2_heart_aura", "abilities/bosses/line/boss_2/boss_2_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_2_heart_aura_damage", "abilities/bosses/line/boss_2/boss_2_heart", LUA_MODIFIER_MOTION_NONE)

boss_2_heart = class({})

function boss_2_heart:GetIntrinsicModifierName()
	return "modifier_boss_2_heart_aura"
end

function boss_2_heart:GetAbilityTextureName()
	return "necrolyte_heartstopper_aura"
end

function boss_2_heart:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

----------------------------------------------------------

modifier_boss_2_heart_aura = class({})

function modifier_boss_2_heart_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_boss_2_heart_aura:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

function modifier_boss_2_heart_aura:GetAuraEntityReject(target)
	return false
end

function modifier_boss_2_heart_aura:GetAuraRadius()
	return self.radius
end

function modifier_boss_2_heart_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_boss_2_heart_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_boss_2_heart_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_boss_2_heart_aura:GetModifierAura()
	return "modifier_boss_2_heart_aura_damage"
end

function modifier_boss_2_heart_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_boss_2_heart_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_boss_2_heart_aura:IsHidden()
	return true
end

function modifier_boss_2_heart_aura:GetEffectName()
	return "particles/auras/aura_heartstopper.vpcf"
end

function modifier_boss_2_heart_aura:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

-------------------------------------------------------------------

modifier_boss_2_heart_aura_damage = class({})


function modifier_boss_2_heart_aura_damage:IsHidden()
end

function modifier_boss_2_heart_aura_damage:IsDebuff()
	return true
end

function modifier_boss_2_heart_aura_damage:IsPurgable()
	return false
end

function modifier_boss_2_heart_aura_damage:OnCreated()
	if IsServer() then
		self.parent	= self:GetParent()
	
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
		self.tick_rate	= self:GetAbility():GetSpecialValueFor("tick_rate")
		
		if not self.timer then
			self:StartIntervalThink(self.tick_rate)
			self.timer = true
		end
	end
end

function modifier_boss_2_heart_aura_damage:OnIntervalThink()
	if IsServer() and self:GetCaster() then
		local damage = self.parent:GetMaxHealth() * (self.damage_pct * self.tick_rate) / 100
		ApplyDamage({attacker = self:GetCaster(), victim = self.parent, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
	end
end

function modifier_boss_2_heart_aura_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end

function modifier_boss_2_heart_aura_damage:GetModifierHPRegenAmplify_Percentage()
	if self:GetAbility() ~= nil then
		return ( self:GetAbility():GetSpecialValueFor("heal_reduce_pct") * (-1) )
	end
end
