LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_sand_king_str50", "heroes/hero_sand/special_bonus_unique_npc_dota_hero_sand_king_str50", LUA_MODIFIER_MOTION_NONE )
special_bonus_unique_npc_dota_hero_sand_king_str50 = class({})

function special_bonus_unique_npc_dota_hero_sand_king_str50:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_npc_dota_hero_sand_king_str50"
end

modifier_special_bonus_unique_npc_dota_hero_sand_king_str50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:GetTexture()
    return "sand_ult"
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:RemoveOnDeath()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:OnCreated()
	if not IsServer() then
		return
	end
	self:SetStackCount(0)
	self:StartIntervalThink(0.2)
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:OnIntervalThink()
	if self:GetCaster():IsMoving() then
		self:SetStackCount(0)
	else
		if self:GetStackCount() < 300 then
			self:IncrementStackCount()
		end
	end
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_special_bonus_unique_npc_dota_hero_sand_king_str50:GetModifierTotalDamageOutgoing_Percentage()
	return 100 + self:GetStackCount()
end