LinkLuaModifier( "modifier_ursa_lapki", "abilities/ursa_lapki", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_ursa_lapki_effect", "abilities/ursa_lapki", LUA_MODIFIER_MOTION_HORIZONTAL )

ursa_lapki = class({})

function ursa_lapki:GetIntrinsicModifierName()
	return "modifier_ursa_lapki"
end

-----------------------------------------------------------------------------------------------------

modifier_ursa_lapki = class({})

function modifier_ursa_lapki:IsHidden( kv )
	return true
end

function modifier_ursa_lapki:IsDebuff( kv )
	return false
end

function modifier_ursa_lapki:IsPurgable( kv )
	return false
end

function modifier_ursa_lapki:RemoveOnDeath( kv )
	return false
end

function modifier_ursa_lapki:OnCreated( kv )
	if not IsServer() then
		return
	end
    self.hp_percent = self:GetAbility():GetSpecialValueFor("hp_percent")
    self.base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
end


function modifier_ursa_lapki:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
	return funcs
end


function modifier_ursa_lapki:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		local stack = 0
		local modifier = target:FindModifierByName("modifier_ursa_lapki_effect")

		if modifier == nil then
			target:AddNewModifier( self:GetAbility():GetCaster(), self:GetAbility(), "modifier_ursa_lapki_effect", { duration = 15})
			stack = 1
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()
			stack = modifier:GetStackCount()
		end	
		return stack * self.base_damage + (target:GetMaxHealth()/100 * stack * self.hp_percent)
	end
end

--------------------------------------------------------------------------------

modifier_ursa_lapki_effect = class({})

function modifier_ursa_lapki_effect:IsHidden()
	return false
end

function modifier_ursa_lapki_effect:IsDebuff()
	return true
end

function modifier_ursa_lapki_effect:IsPurgable()
	return false
end

function modifier_ursa_lapki_effect:GetAttributes()	
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_ursa_lapki_effect:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_ursa_lapki_effect:OnRefresh( kv )
end

function modifier_ursa_lapki_effect:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_ursa_lapki_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
