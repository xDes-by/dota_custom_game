boss_mind_control = class({})
LinkLuaModifier("modifier_boss_mind_control", "creatures/abilities/boss/boss_mind_control", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_mind_control_marked", "creatures/abilities/boss/boss_mind_control", LUA_MODIFIER_MOTION_NONE)

function boss_mind_control:OnAbilityPhaseStart()
	if IsServer() then
		self:GetCaster():EmitSound("BossMindControl.Windup")

		self.nPreviewFX = ParticleManager:CreateParticle("particles/creature/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true)
		ParticleManager:SetParticleControl(self.nPreviewFX, 1, Vector(150, 150, 150))
		ParticleManager:SetParticleControl(self.nPreviewFX, 15, Vector(70, 36, 247))
	end

	return true
end

function boss_mind_control:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nPreviewFX, false )
		self:GetCaster():StopSound("BossMindControl.Windup")
	end 
end

function boss_mind_control:OnSpellStart()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nPreviewFX, false)

		self.projectile_speed = self:GetSpecialValueFor("projectile_speed")
		self.attack_radius = self:GetSpecialValueFor("projectile_radius")
		self.projectile_distance = self:GetSpecialValueFor("projectile_distance")
		self.charm_duration = self:GetSpecialValueFor("charm_duration")
		self.projectile_expire_time = self:GetSpecialValueFor("projectile_expire_time")

		local vPos = nil
		if self:GetCursorTarget() then
			vPos = self:GetCursorTarget():GetOrigin()
		else
			vPos = self:GetCursorPosition()
		end

		local vDirection = vPos - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local info = {
			Target = self:GetCursorTarget(),
			Source = self:GetCaster(),
			Ability = self,
			EffectName = "particles/creature/boss_mind_control.vpcf",
			iMoveSpeed = self.projectile_speed,
			vSourceLoc = self:GetCaster():GetOrigin(),
			bDodgeable = false,
			bProvidesVision = false,
			flExpireTime = GameRules:GetGameTime() + self.projectile_expire_time,
		}

		ProjectileManager:CreateTrackingProjectile(info)

		self:GetCaster():StopSound("BossMindControl.Windup")
		self:GetCaster():EmitSound("BossMindControl.Cast")
	end
end

function boss_mind_control:OnProjectileHit(hTarget, vLocation)
	if IsServer() then
		if hTarget ~= nil and (not hTarget:IsMagicImmune()) and (not hTarget:IsInvulnerable()) then
			hTarget:AddNewModifier(self:GetCaster(), self, "modifier_boss_mind_control", {duration = self.charm_duration})
		end

		return true
	end
end





modifier_boss_mind_control = class ({})

function modifier_boss_mind_control:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_boss_mind_control:GetStatusEffectName()
	return "particles/econ/events/ti7/fountain_regen_ti7_bubbles.vpcf"
end

function modifier_boss_mind_control:IsHidden() return false end
function modifier_boss_mind_control:IsDebuff() return true end
function modifier_boss_mind_control:IsPurgable() return false end

function modifier_boss_mind_control:OnCreated(kv)
	if IsServer() then
		if self:GetParent():GetForceAttackTarget() then
			self:Destroy()
			return
		end

		self.movespeed_bonus = self:GetAbility():GetSpecialValueFor("movespeed_bonus")
		self.attackspeed_bonus = self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
		self.target_search_radius = self:GetAbility():GetSpecialValueFor("target_search_radius")
		self.charm_duration = self:GetAbility():GetSpecialValueFor("charm_duration")
		self.model_scale_perc = self:GetAbility():GetSpecialValueFor("model_scale_perc")

		self:GetParent():Interrupt()
		self:GetParent():SetIdleAcquire(true)

		local hAllies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.target_search_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		if #hAllies > 1 then
			self.hDesiredTarget = hAllies[ 2 ] -- assumes 1 will always be parent
			self:GetParent():SetForceAttackTargetAlly(self.hDesiredTarget)
			self.hDesiredTarget:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_boss_mind_control_marked", {duration = self.charm_duration})
			self:GetParent():EmitSound("BossMindControl.Loop")

			self:StartIntervalThink( 0 )
		else
			self:Destroy()
			return
		end
	end
end

function modifier_boss_mind_control:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE
	}	
	return funcs
end

function modifier_boss_mind_control:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed_bonus
end

function modifier_boss_mind_control:GetModifierAttackSpeedBonus_Constant(params)
	return self.attackspeed_bonus
end

function modifier_boss_mind_control:GetModifierModelScale(params)
	return self.model_scale_perc
end

function modifier_boss_mind_control:OnIntervalThink()
	if IsServer() then
		if self:GetParent():GetForceAttackTarget() == nil then
			self:GetParent():SetForceAttackTargetAlly( self.hDesiredTarget )
		end

		if self.hDesiredTarget == nil or self.hDesiredTarget:IsAlive() == false then
			self:Destroy()
			return
		end
	end
end

function modifier_boss_mind_control:OnDestroy()
	if IsServer() then
		self:GetParent():SetForceAttackTargetAlly(nil)
		self:GetParent():StopSound("BossMindControl.Loop")
		self:GetParent():EmitSound("BossMindControl.End")
	end
end

function modifier_boss_mind_control:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_OUT_OF_GAME] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_NO_HEALTH_BAR] = true
		state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	end

	return state
end





modifier_boss_mind_control_marked = class ({})

function modifier_boss_mind_control_marked:IsHidden() return true end
function modifier_boss_mind_control_marked:IsDebuff() return true end
function modifier_boss_mind_control_marked:IsPurgable() return false end

function modifier_boss_mind_control_marked:OnCreated(kv)
	if IsServer() then
		local nFXIndex1 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(nFXIndex1, false, false, -1, false, true)
	end
end