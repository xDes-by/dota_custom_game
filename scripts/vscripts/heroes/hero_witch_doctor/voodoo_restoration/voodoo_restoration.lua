-------------------------------------------
--			VOODOO RESTORATION
-------------------------------------------

witch_doctor_voodoo_restoration = class({})
LinkLuaModifier("modifier_imba_voodoo_restoration", "heroes/hero_witch_doctor/voodoo_restoration/voodoo_restoration.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_voodoo_restoration_heal", "heroes/hero_witch_doctor/voodoo_restoration/voodoo_restoration.lua", LUA_MODIFIER_MOTION_NONE)

function witch_doctor_voodoo_restoration:GetAbilityTextureName()
	return "witch_doctor_voodoo_restoration"
end

function witch_doctor_voodoo_restoration:ProcsMagicStick() return false end

LinkLuaModifier("modifier_special_bonus_imba_witch_doctor_6", "heroes/hero_witch_doctor/voodoo_restoration/voodoo_restoration.lua", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_witch_doctor_6 = modifier_special_bonus_imba_witch_doctor_6 or class({})

function modifier_special_bonus_imba_witch_doctor_6:IsHidden() return true end
function modifier_special_bonus_imba_witch_doctor_6:IsPurgable() return false end
function modifier_special_bonus_imba_witch_doctor_6:RemoveOnDeath() return false end

-- #6 TALENT : Voodo restoration turns into a passive.
function modifier_special_bonus_imba_witch_doctor_6:OnCreated()
	if IsServer() then
		local ability = self:GetParent():FindAbilityByName("witch_doctor_voodoo_restoration")
		if not ability then return end
		self:GetParent():SetContextThink( DoUniqueString("checkforvoodoo"), function ( )
			if ability:GetLevel() > 0 then
				self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_imba_voodoo_restoration", {})
				return nil
			end

			if not ability:IsTrained() or self:GetParent():IsIllusion() then return nil end
	
			return 1.0
		end, 0 )
	end
end

function witch_doctor_voodoo_restoration:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function witch_doctor_voodoo_restoration:GetBehavior()
	-- #6 TALENT : Voodo restoration turns into a passive.
	if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_6") then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
	end
end

function witch_doctor_voodoo_restoration:GetManaCost( hTarget )
	--#6 TALENT: Voodo restoration doesn't cost mana to activate.
	if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_6") then
		return 0
	else
		return self.BaseClass.GetManaCost(self, hTarget)
	end
end

function witch_doctor_voodoo_restoration:OnUpgrade()
	if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_6") then
		if self:GetCaster():HasModifier("modifier_imba_voodoo_restoration") then
			self:GetCaster():RemoveModifierByName("modifier_imba_voodoo_restoration")
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_voodoo_restoration", {})
	end
end

function witch_doctor_voodoo_restoration:OnToggle()
	if self:GetToggleState() then
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration", self:GetCaster())
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_voodoo_restoration", {})

		if (not _G.VOODOO) and (self:GetCaster():GetName() == "npc_dota_hero_witch_doctor") then
			_G.VOODOO = true
			self:GetCaster():EmitSound("witchdoctor_wdoc_ability_voodoo_0"..math.random(1,5))
			Timers:CreateTimer(10,function()
				_G.VOODOO = nil
			end)
		end

		-- #2 TALENT: When Voodo Restoration is toggled on it applies the dispell immediately.
		if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_2")  then
			-- Special handling for first cast
			if not self.previous_dispell_time then self.previous_dispell_time = GameRules:GetGameTime() + self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_2") end

			-- This can only happen every so often.
			if GameRules:GetGameTime() >= self.previous_dispell_time + self:GetCaster():FindTalentValue("special_bonus_imba_witch_doctor_2") then
				-- Remember what time the dispell happened
				self.previous_dispell_time = GameRules:GetGameTime()
				-- Find allies to dispell
				local allies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
					self:GetCaster():GetAbsOrigin(),
					nil,
					self:GetSpecialValueFor("radius"),
					self:GetAbilityTargetTeam(),
					self:GetAbilityTargetType(),
					self:GetAbilityTargetFlags(),
					0,
					false)
				-- Dispell them
				for _,hAlly in pairs(allies) do
					local bRemoveStuns		= false
					local bRemoveExceptions = false

					-- #3 TALENT: Voodo restoration now purges stuns/exceptions
					if self:GetCaster():FindAbilityByName("special_bonus_imba_witch_doctor_3") then
						bRemoveStuns 	  = true
						bRemoveExceptions = true
					end

					hAlly:Purge(false, true, false, bRemoveStuns, bRemoveExceptions)
					local cleanse_pfc = ParticleManager:CreateParticle("particles/hero/witch_doctor/voodoo_cleanse.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
					ParticleManager:SetParticleControlEnt(cleanse_pfc, 0, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", hAlly:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(cleanse_pfc)
					if hAlly == self:GetCaster() then
						EmitSoundOn("Imba.WitchDoctorDispel", self:GetCaster())
					end
				end
			end
		end
	else
		EmitSoundOn("Hero_WitchDoctor.Voodoo_Restoration.Off", self:GetCaster())
		StopSoundEvent("Hero_WitchDoctor.Voodoo_Restoration.Loop", self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_imba_voodoo_restoration")
	end
end

modifier_imba_voodoo_restoration = class({})
function modifier_imba_voodoo_restoration:OnCreated()
	if IsServer() and self:GetAbility():IsTrained() then
		local ability = self:GetAbility()
		self.interval = ability:GetSpecialValueFor("heal_interval")
		self.cleanse_interval = ability:GetSpecialValueFor("cleanse_interval")
		self.manacost = ability:GetSpecialValueFor("mana_per_second") * self.interval
		self.radius = ability:GetSpecialValueFor("radius")
		self:StartIntervalThink( self.interval )
		self.mainParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.mainParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.mainParticle, 1, Vector( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControlEnt(self.mainParticle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_staff", self:GetCaster():GetAbsOrigin(), true)
	end
end

function modifier_imba_voodoo_restoration:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
		if self.mainParticle then
			ParticleManager:DestroyParticle(self.mainParticle, false)
			ParticleManager:ReleaseParticleIndex(self.mainParticle)
		end
	end
end

function modifier_imba_voodoo_restoration:OnIntervalThink()
	local hAbility = self:GetAbility()
	if not hAbility or hAbility:IsNull() then
		self:Destroy()
		return
	end
	local hCaster = self:GetCaster()
	if not hCaster or hCaster:IsNull() or not hCaster:IsAlive() then
		return
	end

	-- Counter for purge effect
	self.cleanse_counter = self.cleanse_counter or 0

	self.cleanse_counter = self.cleanse_counter + self.interval
	if self.cleanse_counter >= self.cleanse_interval then
		self.cleanse_counter = 0
		local allies = FindUnitsInRadius(
			hCaster:GetTeamNumber(),
			hCaster:GetAbsOrigin(),
			nil,
			self.radius,
			hAbility:GetAbilityTargetTeam(),
			hAbility:GetAbilityTargetType(),
			hAbility:GetAbilityTargetFlags(),
			FIND_ANY_ORDER,
			false
		)
		for _, hAlly in pairs(allies) do
			local bRemoveStuns		= false
			local bRemoveExceptions = false

			-- #3 TALENT: Voodo restoration now purges stuns/exceptions
			if hCaster:FindAbilityByName("special_bonus_imba_witch_doctor_3") then
				bRemoveStuns      = true
				bRemoveExceptions = true
			end

			hAlly:Purge(false, true, false, bRemoveStuns, bRemoveExceptions)
			local cleanse_pfc = ParticleManager:CreateParticle("particles/hero/witch_doctor/voodoo_cleanse.vpcf", PATTACH_POINT_FOLLOW, hCaster)
			ParticleManager:SetParticleControlEnt(cleanse_pfc, 0, hAlly, PATTACH_POINT_FOLLOW, "attach_hitloc", hAlly:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(cleanse_pfc)
			if hAlly == hCaster then
				hCaster:EmitSound("Imba.WitchDoctorDispel")
			end
		end
	end

	-- #6 TALENT: Voodo restoration doesn't cost mana to maintain.
	if not hCaster:FindAbilityByName("special_bonus_imba_witch_doctor_6") then
		if hCaster:GetMana() >= hAbility:GetManaCost(-1) then
			hCaster:SpendMana(self.manacost, hAbility)
		else
			hAbility:ToggleAbility()
		end
	end
end

function modifier_imba_voodoo_restoration:IsAura()
	return true
end

function modifier_imba_voodoo_restoration:IsAuraActiveOnDeath()
	return false
end

function modifier_imba_voodoo_restoration:GetAuraRadius()
	return self.radius
end

function modifier_imba_voodoo_restoration:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_imba_voodoo_restoration:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_imba_voodoo_restoration:GetModifierAura()
	return "modifier_imba_voodoo_restoration_heal"
end

function modifier_imba_voodoo_restoration:IsHidden()
	return true
end
-------------------------------------------
modifier_imba_voodoo_restoration_heal = class({})
function modifier_imba_voodoo_restoration_heal:IsDebuff() return false end
function modifier_imba_voodoo_restoration_heal:IsHidden() return false end
function modifier_imba_voodoo_restoration_heal:IsPurgable() return false end
function modifier_imba_voodoo_restoration_heal:IsPurgeException() return false end
function modifier_imba_voodoo_restoration_heal:IsStunDebuff() return false end
function modifier_imba_voodoo_restoration_heal:RemoveOnDeath() return true end
-- function modifier_imba_voodoo_restoration_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end -- Why was this made to stack
-------------------------------------------
function modifier_imba_voodoo_restoration_heal:OnCreated()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	self.heal				= self:GetAbility():GetSpecialValueFor("heal")
	self.heal_spell_amp_pct	= self:GetAbility():GetSpecialValueFor("heal_spell_amp_pct")
	self.int_to_heal		= self:GetAbility():GetSpecialValueFor("int_to_heal")
	
	if IsServer() then
		self.interval = self:GetAbility():GetSpecialValueFor("heal_interval")
		self:StartIntervalThink( self.interval )
	end
end

function modifier_imba_voodoo_restoration_heal:OnIntervalThink()
	if not self:GetAbility() or self:GetAbility():IsNull() then self:Destroy() return end

	local hParent = self:GetParent()
	local heal_amp = 1 + (self:GetCaster():GetSpellAmplification(false) * self.heal_spell_amp_pct * 0.01)
	local heal = (self.heal + (self:GetCaster():GetIntellect() * self.int_to_heal * 0.01)) * heal_amp * self.interval

	hParent:Heal(heal, self:GetAbility())
	SendOverheadEventMessage(hParent, OVERHEAD_ALERT_HEAL, hParent, heal, hParent)
end