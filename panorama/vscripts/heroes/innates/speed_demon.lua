innate_speed_demon = class({})

LinkLuaModifier("modifier_innate_speed_demon", "heroes/innates/speed_demon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_speed_demon_cosmetic_buff", "heroes/innates/speed_demon", LUA_MODIFIER_MOTION_NONE)

function innate_speed_demon:GetIntrinsicModifierName()
	return "modifier_innate_speed_demon"
end



modifier_innate_speed_demon = class({})

function modifier_innate_speed_demon:IsHidden() return false end
function modifier_innate_speed_demon:IsDebuff() return false end
function modifier_innate_speed_demon:IsPurgable() return false end
function modifier_innate_speed_demon:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_speed_demon:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_speed_demon:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.ramp_attribute_increase = ability:GetSpecialValueFor("ramp_attribute_increase")
	self.base_attribute_increase = ability:GetSpecialValueFor("base_attribute_increase")
	self.movespeed_increase = ability:GetSpecialValueFor("movespeed_increase")

	self.current_bonus = self.current_bonus or 0
end

function modifier_innate_speed_demon:OnRoundEndForTeam(keys)
	if IsServer() then
		if Enfos:IsEnfosMode() then return end

		local parent = self:GetParent()

		if parent:HasModifier("modifier_innate_speed_demon_cosmetic_buff") then
			parent:RemoveModifierByName("modifier_innate_speed_demon_cosmetic_buff")
		end

		if keys.position == 1 then 
			self:IncrementStackCount()

			Timers:CreateTimer(0.5, function()
				if parent and (not parent:IsNull()) then
					parent:EmitSound("Hero_Clinkz.Strafe")

					local win_particle = ParticleManager:CreateParticle("particles/custom/innates/speed_demon_win.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
					ParticleManager:SetParticleControlEnt(win_particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), false)
					ParticleManager:ReleaseParticleIndex(win_particle)

					parent:AddNewModifier(parent, nil, "modifier_innate_speed_demon_cosmetic_buff", {duration = 9})
				end
			end)
		end
	end
end

function modifier_innate_speed_demon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_innate_speed_demon:GetModifierBonusStats_Strength()
	return self:GetStackCount() * (self.base_attribute_increase + self:GetStackCount() * self.ramp_attribute_increase)
end

function modifier_innate_speed_demon:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (self.base_attribute_increase + self:GetStackCount() * self.ramp_attribute_increase)
end

function modifier_innate_speed_demon:GetModifierBonusStats_Intellect()
	return self:GetStackCount() * (self.base_attribute_increase + self:GetStackCount() * self.ramp_attribute_increase)
end

function modifier_innate_speed_demon:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_innate_speed_demon:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount() * self.movespeed_increase
end

function modifier_innate_speed_demon:OnDestroy()
	if IsClient() then return end

	self:GetParent():RemoveModifierByName("modifier_innate_speed_demon_cosmetic_buff")
end



modifier_innate_speed_demon_cosmetic_buff = class({})

function modifier_innate_speed_demon_cosmetic_buff:IsHidden() return true end
function modifier_innate_speed_demon_cosmetic_buff:IsDebuff() return false end
function modifier_innate_speed_demon_cosmetic_buff:IsPurgable() return false end
function modifier_innate_speed_demon_cosmetic_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_speed_demon_cosmetic_buff:OnCreated()
	if IsClient() then return end

	self.ember_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly_ember.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.ember_pfx, 11, Vector(1, 0, 0))
	self:AddParticle(self.ember_pfx, false, false, -1, false, false)

	self:StartIntervalThink(1.0)
	self:OnIntervalThink()
end

function modifier_innate_speed_demon_cosmetic_buff:OnIntervalThink()
	local parent_loc = self:GetParent():GetAbsOrigin()
					
	for i = 1, 2 do
		local rocket_pfx = ParticleManager:CreateParticle("particles/custom/innates/speed_demon_win_rocket.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(rocket_pfx, 0, parent_loc)
		ParticleManager:ReleaseParticleIndex(rocket_pfx)
	end
end

function modifier_innate_speed_demon_cosmetic_buff:GetEffectName()
	return "particles/custom/innates/speed_demon_buff.vpcf"
end

function modifier_innate_speed_demon_cosmetic_buff:OnRoundStart()
	self:Destroy()
end

function modifier_innate_speed_demon_cosmetic_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_innate_speed_demon_cosmetic_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_innate_speed_demon_cosmetic_buff:GetModifierMoveSpeedBonus_Constant()
	return 1000
end
