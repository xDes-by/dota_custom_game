boss_ursa_fury_swipes_lua = class({})
LinkLuaModifier( "modifier_boss_ursa_fury_swipes_lua", "abilities/bosses/line/boss_1/boss_ursa_fury_swipes_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ursa_fury_swipes_debuff_lua", "abilities/bosses/line/boss_1/boss_ursa_fury_swipes_lua", LUA_MODIFIER_MOTION_NONE )

function boss_ursa_fury_swipes_lua:GetIntrinsicModifierName()
	return "modifier_boss_ursa_fury_swipes_lua"
end

------------------------------------------------------------------------------------------

modifier_boss_ursa_fury_swipes_lua = class({})

function modifier_boss_ursa_fury_swipes_lua:IsHidden()
	return true
end

function modifier_boss_ursa_fury_swipes_lua:IsDebuff()
	return false
end

function modifier_boss_ursa_fury_swipes_lua:IsPurgable()
	return false
end

function modifier_boss_ursa_fury_swipes_lua:OnCreated( kv )
	if IsServer() then
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	end
end

function modifier_boss_ursa_fury_swipes_lua:OnRefresh( kv )
	if IsServer() then
		self.bonus_reset_time = self:GetAbility():GetSpecialValueFor("bonus_reset_time")
		self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	end
end

function modifier_boss_ursa_fury_swipes_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}

	return funcs
end

function modifier_boss_ursa_fury_swipes_lua:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		local target = params.target if target==nil then target = params.unit end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end

		local stack = 0
		local modifier = target:FindModifierByNameAndCaster("modifier_ursa_fury_swipes_debuff_lua", nil)

		if modifier == nil then
			if not self:GetParent():PassivesDisabled() then
				target:AddNewModifier(
					self:GetAbility():GetCaster(),
					self:GetAbility(),
					"modifier_ursa_fury_swipes_debuff_lua",
					{ duration = self:GetAbility():GetSpecialValueFor("bonus_reset_time") }
				)

				stack = 1
			end
		else
			modifier:IncrementStackCount()
			modifier:ForceRefresh()

			stack = modifier:GetStackCount()
		end
		
		if self:GetAbility():GetCaster():IsAncient() then
			self.damage_per_stack = 4
		end
		
		damage = target:GetMaxHealth()/100*self.damage_per_stack
		return stack * damage
	end
end

----------------------------------------------------------------
modifier_ursa_fury_swipes_debuff_lua = class({})

function modifier_ursa_fury_swipes_debuff_lua:IsHidden()
	return false
end

function modifier_ursa_fury_swipes_debuff_lua:IsDebuff()
	return true
end

function modifier_ursa_fury_swipes_debuff_lua:IsPurgable()
	return false
end

function modifier_ursa_fury_swipes_debuff_lua:OnCreated( kv )
	self:SetStackCount(1)
end

function modifier_ursa_fury_swipes_debuff_lua:OnRefresh( kv )
end

function modifier_ursa_fury_swipes_debuff_lua:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_ursa_fury_swipes_debuff_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end