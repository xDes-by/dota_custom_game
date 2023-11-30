LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50", "heroes/hero_phantom/phantom_assassin_coup_de_grace_lua/special_bonus_unique_npc_dota_hero_phantom_assassin_agi50", LUA_MODIFIER_MOTION_NONE )
special_bonus_unique_npc_dota_hero_phantom_assassin_agi50 = class({})

function special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50"
end


modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50 = class({})
--Classifications template
function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:RemoveOnDeath()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:OnDeath(data)
	if self:GetParent() == data.attacker then
		if data.original_damage > self:GetCaster():GetAverageTrueAttackDamage(nil) * 1.1 and IsBoss(data.unit:GetUnitName()) then
			self:IncrementStackCount()
			if not self.interval then
				self.interval = true
				self:StartIntervalThink(120)
			end
		end
	end
end

function IsBoss(name)
	bosses_names = {"npc_forest_boss","npc_village_boss","npc_mines_boss","npc_dust_boss","npc_swamp_boss","npc_snow_boss","npc_forest_boss_fake","npc_village_boss_fake","npc_mines_boss_fake","npc_dust_boss_fake","npc_swamp_boss_fake","npc_snow_boss_fake","boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9","boss_10","boss_11","boss_12","boss_13","boss_14","boss_15","boss_16","boss_17","boss_18","boss_19","boss_20", "npc_boss_location8", "npc_boss_location8_fake"}
	local b = false
	for i = 1, #bosses_names do
		if name == bosses_names[i] then
			b = true
			break
		end
	end
	return b
end

function modifier_special_bonus_unique_npc_dota_hero_phantom_assassin_agi50:OnIntervalThink()
	self:DecrementStackCount()
	if self:GetStackCount() == 0 then
		self.interval = false
		self:StartIntervalThink(-1)
	end
end