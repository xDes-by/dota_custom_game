---@class shadow_demon_demonic_cleanse_lua:CDOTA_Ability_Lua
shadow_demon_demonic_cleanse_lua = class({})

function shadow_demon_demonic_cleanse_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_shadow_demon_9")
end

function shadow_demon_demonic_cleanse_lua:GetChargeCooldown()
	return self:GetCooldown(-1)
end

function shadow_demon_demonic_cleanse_lua:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if not target or not caster then return end

	target:AddNewModifier(caster, self, "modifier_shadow_demon_purge_slow", { duration = self:GetDuration() })

	EmitSoundOn("Hero_ShadowDemon.DemonicPurge.Cast", target)
end
