-------------------------------------------
--		  HEARTSTOPPER AURA
-------------------------------------------

LinkLuaModifier("modifier_imba_heartstopper_aura", "heroes/hero_necrolyte/necrolyte_heartstopper_aura/necrolyte_heartstopper_aura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_heartstopper_aura_damage", "heroes/hero_necrolyte/necrolyte_heartstopper_aura/necrolyte_heartstopper_aura", LUA_MODIFIER_MOTION_NONE)

imba_necrolyte_heartstopper_aura = imba_necrolyte_heartstopper_aura or class({})
function imba_necrolyte_heartstopper_aura:GetIntrinsicModifierName()
	return "modifier_imba_heartstopper_aura"
end

function imba_necrolyte_heartstopper_aura:GetAbilityTextureName()
	return "necrolyte_heartstopper_aura"
end

function imba_necrolyte_heartstopper_aura:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end

modifier_imba_heartstopper_aura = class({})

function modifier_imba_heartstopper_aura:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_imba_heartstopper_aura:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

function modifier_imba_heartstopper_aura:GetAuraEntityReject(target)
	return false
end

function modifier_imba_heartstopper_aura:GetAuraRadius()
	return self.radius
end

function modifier_imba_heartstopper_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_imba_heartstopper_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_imba_heartstopper_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_heartstopper_aura:GetModifierAura()
	return "modifier_imba_heartstopper_aura_damage"
end

function modifier_imba_heartstopper_aura:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_imba_heartstopper_aura:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_imba_heartstopper_aura:IsHidden()
	return true
end

function modifier_imba_heartstopper_aura:GetEffectName()
	return "particles/auras/aura_heartstopper.vpcf"
end

function modifier_imba_heartstopper_aura:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

modifier_imba_heartstopper_aura_damage = modifier_imba_heartstopper_aura_damage or class({})


function modifier_imba_heartstopper_aura_damage:IsHidden()
	if self:GetStackCount() == 0 then
		return true
	end
end

function modifier_imba_heartstopper_aura_damage:IsDebuff()
	return true
end

function modifier_imba_heartstopper_aura_damage:IsPurgable()
	return false
end

function modifier_imba_heartstopper_aura_damage:OnCreated()
	if IsServer() then
		self.parent	= self:GetParent()
	
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
		self.tick_rate	= self:GetAbility():GetSpecialValueFor("tick_rate")
		self.scepter_multiplier	= self:GetAbility():GetSpecialValueFor("scepter_multiplier")
		
		if self:GetParent():CanEntityBeSeenByMyTeam(self:GetCaster()) then
			self:SetStackCount(self:GetAbility():GetSpecialValueFor("heal_reduce_pct"))
		end
		
		if not self.timer then
			self:StartIntervalThink(self.tick_rate)
			self.timer = true
		end
	end
end

function modifier_imba_heartstopper_aura_damage:OnIntervalThink()
	if IsServer() then
		local caster = self:GetCaster()
		
		-- Jank way of hiding modifier if the caster is invisible (client/server issues...as usual)
		if self:GetParent():CanEntityBeSeenByMyTeam(caster) then
			self:SetStackCount(self:GetAbility():GetSpecialValueFor("heal_reduce_pct"))
		else
			self:SetStackCount(0)
		end
		
		if not caster:PassivesDisabled() then
			-- Calculates damage
			local damage = self.parent:GetMaxHealth() * (self.damage_pct * self.tick_rate) / 100
			
			if caster:HasModifier("modifier_imba_ghost_shroud_active") then
				damage = damage * self.scepter_multiplier
			end
			
			ApplyDamage({attacker = caster, victim = self.parent, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
			
			if (math.random(1,1000) <= 1) and (caster:GetName() == "npc_dota_hero_necrolyte") then
				caster:EmitSound("necrolyte_necr_ability_aura_0"..math.random(1,3))
			end
			
			
		end
	end
end


function modifier_imba_heartstopper_aura_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}
end

function modifier_imba_heartstopper_aura_damage:GetModifierHPRegenAmplify_Percentage()
	if self:GetAbility() ~= nil then
		return ( self:GetAbility():GetSpecialValueFor("heal_reduce_pct") * (-1) )
	end
end