boss_tail_spin = class({})
--LinkLuaModifier("modifier_siltbreaker_passive",  "creatures/abilities/boss/boss_tail_spin", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_tail_spin",  "creatures/abilities/boss/boss_tail_spin", LUA_MODIFIER_MOTION_NONE)


function boss_tail_spin:GetIntrinsicModifierName()
	return "modifier_siltbreaker_passive"
end

function boss_tail_spin:OnAbilityPhaseStart()
	if IsServer() then
		self.animation_time = self:GetSpecialValueFor("animation_time")
		self.initial_delay = self:GetSpecialValueFor("initial_delay")

		local kv = {}
		kv["duration"] = self.animation_time
		kv["initial_delay"] = self.initial_delay

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_boss_tail_spin", kv)

		self:GetCaster():EmitSound("BossTailSpin.Windup")
	end

	return true
end

function boss_tail_spin:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName("modifier_boss_tail_spin")
	end
end

function boss_tail_spin:OnSpellStart()
	self:GetCaster():StopSound("BossTailSpin.Windup")
end





modifier_boss_tail_spin = class ({})

function modifier_boss_tail_spin:IsHidden() return true end
function modifier_boss_tail_spin:IsPurgable() return false end

function modifier_boss_tail_spin:OnCreated(kv)
	if IsServer() then
		self.nPreviewFX = ParticleManager:CreateParticle("particles/creature/boss_tail_tell.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.nPreviewFX, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_tail_01", self:GetCaster():GetOrigin(), true)
		
		self.damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
		self.knockback_distance = self:GetAbility():GetSpecialValueFor("knockback_distance")
		self.knockback_height = self:GetAbility():GetSpecialValueFor("knockback_height")
		self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")

		self.hHitTargets = {}

		self:StartIntervalThink(kv[ "initial_delay" ])
		self.swipe_sound_played = false
	end
end

function modifier_boss_tail_spin:OnIntervalThink()
	if IsServer() then
		local tail1 = self:GetParent():ScriptLookupAttachment("attach_tail_01")
		local tail2 = self:GetParent():ScriptLookupAttachment("attach_tail_02")
		local tail3 = self:GetParent():ScriptLookupAttachment("attach_tail_03")
		local tail4 = self:GetParent():ScriptLookupAttachment("attach_tail_04")
		local vLocation1 = self:GetParent():GetAttachmentOrigin(tail1)
		local vLocation2 = self:GetParent():GetAttachmentOrigin(tail2)
		local vLocation3 = self:GetParent():GetAttachmentOrigin(tail3)
		local vLocation4 = self:GetParent():GetAttachmentOrigin(tail4)
		local Locations = {}
		table.insert(Locations, vLocation1)
		table.insert(Locations, vLocation2)
		table.insert(Locations, vLocation3)
		table.insert(Locations, vLocation4)

		if not self.swipe_sound_played then
			self.swipe_sound_played = true
			self:GetCaster():EmitSound("BossTailSpin.Swipe")
		end
			
		self:StartIntervalThink(0.01)

		for _, vPos in pairs(Locations) do
			local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), vPos, self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _, enemy in pairs(enemies) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and self:HasHitTarget(enemy) == false then
					self:AddHitTarget(enemy)

					local damageInfo = {
						victim = enemy,
						attacker = self:GetParent(),
						damage = self.damage,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self,
					}

					ApplyDamage(damageInfo)

					local kv = {
						center_x = self:GetParent():GetOrigin().x,
						center_y = self:GetParent():GetOrigin().y,
						center_z = self:GetParent():GetOrigin().z,
						should_stun = true, 
						duration = self.stun_duration,
						knockback_duration = self.stun_duration,
						knockback_distance = self.knockback_distance,
						knockback_height = self.knockback_height,
					}

					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", kv)
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_polar_furbolg_ursa_warrior_thunder_clap", {duration = self.slow_duration * (1 - enemy:GetStatusResistance()) })

					enemy:EmitSound("DOTA_Item.Maim")
				end
			end
		end
	end
end

function modifier_boss_tail_spin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	return funcs
end

function modifier_boss_tail_spin:GetModifierDisableTurning()
	return 1
end

function modifier_boss_tail_spin:HasHitTarget(hTarget)
	for _, target in pairs(self.hHitTargets) do
		if target == hTarget then
	    	return true
	    end
	end
	
	return false
end

function modifier_boss_tail_spin:AddHitTarget(hTarget)
	table.insert(self.hHitTargets, hTarget)
end

function modifier_boss_tail_spin:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nPreviewFX, false)
	end
end
