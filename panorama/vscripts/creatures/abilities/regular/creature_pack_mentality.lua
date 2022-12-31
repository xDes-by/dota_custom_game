LinkLuaModifier("modifier_creature_pack_mentality", "creatures/abilities/regular/creature_pack_mentality", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_pack_mentality_buff", "creatures/abilities/regular/creature_pack_mentality", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_pack_mentality_buff_counter", "creatures/abilities/regular/creature_pack_mentality", LUA_MODIFIER_MOTION_NONE)

creature_pack_mentality = class({})

function creature_pack_mentality:GetIntrinsicModifierName()
	return "modifier_creature_pack_mentality"
end



modifier_creature_pack_mentality = class({})

function modifier_creature_pack_mentality:IsHidden() return true end
function modifier_creature_pack_mentality:IsDebuff() return false end
function modifier_creature_pack_mentality:IsPurgable() return false end
function modifier_creature_pack_mentality:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_pack_mentality:RemoveOnDeath() return false end

function modifier_creature_pack_mentality:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_creature_pack_mentality:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() then
			keys.unit:EmitSound("CreaturePack.Death")
			local ability = self:GetAbility()
			local allies = FindUnitsInRadius(keys.unit:GetTeam(), keys.unit:GetAbsOrigin(), nil, ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, ally in pairs(allies) do
				ally:AddNewModifier(keys.unit, ability, "modifier_creature_pack_mentality_buff", {attack_speed = ability:GetSpecialValueFor("bonus_as")})
			end
		end
	end
end



modifier_creature_pack_mentality_buff = class({})

function modifier_creature_pack_mentality_buff:IsHidden() return true end
function modifier_creature_pack_mentality_buff:IsDebuff() return false end
function modifier_creature_pack_mentality_buff:IsPurgable() return false end
function modifier_creature_pack_mentality_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_pack_mentality_buff:GetEffectName()
	return "particles/creature/frenzy.vpcf"
end

function modifier_creature_pack_mentality_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_pack_mentality_buff:OnCreated(keys)
	if IsServer() then
		self.attack_speed = keys.attack_speed

		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_creature_pack_mentality_buff_counter", {}):IncrementStackCount()
	end
end

function modifier_creature_pack_mentality_buff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_creature_pack_mentality_buff_counter") then
			local modifier_counter = parent:FindModifierByName("modifier_creature_pack_mentality_buff_counter")
			modifier_counter:DecrementStackCount()
			if modifier_counter:GetStackCount() <= 0 then
				parent:RemoveModifierByName("modifier_creature_pack_mentality_buff_counter")
			end
		end
	end
end

function modifier_creature_pack_mentality_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_creature_pack_mentality_buff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end



modifier_creature_pack_mentality_buff_counter = class({})

function modifier_creature_pack_mentality_buff_counter:IsHidden() return false end
function modifier_creature_pack_mentality_buff_counter:IsDebuff() return false end
function modifier_creature_pack_mentality_buff_counter:IsPurgable() return false end

function modifier_creature_pack_mentality_buff_counter:GetTexture()
	return "beastmaster_inner_beast"
end
