sven_bringer = class({})
LinkLuaModifier("modifier_sven_bringer", "heroes/hero_sven/sven_bringer/sven_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sven_bringer_sword_particle", "heroes/hero_sven/sven_bringer/sven_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sven_bringer_manual", "heroes/hero_sven/sven_bringer/sven_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sven_bringer_slow", "heroes/hero_sven/sven_bringer/sven_bringer", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sven_bringer_cleave_hit_target", "heroes/hero_sven/sven_bringer/sven_bringer", LUA_MODIFIER_MOTION_NONE)

function sven_bringer:GetIntrinsicModifierName()
	return "modifier_sven_bringer"
end

function sven_bringer:GetCastRange(location, target)
	return self:GetCaster():Script_GetAttackRange()
end

function sven_bringer:IsStealable()
	return false
end

function sven_bringer:OnSpellStart()
	-- Force attack the target
	local caster = self:GetCaster()
	caster:MoveToTargetToAttack(self:GetCursorTarget())
	caster:AddNewModifier(caster, self, "modifier_sven_bringer_manual", {})
	self:EndCooldown()
end

function sven_bringer:OnUpgrade()
	self:GetCaster():RemoveModifierByName("modifier_sven_bringer")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_bringer", {})

	-- Toggles the autocast when first leveled
	local caster_tidebringer = self:GetCaster():FindAbilityByName("sven_bringer")
	if caster_tidebringer and caster_tidebringer:GetLevel() == 1 then
		caster_tidebringer:ToggleAutoCast()
	end
end

modifier_sven_bringer_sword_particle = class({})

function modifier_sven_bringer_sword_particle:IsHidden()
	return true
end

function modifier_sven_bringer_sword_particle:RemoveOnDeath()
	return false
end

function modifier_sven_bringer_sword_particle:IsPurgable()
	return false
end

function modifier_sven_bringer_sword_particle:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local cooldown = ability:GetCooldown(ability:GetLevel()-1)

		caster:EmitSound("Hero_Kunkka.Tidebringer.Attack")
		ParticleManager:DestroyParticle(caster.tidebringer_weapon_pfx, true)
		ParticleManager:ReleaseParticleIndex(caster.tidebringer_weapon_pfx)
		caster.tidebringer_weapon_pfx = 0
	end
end

function modifier_sven_bringer_sword_particle:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		caster.tidebringer_weapon_pfx = caster.tidebringer_weapon_pfx or 0
		if caster.tidebringer_weapon_pfx == 0 then
			EmitSoundOn("Hero_Kunkaa.Tidebringer", caster)
			caster.tidebringer_weapon_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_kunkka/kunkka_weapon_tidebringer.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_tidebringer", caster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(caster.tidebringer_weapon_pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_sword", caster:GetAbsOrigin(), true)
		end
	end
end

modifier_sven_bringer_manual = class({})

function modifier_sven_bringer_manual:IsHidden()
	return false
end

modifier_sven_bringer = class({})

function modifier_sven_bringer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_sven_bringer:OnCreated()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		if (not caster:HasModifier("modifier_sven_bringer_sword_particle")) and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_sven_bringer_sword_particle", {})
		end
	end
end

function modifier_sven_bringer:OnRefresh()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if IsServer() then
		if ( not caster:HasModifier("modifier_sven_bringer_sword_particle")) and ability:IsCooldownReady() then
			caster:AddNewModifier(caster, ability, "modifier_sven_bringer_sword_particle", {})
		end
	end
end

function modifier_sven_bringer:OnAttackStart( params )
	if self:GetAbility() then
		local parent = self:GetParent()
		local target = params.target
		if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
			if not target:IsBuilding() then
				local ability = self:GetAbility()
				self.sound_triggered = false
				-- Check buffs by Ebb and Flow, and set on Cooldown after cast to give a new buff
				self.tide_index = 0
				if parent:HasModifier("modifier_imba_ebb_and_flow_tsunami") 	then self.tide_index = 1 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_low") 	then self.tide_index = 2 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_red") 	then self.tide_index = 3 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_flood")	then self.tide_index = 4 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_high") 	then self.tide_index = 5 end
				if parent:HasModifier("modifier_imba_ebb_and_flow_tide_wave") 	then self.tide_index = 6 end

				if ability:IsCooldownReady() and not (parent:PassivesDisabled()) then
					if ability:GetAutoCastState() or parent:HasModifier("modifier_sven_bringer_manual") then
						self.pass_attack = true
						self.bonus_damage = ability:GetSpecialValueFor("bonus_damage")
						if (self.tide_index == 4) or (self.tide_index == 1) then
							self.bonus_damage = self.bonus_damage + ability:GetSpecialValueFor("tide_flood_damage")
						end
					else
						self.pass_attack = false
						self.bonus_damage = 0
					end
				end
			end
		end
	end
