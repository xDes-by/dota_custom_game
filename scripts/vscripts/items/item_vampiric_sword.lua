item_vampiric_sword = item_vampiric_sword or class({})
item_vampiric_sword2 = item_vampiric_sword or class({})
item_vampiric_sword3 = item_vampiric_sword or class({})
item_vampiric_sword4 = item_vampiric_sword or class({})
item_vampiric_sword5 = item_vampiric_sword or class({})
item_vampiric_sword6 = item_vampiric_sword or class({})
item_vampiric_sword7 = item_vampiric_sword or class({})

LinkLuaModifier("modifier_item_vampiric_sword_passive", 'items/item_vampiric_sword.lua', LUA_MODIFIER_MOTION_NONE)

function item_vampiric_sword:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword2:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword3:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword4:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword5:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword6:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

function item_vampiric_sword7:GetIntrinsicModifierName()
	return "modifier_item_vampiric_sword_passive"
end

-----------------------------------------------------------------------------------------------

modifier_item_vampiric_sword_passive = class({})

function modifier_item_vampiric_sword_passive:IsHidden()
	return true
end

function modifier_item_vampiric_sword_passive:IsPurgable()
	return false
end

function modifier_item_vampiric_sword_passive:DestroyOnExpire()
	return false
end

function modifier_item_vampiric_sword_passive:OnCreated( kv )
    self.bonus_lifesteal = self:GetAbility():GetSpecialValueFor("bonus_lifesteal")
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
    self.bonus_dmg = self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_item_vampiric_sword_passive:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_vampiric_sword_passive:DeclareFunctions()
	local funcs = {       
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,        
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,    
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,		
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_vampiric_sword_passive:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end

function modifier_item_vampiric_sword_passive:GetModifierBaseAttack_BonusDamage( params )
	return self.bonus_dmg
end

function modifier_item_vampiric_sword_passive:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end

		if pass then
			self.attack_record = params.record
		end
	end
end

function modifier_item_vampiric_sword_passive:OnTakeDamage( params )
	if IsServer() then
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			local heal = params.damage * self.bonus_lifesteal/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects( self:GetParent() )
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_item_vampiric_sword_passive:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end