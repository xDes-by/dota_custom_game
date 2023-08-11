-------------------------------------------
--			REAPER'S SCYTHE
-------------------------------------------
imba_necrolyte_reapers_scythe = imba_necrolyte_reapers_scythe or class({})
LinkLuaModifier("modifier_imba_reapers_scythe", "heroes/hero_necrolyte/necrolyte_reapers_scythe/necrolyte_reapers_scythe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_reapers_scythe_debuff", "heroes/hero_necrolyte/necrolyte_reapers_scythe/necrolyte_reapers_scythe", LUA_MODIFIER_MOTION_NONE)

function imba_necrolyte_reapers_scythe:GetAbilityTextureName()
	return "necrolyte_reapers_scythe"
end

function imba_necrolyte_reapers_scythe:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		if target:TriggerSpellAbsorb(self) then
			return nil
		end

		-- Cast sound
		caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
		target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
		if (math.random(1,100) <= 30) and (caster:GetName() == "npc_dota_hero_necrolyte") then
			caster:EmitSound("necrolyte_necr_ability_reap_0"..math.random(1,3))
		end

		-- Parameters
		local damage = self:GetSpecialValueFor("damage")
		local stun_duration = self:GetSpecialValueFor("stun_duration")

		target:AddNewModifier(caster, self, "modifier_imba_reapers_scythe", {duration = stun_duration})
	end
end

function imba_necrolyte_reapers_scythe:GetCooldown( nLevel )
	if self:GetCaster():HasScepter() then return self:GetSpecialValueFor("scepter_cooldown") end
	return self.BaseClass.GetCooldown( self, nLevel )
end

function imba_necrolyte_reapers_scythe:IsHiddenWhenStolen()
	return false
end

modifier_imba_reapers_scythe = modifier_imba_reapers_scythe or class({})
function modifier_imba_reapers_scythe:IgnoreTenacity() return true end
function modifier_imba_reapers_scythe:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor("damage")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_imba_reapers_scythe:OnRefresh()
		if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		self.ability = self:GetAbility()
		self.damage = self.ability:GetSpecialValueFor("damage")

		local stun_fx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_stunned.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
		self:AddParticle(stun_fx, false, false, -1, false, false)
		local orig_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_orig.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		self:AddParticle(orig_fx, false, false, -1, false, false)

		local scythe_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt(scythe_fx, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(scythe_fx, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(scythe_fx)
	end
end

function modifier_imba_reapers_scythe:GetEffectName()
	return "particles/units/heroes/hero_necrolyte/necrolyte_scythe.vpcf"
end

function modifier_imba_reapers_scythe:StatusEffectPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_reapers_scythe:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

function modifier_imba_reapers_scythe:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_imba_reapers_scythe:CheckState()
	local state =
		{
			[MODIFIER_STATE_STUNNED] = true
		}
	return state
end

function modifier_imba_reapers_scythe:IsPurgable() return false end
function modifier_imba_reapers_scythe:IsPurgeException() return false end

function modifier_imba_reapers_scythe:DeclareFunctions()
	local decFuncs =
		{
			MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		}
	return decFuncs
end

function modifier_imba_reapers_scythe:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_imba_reapers_scythe:OnRemoved()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		
		-- I don't know why this thing allows a frame for enemies to activate magic immunity before receiving damage but only if Reaper's Scythe would have been fatal...so let's just stun them for another frame
		target:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration=FrameTime()})
		
		if target:IsAlive() and self.ability then
			self.damage = self.damage * (target:GetMaxHealth() - target:GetHealth())
			-- If this very rough formula for damage exceeds that of the target's health, apply the respawn modifier that increases respawn time of target...
			if (self.damage * (1 + (caster:GetSpellAmplification(false) * 0.01)) * (1 - target:Script_GetMagicalArmorValue(true, caster))) >= target:GetHealth() then
			end
			-- Deals damage (optimally, the ApplyDamage float number would be used for calculating whether the respawn modifier should be applied.
			-- However, that doesn't seem to be possible without actually inflicting the damage, and modifiers cannot be applied on dead units)
			local actually_dmg = ApplyDamage({attacker = caster, victim = target, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_DAMAGE, target, actually_dmg, nil)
			
			-- ...HOWEVER, in the case of the target not actually dying under scythe due to incorrect calculations (ex. Dazzle Grave, Oracle False Promise, Bristleback damage reduction, etc.), remove the modifier
			-- This will prevent a indefinitely lingering respawn modifier that increases respawn time (or worse) upon an actual death later

		end
	end
end

modifier_imba_reapers_scythe_debuff = modifier_imba_reapers_scythe_debuff or class({})

function modifier_imba_reapers_scythe_debuff:IsDebuff()
	return true
end

function modifier_imba_reapers_scythe_debuff:IsPurgable()
	return false
end

function modifier_imba_reapers_scythe_debuff:GetStatusEffectName()
	return "particles/hero/necrophos/status_effect_reaper_scythe_sickness.vpcf"
end

function modifier_imba_reapers_scythe_debuff:OnCreated( params )
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_reduction_pct = self:GetAbility():GetSpecialValueFor("damage_reduction_pct") * (-1)
	self.spellpower_reduction = self:GetAbility():GetSpecialValueFor("spellpower_reduction") * (-1)
end

function modifier_imba_reapers_scythe_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_imba_reapers_scythe_debuff:GetModifierSpellAmplify_Percentage()
	return self.spellpower_reduction
end

function modifier_imba_reapers_scythe_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.damage_reduction_pct
end