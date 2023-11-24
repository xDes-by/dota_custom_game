modifier_riki_tricks_of_the_trade_lua  = class({})
function modifier_riki_tricks_of_the_trade_lua:IsPurgable() return false end
function modifier_riki_tricks_of_the_trade_lua:IsDebuff() return false end
function modifier_riki_tricks_of_the_trade_lua:IsHidden() return false end

function modifier_riki_tricks_of_the_trade_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_riki_tricks_of_the_trade_lua:GetModifierAttackRangeBonus()
	return self.area_of_effect
end
function modifier_riki_tricks_of_the_trade_lua:GetModifierDamageOutgoing_Percentage()
	return -100 + self.dmg_perc
end
function modifier_riki_tricks_of_the_trade_lua:GetModifierBonusStats_Agility()
	return self.agi
end
function modifier_riki_tricks_of_the_trade_lua:CheckState()
	if IsServer() then
		local state = {	
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		}
		return state
	end
end

function modifier_riki_tricks_of_the_trade_lua:OnCreated()
	local ability = self:GetAbility()

	self.area_of_effect	= ability:GetSpecialValueFor("area_of_effect")
	self.dmg_perc = ability:GetSpecialValueFor("dmg_perc")
	self.attack_count2 = ability:GetSpecialValueFor("attack_count2")
	self.agi = ability:GetSpecialValueFor("extra_agility") / 100 * self:GetParent():GetAgility()
	if IsServer() then
		local attack_count = ability:GetSpecialValueFor("attack_count")
		local duration = ability:GetSpecialValueFor("channel_duration")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi12") then
			attack_count = attack_count + duration / (1 / (self:GetCaster():GetAttacksPerSecond() / 2))
		end
		self.interval = duration / attack_count
		
		self:OnIntervalThink()
		self:StartIntervalThink(self.interval)
	end
end

function modifier_riki_tricks_of_the_trade_lua:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		local aoe = ability:GetSpecialValueFor("area_of_effect")

		local backstab_ability = caster:FindAbilityByName("riki_cloak_and_dagger_lua")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER , false)

		local attack_count = 0
		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				attack_count = attack_count + 1
				caster:PerformAttack(unit, true, true, true, false, false, false, false)
				if attack_count >= self.attack_count2 then
					return
				end
			end
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi13") and #targets <= 1 then
			self:StartIntervalThink(self.interval/2)
		end
	end
end