shapeshifter_ability2 = {}

LinkLuaModifier( "modifier_shapeshifter_ability2", "abilities/bosses/shapeshifter/shapeshifter_ability2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_shapeshifter_ability2_debuff", "abilities/bosses/shapeshifter/shapeshifter_ability2", LUA_MODIFIER_MOTION_NONE )

function shapeshifter_ability2:GetIntrinsicModifierName()
	return "modifier_shapeshifter_ability2"
end

modifier_shapeshifter_ability2 = {}

function modifier_shapeshifter_ability2:IsHidden()
	return true
end

function modifier_shapeshifter_ability2:IsDebuff()
	return false
end

function modifier_shapeshifter_ability2:IsPurgable()
	return false
end

function modifier_shapeshifter_ability2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
end

function modifier_shapeshifter_ability2:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_shapeshifter_ability2_debuff", self:GetAbility():GetCaster())

		if modifier==nil then
			if not self:GetParent():PassivesDisabled() then
				local duration = self:GetAbility():GetSpecialValueFor("bonus_reset_time")

				if params.target:GetUnitName()=="npc_dota_roshan" then
					duration = self:GetAbility():GetSpecialValueFor("bonus_reset_time_roshan")
				end

				target:AddNewModifier(
					self:GetAbility():GetCaster(),
					self:GetAbility(),
					"modifier_shapeshifter_ability2_debuff",
					{ duration = duration }
				)

				stack = 1
			end
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()

			stack = modifier:GetStackCount()
		end

		return stack * self:GetAbility():GetSpecialValueFor("damage_per_stack")
	end
end

modifier_shapeshifter_ability2_debuff = {}

function modifier_shapeshifter_ability2_debuff:IsHidden()
	return false
end

function modifier_shapeshifter_ability2_debuff:IsDebuff()
	return true
end

function modifier_shapeshifter_ability2_debuff:IsPurgable()
	return false
end

function modifier_shapeshifter_ability2_debuff:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_shapeshifter_ability2_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_shapeshifter_ability2_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end