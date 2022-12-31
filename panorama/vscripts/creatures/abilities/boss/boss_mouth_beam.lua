boss_mouth_beam = class({})
LinkLuaModifier( "modifier_boss_mouth_beam", "creatures/abilities/boss/boss_mouth_beam", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_siltbreaker_passive", "creatures/abilities/boss/boss_mouth_beam", LUA_MODIFIER_MOTION_NONE )

function boss_mouth_beam:GetIntrinsicModifierName()
	return "modifier_siltbreaker_passive"
end

function boss_mouth_beam:OnAbilityPhaseStart()
	if IsServer() then
		self.nChannelFX = ParticleManager:CreateParticle("particles/creature/boss_beam_channel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	end
	return true
end

function boss_mouth_beam:OnSpellStart()
	if IsServer() then
		self.beam_range = self:GetSpecialValueFor("beam_range")
		self.initial_delay = self:GetSpecialValueFor("initial_delay")
		self.channel_time = self:GetChannelTime()

		local vDirection = self:GetCursorTarget():GetOrigin() - self:GetCaster():GetOrigin()
		vDirection.z = 0.0
		vDirection = vDirection:Normalized()

		local vCasterPos = self:GetCaster():GetAbsOrigin()
		local vBeamEnd = vCasterPos + vDirection * self.beam_range

		local kv = {
			duration = self.channel_time,
			vBeamEndX = vBeamEnd.x,
			vBeamEndY = vBeamEnd.y,
			vBeamEndZ = vCasterPos.z, -- don't want to pick weird Z if endpoint is on some different height
		}

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_mouth_beam", kv)

		self:GetCaster():EmitSound("BossMouthBeam.Cast")
		self:GetCaster():EmitSound("BossMouthBeam.Loop")
	end
end

function boss_mouth_beam:OnChannelFinish(bInterrupted)
	if IsServer() then
		ParticleManager:DestroyParticle(self.nChannelFX, false)
		self:GetCaster():StopSound("BossMouthBeam.Cast")
		self:GetCaster():StopSound("BossMouthBeam.Loop")
		self:GetCaster():EmitSound("BossMouthBeam.End")
		self:GetCaster():RemoveModifierByName("modifier_boss_mouth_beam")
	end
end





modifier_siltbreaker_passive = class ({})

function modifier_siltbreaker_passive:IsHidden() return true end
function modifier_siltbreaker_passive:IsPurgable() return false end
function modifier_siltbreaker_passive:IsPurgable() return false end
function modifier_siltbreaker_passive:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_siltbreaker_passive:OnCreated(keys)
	if IsServer() then
		self:GetCaster():AddItemByName("item_ultimate_scepter")
	end
end





modifier_boss_mouth_beam = class({})

function modifier_boss_mouth_beam:GetActivityTranslationModifiers(params)
	return "channelling"
end

function modifier_boss_mouth_beam:OnCreated(kv)
	if IsServer() then
		self.damage_per_tick = self:GetAbility():GetSpecialValueFor("damage_per_tick")
		self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
		self.damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
		self.beam_range = self:GetAbility():GetSpecialValueFor("beam_range")
		self.turn_rate = self:GetAbility():GetSpecialValueFor("turn_rate")

		self.channel_time = self:GetAbility():GetChannelTime()
		self.bRight = self:GetParent():GetSequence() == "attack_mouthray_r"

		self.hMouth = self:GetParent():ScriptLookupAttachment("attach_mouth")
		self.vBeamStart = self:GetParent():GetAttachmentOrigin(self.hMouth)
		self.vBeamEnd = Vector(kv.vBeamEndX, kv.vBeamEndY, kv.vBeamEndZ)
		self.vBeamDir = self:GetCaster():GetOrigin() - self.vBeamEnd
		self.vBeamDir = self.vBeamDir:Normalized()
		self.CurAngles = self:GetCaster():GetAngles()

		self.nBeamFXIndex = ParticleManager:CreateParticle("particles/creature/boss_mouth_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nBeamFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.nBeamFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", self:GetCaster():GetOrigin(), true)
		ParticleManager:SetParticleControl(self.nBeamFXIndex, 3, self.vBeamEnd)
		self:AddParticle(self.nBeamFXIndex, false, false, -1, false, true)
		self:StartIntervalThink(self.tick_interval)
	end
end

function modifier_boss_mouth_beam:OnIntervalThink()
	if IsServer() then
		self:TickBeam()
	end
end

function modifier_boss_mouth_beam:TickBeam()
	if IsServer() then
		if (not self:GetCaster()) then
			return
		end

		if self.bRight == true then
			self.CurAngles.y = self.CurAngles.y - self.turn_rate * self.tick_interval
		else
			self.CurAngles.y = self.CurAngles.y + self.turn_rate * self.tick_interval
		end

		self.vBeamStart = self:GetParent():GetAttachmentOrigin(self.hMouth)
		self.vBeamDir = RotatePosition(Vector( 0, 0, 0 ), self.CurAngles, Vector( 1, 0, 0 ))
		self.vBeamEnd = self.vBeamStart + self.vBeamDir * self.beam_range
		self.vBeamStart = self.vBeamStart - self.vBeamDir * 125

		local hEnemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self.vBeamStart, self.vBeamEnd, nil, 2 * self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
		for _, hEnemy in pairs(hEnemies) do
			ApplyDamage({victim = hEnemy, attacker = self:GetCaster(), damage = self.damage_per_tick, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})

			local nFXIndex = ParticleManager:CreateParticle("particles/creature/boss_mouth_beam_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnemy)
			ParticleManager:SetParticleControlEnt(nFXIndex, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(nFXIndex )
		end

		self:UpdateBeamEffect()
	end
end

function modifier_boss_mouth_beam:UpdateBeamEffect()
	if (not self:GetCaster()) then
		return
	end

	ParticleManager:SetParticleControlFallback(self.nBeamFXIndex, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlFallback(self.nBeamFXIndex, 1, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControlFallback(self.nBeamFXIndex, 3, self.vBeamEnd)
end

function modifier_boss_mouth_beam:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end

function modifier_boss_mouth_beam:GetModifierDisableTurning(params)
	return 1
end

function modifier_boss_mouth_beam:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_ROOTED] = true
	end

	return state
end
