-------------------------------------------
--			PARALYZING CASK
-------------------------------------------
witch_doctor_paralyzing_cask = class({})
function witch_doctor_paralyzing_cask:IsHiddenWhenStolen() return false end
function witch_doctor_paralyzing_cask:IsRefreshable() return true end
function witch_doctor_paralyzing_cask:IsStealable() return true end
function witch_doctor_paralyzing_cask:IsNetherWardStealable() return true end

function witch_doctor_paralyzing_cask:GetAbilityTextureName()
	return "witch_doctor_paralyzing_cask"
end

-------------------------------------------

function witch_doctor_paralyzing_cask:OnSpellStart()
	if IsServer() then
		local hTarget = self:GetCursorTarget()

		-- Parameters
		local speed = self:GetSpecialValueFor("speed")
		-- Creating a unique ID for each cast
		local index = DoUniqueString("index")
		self["split_" .. index] = self:GetSpecialValueFor("split_amount")
		-- Cask count
		self[index] = 1

		if (self:GetCaster():GetName() == "npc_dota_hero_witch_doctor") then
			self:GetCaster():EmitSound("witchdoctor_wdoc_ability_cask_0"..math.random(1,8))
		end

		local projectile =
			{
				Target = hTarget,
				Source = self:GetCaster(),
				Ability = self,
				EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
				bDodgable = false,
				bProvidesVision = false,
				iMoveSpeed = speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				ExtraData =
				{
					hero_duration = self:GetSpecialValueFor("hero_duration"),
					creep_duration = self:GetSpecialValueFor("creep_duration"),
					hero_damage = self:GetSpecialValueFor("hero_damage"),
					creep_damage = self:GetSpecialValueFor("creep_damage"),
					bounce_range = self:GetSpecialValueFor("bounce_range"),
					bounces = self:GetSpecialValueFor("bounces"),
					speed = speed,
					bounce_delay = self:GetSpecialValueFor("bounce_delay"),
					index = index,
					bFirstCast = 1
				}
			}
		EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Cast", self:GetCaster())
		ProjectileManager:CreateTrackingProjectile(projectile)
	end
end

function witch_doctor_paralyzing_cask:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	EmitSoundOn("Hero_WitchDoctor.Paralyzing_Cask_Bounce", hTarget)

	if hTarget then
		if hTarget:IsRealHero() or hTarget:IsConsideredHero() then
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				if not hTarget:IsMagicImmune() and (ExtraData.bFirstCast == 0 or not hTarget:TriggerSpellAbsorb(self)) then
					-- #4 TALENT: Casket applies maledict if previous target was maledicted
					if IsServer() and self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_4") then
						local maledict_ability	=	self:GetCaster():FindAbilityByName("imba_witch_doctor_maledict")
						if hTarget:FindModifierByName("modifier_imba_maledict") then
							self.cursed_casket = true
						else
							self.cursed_casket = false
						end
						if ExtraData.cursed_casket == 1 and maledict_ability then
							hTarget:AddNewModifier(self:GetCaster(), maledict_ability, "modifier_imba_maledict", {duration = maledict_ability:GetSpecialValueFor("duration") + FrameTime()} )
						end
					end
					
					hTarget:AddNewModifier(hTarget, self, "modifier_stunned", {duration = ExtraData.hero_duration * (1 - hTarget:GetStatusResistance())})
					
					ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = ExtraData.hero_damage, damage_type = self:GetAbilityDamageType()})
				end
			else
				local heal = ExtraData.hero_damage
				hTarget:Heal(heal, self)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, heal, nil)
			end
		else
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				if not hTarget:IsMagicImmune() and (ExtraData.bFirstCast == 0 or not hTarget:TriggerSpellAbsorb(self)) then

					hTarget:AddNewModifier(hTarget, self, "modifier_stunned", {duration = ExtraData.creep_duration * (1 - hTarget:GetStatusResistance())})
					ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = ExtraData.creep_damage, damage_type = self:GetAbilityDamageType()})
				end
			else
				local heal = ExtraData.creep_damage
				hTarget:Heal(heal, self)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, hTarget, heal, nil)
			end
		end
	else
		-- -- If target is out of world or gets invulnerable
		-- hTarget = CreateUnitByName("npc_dummy_unit", vLocation, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
	end
	if ExtraData.bounces >= 1 then
		Timers:CreateTimer(ExtraData.bounce_delay, function()
			-- Finds all units in the area, prioritizing enemies
			local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, ExtraData.bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false)
			local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), hTarget:GetAbsOrigin(), nil, ExtraData.bounce_range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

			-- Go through the target tables, checking for the first one that isn't the same as the target
			local tJumpTargets = {}
			-- If the target is an enemy, bounce on an enemy.
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				for _,unit in pairs(enemies) do
					if hTarget then
						if (unit ~= hTarget) and (not unit:IsOther()) and ((self["split_" .. ExtraData.index] >= 1) or #tJumpTargets == 0) then
							table.insert(tJumpTargets, unit)
							if #tJumpTargets == 2 then
								self[ExtraData.index] = self[ExtraData.index] + 1
								break
							end
						end
					end
				end
				-- If the target is an ally, bounce on an ally.
			else
				if #tJumpTargets == 0 then
					for _,unit in pairs(allies) do
						if hTarget then
							if (unit ~= hTarget) and (not unit:IsOther()) then
								table.insert(tJumpTargets, unit)
								break
							end
						end
					end
				end
			end

			if #tJumpTargets == 0 then
				-- End of spell
				self.cursed_casket = false
				if self[ExtraData.index] == 1 then
					self[ExtraData.index] = nil
					self["split_" .. ExtraData.index] = nil
				else
					self[ExtraData.index] = self[ExtraData.index] - 1
				end
				return nil
			elseif #tJumpTargets >= 2 then
				self["split_" .. ExtraData.index] = self["split_" .. ExtraData.index] - 1
			end
			for _, hJumpTarget in pairs(tJumpTargets) do
				local projectile = {
					Target = hJumpTarget,
					Source = hTarget,
					Ability = self,
					EffectName = "particles/units/heroes/hero_witchdoctor/witchdoctor_cask.vpcf",
					bDodgable = false,
					bProvidesVision = false,
					iMoveSpeed = ExtraData.speed,
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
					ExtraData =
					{
						hero_duration 		= ExtraData.hero_duration,
						creep_duration 		= ExtraData.creep_duration,
						hero_damage 		= ExtraData.hero_damage,
						creep_damage 		= ExtraData.creep_damage,
						bounce_range 		= ExtraData.bounce_range,
						bounces 			= ExtraData.bounces - 1,
						speed				= ExtraData.speed,
						bounce_delay 		= ExtraData.bounce_delay,
						index 				= ExtraData.index,
						cursed_casket 		= self.cursed_casket,
						bFirstCast			= 0
					}
				}
				ProjectileManager:CreateTrackingProjectile(projectile)
				-- if hTarget:GetName() == "npc_dummy_unit" then
					-- hTarget:Destroy()
				-- end
			end
		end)
	else
		self.cursed_casket = false
		if self[ExtraData.index] == 1 then
			self[ExtraData.index] = nil
			self["split_" .. ExtraData.index] = nil
		else
			self[ExtraData.index] = self[ExtraData.index] - 1
		end
		return nil
	end
end