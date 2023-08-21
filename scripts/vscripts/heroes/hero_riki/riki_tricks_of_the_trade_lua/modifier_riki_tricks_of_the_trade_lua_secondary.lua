if modifier_riki_tricks_of_the_trade_lua_secondary == nil then modifier_riki_tricks_of_the_trade_lua_secondary = class({}) end
function modifier_riki_tricks_of_the_trade_lua_secondary:IsPurgable() return false end
function modifier_riki_tricks_of_the_trade_lua_secondary:IsDebuff() return false end
function modifier_riki_tricks_of_the_trade_lua_secondary:IsHidden() return true end

function modifier_riki_tricks_of_the_trade_lua_secondary:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local aps = parent:GetAttacksPerSecond()
		self:StartIntervalThink((1/aps) * (1 / (self:GetAbility():GetSpecialValueFor("martyr_aspd_pct") * 0.01)))
	end
end

function modifier_riki_tricks_of_the_trade_lua_secondary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		if caster:HasScepter() then
			local target = ability:GetCursorTarget()
			if target then
				origin = target:GetAbsOrigin()
				caster:SetAbsOrigin(origin)
			end
		end

		local aoe = ability:GetSpecialValueFor("area_of_effect")

		local backstab_ability = caster:FindAbilityByName("riki_cloak_and_dagger_lua")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)

		if #targets == 0 or self:GetAbility():GetName() == "riki_tricks_of_the_trade_lua_723" then
			targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER , false)
		end

		-- #2 Talent: Tricks of the Trade now applies martyrs Mark on the target, targets with martyrs Mark becomes more likely to be targetted by Marty's Strike
		local martyrs_mark_targets = nil
		if caster:HasTalent("special_bonus_imba_riki_2") then
			for _,unit in pairs(targets) do
				if unit:IsAlive() and not unit:IsAttackImmune() then
					local martyrs_mark_mod = unit:FindModifierByName("modifier_imba_martyrs_mark")
					if martyrs_mark_mod then
						if not martyrs_mark_targets then
							martyrs_mark_targets = {}
						end
						table.insert(martyrs_mark_targets,unit)
					end
				end
			end
		end

		-- Check
		if martyrs_mark_targets then

			local martyrs_mark_stacks
			local martyrs_mark_target = nil
			local martyrs_mark_checklist = {}
			local highest_stack = 0
			local martyrs_mark_checked = false

			-- Check for targets from the highest stack count to lowest stack count
			for i=1,#martyrs_mark_targets,1 do
				for _,target in pairs(martyrs_mark_targets) do
					martyrs_mark_checked = false
					local martyrs_mark_mod = target:FindModifierByName("modifier_imba_martyrs_mark")
					if martyrs_mark_mod then
						for _,check_target in pairs(martyrs_mark_checklist) do
							if check_target == target then
								martyrs_mark_checked = true
							end
						end
						if not martyrs_mark_checked then
							if martyrs_mark_mod:GetStackCount() > highest_stack then
								martyrs_mark_stacks = martyrs_mark_mod:GetStackCount()
								highest_stack = martyrs_mark_stacks
								martyrs_mark_target = target
							end
						end
					end
				end

				-- Get the proc chance for martyrs Mark, the formula goes like this
				-- 3 targets causes a target to have 33% chance
				-- 5 Martyr's Mark stacks causes the target to have 66% chance to be stroke
				-- 10 Martyr's Mark stacks causes the target to have 99% chance to be stroke
				-- 15 Martyr's Mark stacks causes the target to have 132% chance to be stroke
				local proc_chance = (1/#targets) * (1+martyrs_mark_stacks*caster:FindTalentValue("special_bonus_imba_riki_2")*0.01) * 100

				-- Don't roll the dice, don't do it Cuphead! D:
				if RollPercentage(proc_chance) or proc_chance >= 100 then
					self:ProcTricks(caster,ability,martyrs_mark_target,backstab_ability,backstab_particle,backstab_sound,caster:FindTalentValue("special_bonus_imba_riki_2","duration"))

					local caster = self:GetParent()
					local aps = caster:GetAttacksPerSecond()
					self:StartIntervalThink((1/aps) * (1 / (self:GetAbility():GetSpecialValueFor("martyr_aspd_pct") * 0.01)))
					return
				end
				-- If the marked target doesn't get hit, add him into the checklist
				table.insert(martyrs_mark_checklist, martyrs_mark_target)
			end
		end

		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				self:ProcTricks(caster,ability,unit,backstab_ability,backstab_particle,backstab_sound,caster:FindTalentValue("special_bonus_imba_riki_2","duration"))

				local caster = self:GetParent()
				local aps = caster:GetAttacksPerSecond()
				self:StartIntervalThink((1/aps) * (1 / (self:GetAbility():GetSpecialValueFor("martyr_aspd_pct") * 0.01)))
				return
			end
		end
	end
end

function modifier_riki_tricks_of_the_trade_lua_secondary:ProcTricks(caster,ability,target,backstab_ability,backstab_particle,backstab_sound,talent_duration)
	if caster:HasTalent("special_bonus_imba_riki_2") then
		local martyrs_mark_mod = target:FindModifierByName("modifier_imba_martyrs_mark")
		if martyrs_mark_mod then
			martyrs_mark_mod:ForceRefresh()
		else
			martyrs_mark_mod = target:AddNewModifier(caster,ability,"modifier_imba_martyrs_mark",{duration = talent_duration * (1 - target:GetStatusResistance())})
		end
	end

	if self:GetAbility():GetName() == "riki_tricks_of_the_trade_lua_723" then
		caster:AddNewModifier(caster, self:GetAbility(), "modifier_riki_tricks_of_the_trade_lua_723_damage_reduction", {})
		caster:PerformAttack(target, true, true, true, false, false, false, false)
		caster:RemoveModifierByName("modifier_riki_tricks_of_the_trade_lua_723_damage_reduction")
	else
		caster:PerformAttack(target, true, true, true, false, false, false, false)
	end
	

	if backstab_ability and backstab_ability:GetLevel() > 0 and not self:GetParent():PassivesDisabled() then
		local agility_damage_multiplier = backstab_ability:GetSpecialValueFor("agility_damage_multiplier")

		local particle = ParticleManager:CreateParticle(backstab_particle, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)

		EmitSoundOn(backstab_sound, target)
		ApplyDamage({victim = target, attacker = caster, damage = caster:GetAgility() * agility_damage_multiplier, damage_type = backstab_ability:GetAbilityDamageType()})

		-- #7 Talent: 4 Consecutive Backstabs applies Break on the target for 5 seconds.
		if caster:HasTalent("special_bonus_imba_riki_7") then
			local backbreaker_mod = target:FindModifierByName("modifier_imba_riki_backbreaker")
			if backbreaker_mod then
				backbreaker_mod:ForceRefresh()
			else
				backbreaker_mod = target:AddNewModifier(caster,backstab_ability,"modifier_imba_riki_backbreaker",{duration = caster:FindTalentValue("special_bonus_imba_riki_7","duration") * (1 - target:GetStatusResistance())})
			end
		end
	end
end