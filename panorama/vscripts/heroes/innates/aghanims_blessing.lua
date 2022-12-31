innate_aghanims_blessing = class({})
modifier_innate_aghanims_blessing = class({})

LinkLuaModifier("modifier_innate_aghanims_blessing", "heroes/innates/aghanims_blessing", LUA_MODIFIER_MOTION_NONE)

function innate_aghanims_blessing:GetIntrinsicModifierName() return "modifier_innate_aghanims_blessing" end

function innate_aghanims_blessing:Spawn()
	if IsClient() then return end

	local caster = self:GetCaster()
	if not caster then return end

	-- why? because checks for this ability or modifier in scepter/shard systems fire too early, 
	-- when HasModifier and HasAbility return false on it
	caster.received_aghs_blessing = true 
	caster:EmitSound("Hero_Alchemist.Scepter.Cast")
	caster:AddNewModifier(caster, nil, "modifier_item_aghanims_shard", nil)
	caster:AddNewModifier(caster, nil, "modifier_item_ultimate_scepter_consumed", nil)
	
	-- notify system that player recieved scepter
	Timers:CreateTimer(0, function()
		if not caster or caster:IsNull() then return end
		EventDriver:Dispatch("Hero:scepter_received", {
			hero = caster,
		})
	end)
end

function modifier_innate_aghanims_blessing:IsHidden() return true end
function modifier_innate_aghanims_blessing:IsDebuff() return false end
function modifier_innate_aghanims_blessing:IsPurgable() return false end
function modifier_innate_aghanims_blessing:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_aghanims_blessing:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_aghanims_blessing:OnRefresh(keys)
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats") or 0
end

function modifier_innate_aghanims_blessing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
	return funcs
end

function modifier_innate_aghanims_blessing:GetModifierBonusStats_Strength()
	return self.bonus_stats
end

function modifier_innate_aghanims_blessing:GetModifierBonusStats_Agility()
	return self.bonus_stats
end

function modifier_innate_aghanims_blessing:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end
