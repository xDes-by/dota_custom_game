skeleton_king_reincarnation = class({})
LinkLuaModifier("modifier_skeleton_king_reincarnation_lua", "heroes/hero_skeleton_king/modifier_skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)

function skeleton_king_reincarnation:GetIntrinsicModifierName()
	return "modifier_skeleton_king_reincarnation_lua"
end

function skeleton_king_reincarnation:GetManaCost(level)
	if self:GetCaster():HasShard() then
		return 0
	else
		return self.BaseClass.GetManaCost(self, level)
	end
end

function skeleton_king_reincarnation:OnOwnerSpawned()
	local modifier = self:GetCaster():FindModifierByName("modifier_skeleton_king_reincarnation_lua")

	if modifier then
		modifier.reincarnation_death = false
	end
end
