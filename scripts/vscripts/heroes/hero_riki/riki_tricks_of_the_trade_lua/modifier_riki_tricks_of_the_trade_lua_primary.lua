if modifier_riki_tricks_of_the_trade_lua_primary == nil then modifier_riki_tricks_of_the_trade_lua_primary = class({}) end
function modifier_riki_tricks_of_the_trade_lua_primary:IsPurgable() return false end
function modifier_riki_tricks_of_the_trade_lua_primary:IsDebuff() return false end
function modifier_riki_tricks_of_the_trade_lua_primary:IsHidden() return false end

function modifier_riki_tricks_of_the_trade_lua_primary:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end

function modifier_riki_tricks_of_the_trade_lua_primary:GetModifierAttackRangeBonus()
	return self.area_of_effect
end
function modifier_riki_tricks_of_the_trade_lua_primary:GetModifierDamageOutgoing_Percentage()
	return -100 + self.dmg_perc
end
function modifier_riki_tricks_of_the_trade_lua_primary:GetModifierBonusStats_Agility()
	return self.agi
end
-- function modifier_riki_tricks_of_the_trade_lua_primary:CheckState()
-- 	if IsServer() then
-- 		local state = {	
-- 			[MODIFIER_STATE_INVULNERABLE] = true,
-- 			[MODIFIER_STATE_UNSELECTABLE] = true,
-- 			[MODIFIER_STATE_OUT_OF_GAME] = true,
-- 			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
-- 			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
-- 		}
-- 		return state
-- 	end
-- end

function modifier_riki_tricks_of_the_trade_lua_primary:OnCreated()
	local ability = self:GetAbility()

	self.area_of_effect	= ability:GetSpecialValueFor("area_of_effect")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int11") then
		self.area_of_effect = self.area_of_effect + 150
	end
	self.dmg_perc = ability:GetSpecialValueFor("dmg_perc")
	self.attack_count2 = ability:GetSpecialValueFor("attack_count2")
	self.agi = 0
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int8") then
		self.attack_count2 = self.attack_count2 * 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi6") then
		self.dmg_perc = self.dmg_perc + 35
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi7") then
		self.agi = self:GetParent():GetAgility() * 0.6
	end
	if IsServer() then
		
		
		local attack_count = ability:GetSpecialValueFor("attack_count")
		local duration = ability:GetSpecialValueFor("channel_duration")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi_last") then
			attack_count = attack_count + duration / (1 / self:GetCaster():GetAttacksPerSecond())
		end
		local interval = duration / attack_count
		
		self:OnIntervalThink()
		self:StartIntervalThink(interval)
	end
end

function modifier_riki_tricks_of_the_trade_lua_primary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		-- if caster:HasScepter() and ability:GetCursorTarget() then
		-- 	local target = ability:GetCursorTarget()
		-- 	origin = target:GetAbsOrigin()
		-- 	caster:SetAbsOrigin(origin)
		-- end

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
				-- if self:GetAbility():GetName() == "riki_tricks_of_the_trade_lua_723" then
				-- 	caster:SetForwardVector(unit:GetForwardVector())
				-- 	caster:PerformAttack(unit, true, true, true, false, false, false, false)
				-- else
				-- 	caster:PerformAttack(unit, true, true, true, false, false, false, false)
					
				-- 	if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
				-- 		local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")
						
				-- 		local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, unit)
				-- 		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				-- 		ParticleManager:ReleaseParticleIndex(particle)

				-- 		EmitSoundOn(backstab_sound, unit)
				-- 		ApplyDamage({victim = unit, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})

				-- 		-- #7 Talent: 4 Consecutive Backstabs applies Break on the target for 5 seconds.
				-- 		if caster:HasTalent("special_bonus_imba_riki_7") then
				-- 			local backbreaker_mod = unit:FindModifierByName("modifier_imba_riki_backbreaker")
				-- 			if backbreaker_mod then
				-- 				backbreaker_mod:ForceRefresh()
				-- 			else
				-- 				backbreaker_mod = unit:AddNewModifier(caster,backstab_ability,"modifier_imba_riki_backbreaker",{duration = caster:FindTalentValue("special_bonus_imba_riki_7","duration") * (1 - unit:GetStatusResistance())})
				-- 			end
				-- 		end
				-- 	end
				-- end
			end
		end
	end
end