end

function modifier_sven_bringer:OnAttackLanded( params )
	local ability = self:GetAbility()
	if self:GetAbility() then
		local parent = self:GetParent()
		local tidebringer_bonus_damage = self.bonus_damage
		if params.attacker == parent and ( not parent:IsIllusion() ) and self.pass_attack then
			self.pass_attack = false
			self.bonus_damage = 0

			-- If you get break during attack-swing
			if parent:PassivesDisabled() then
				return 0
			end

			local range = self:GetAbility():GetSpecialValueFor("range")
			local radius_start = self:GetAbility():GetSpecialValueFor("radius_start")
			local radius_end = self:GetAbility():GetSpecialValueFor("radius_end")

			parent:RemoveModifierByName("modifier_sven_bringer_sword_particle")

			if self.tide_index == 1 then
				self.torrent_radius = radius_end * ( math.sqrt( math.pow((radius_end - radius_start), 2) + math.pow(range, 2)) + radius_start - radius_end) / range
				self.position_center = parent:GetAbsOrigin() + parent:GetForwardVector() * self.torrent_radius

				local torrent_fx_mini = ParticleManager:CreateParticle("particles/hero/kunkka/torrent_splash.vpcf", PATTACH_CUSTOMORIGIN, parent)
				ParticleManager:SetParticleControl(torrent_fx_mini, 0, self.position_center)
				ParticleManager:SetParticleControl(torrent_fx_mini, 1, Vector(self.torrent_radius,0,0))
			end

			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then

				self:TidebringerEffects( target, ability )
                
                local cleaveDamage = params.damage * (ability:GetSpecialValueFor("cleave_damage") / 100)
				
					local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_sven_agi7")
					if abil ~= nil then 
					cleaveDamage = cleaveDamage * 2
					end

					local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sven_agi50")
					if abil ~= nil then 
					cleaveDamage = cleaveDamage * 3
					radius_end = radius_end * 3
					range = range * 3
					end
									
					DoCleaveAttack( params.attacker, params.target, ability, cleaveDamage, radius_start, radius_end, range, "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf" )
	

				if not ((self.tide_index == 6) or (self.tide_index == 1)) then
					local cooldown = ability:GetCooldown(ability:GetLevel()-1)
					ability:UseResources(false,false, false, true)
					Timers:CreateTimer( cooldown, function()
							if not parent:HasModifier("modifier_sven_bringer_sword_particle") then
								parent:AddNewModifier(parent, ability, "modifier_sven_bringer_sword_particle", {})
							end
						end)
				end
				if parent:HasModifier("modifier_sven_bringer_manual") then
					parent:RemoveModifierByName("modifier_sven_bringer_manual")
				end
			end
		end
	end
	return 0
end

function modifier_sven_bringer:GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end

function modifier_sven_bringer:OnTakeDamage( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( bit.band( params.damage_flags , DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) == DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR) and params.inflictor:GetAbilityName() == "sven_bringer" then
			self:TidebringerEffects( params.unit, params.inflictor )
		end
	end
end

function modifier_sven_bringer:TidebringerEffects( target, ability )
	local sound_height = 1000
	self.hitCounter = self.hitCounter or 0
	self.hitCounter = self.hitCounter + 1
	local attacker = self:GetCaster()

	if self.tide_index == 1 then
		local location = target:GetAbsOrigin()

		local distance_from_center = ( location - self.position_center ):Length2D()

		local knocking_up = ((self.torrent_radius / distance_from_center ) * 50) * ( attacker:GetAverageTrueAttackDamage(attacker) / 300) + 40
		local knockback =
		{
			should_stun = 1,
			knockback_duration = ability:GetSpecialValueFor("tsunami_stun"),
			duration = ability:GetSpecialValueFor("tsunami_stun"),
			knockback_distance = 0,
			knockback_height = knocking_up,
			center_x = location.x,
			center_y = location.y,
			center_z = location.z
		}

		target:EmitSound("Hero_Kunkka.TidebringerDamage")
		if (knocking_up > sound_height) and not self.sound_triggered then
			EmitSoundOn("Kunkka.ShootingStar", target)
			self.sound_triggered = true
		end

		-- Apply knockback on enemies hit
		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(self:GetParent(), ability, "modifier_knockback", knockback)
	end
end

function modifier_sven_bringer:IsHidden()
	return true
end

function modifier_sven_bringer:RemoveOnDeath()
	return false
end

function modifier_sven_bringer:IsPurgable()
	return false
end