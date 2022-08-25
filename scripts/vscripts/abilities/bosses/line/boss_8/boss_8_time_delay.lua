LinkLuaModifier("modifier_boss_8_time_delay_debuff", "abilities/bosses/line/boss_8/boss_8_time_delay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_8_time_delay_stun", "abilities/bosses/line/boss_8/boss_8_time_delay", LUA_MODIFIER_MOTION_NONE)

boss_8_time_delay = class({})

function boss_8_time_delay:OnSpellStart()
if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy:IsRealHero() then
			enemy:EmitSound("Hero_FacelessVoid.TimeDilation.Target")

			local hit_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, enemy)
			ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(hit_pfx)
		
			local hit_pfx_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_d.vpcf", PATTACH_ABSORIGIN, enemy)
			ParticleManager:ReleaseParticleIndex(hit_pfx_2)
			
			local abilities_on_cooldown = 0
			for i = 0, 23 do
				local current_ability = enemy:GetAbilityByIndex(i)
				if current_ability and not current_ability:IsPassive() and not current_ability:IsAttributeBonus() and not current_ability:IsCooldownReady() then
					current_ability:StartCooldown( current_ability:GetCooldownTimeRemaining() + self:GetSpecialValueFor("duration") )
					abilities_on_cooldown = abilities_on_cooldown + 1
				end
			end

			if abilities_on_cooldown > 0 then
				local debuff = enemy:AddNewModifier(self:GetCaster(), self, "modifier_boss_8_time_delay_debuff", {duration =  self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
			end
			
			self:GetCaster():PerformAttack(enemy, false, true, true, true, true, false, false)
			EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", enemy)
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_boss_8_time_delay_stun", {duration =  1})
		end
	end
end

---------------------------------------------------------------------------------------------------------------------
modifier_boss_8_time_delay_debuff = class({})
function modifier_boss_8_time_delay_debuff:IsHidden() return true end
function modifier_boss_8_time_delay_debuff:IsDebuff() return true end
function modifier_boss_8_time_delay_debuff:IsPurgable() return true end
function modifier_boss_8_time_delay_debuff:IsPurgeException() return true end
function modifier_boss_8_time_delay_debuff:RemoveOnDeath() return true end

function modifier_boss_8_time_delay_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
		}
	return funcs
end

function modifier_boss_8_time_delay_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end	

function modifier_boss_8_time_delay_debuff:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("slow")
end

-----------------------------------------------------------------------------------------------------------------------

modifier_boss_8_time_delay_stun  = class({})
function modifier_boss_8_time_delay_stun:IsPurgable()		return false end
function modifier_boss_8_time_delay_stun:IsDebuff()			return true end
function modifier_boss_8_time_delay_stun:IsHidden()			return true end
function modifier_boss_8_time_delay_stun:IsStunDebuff()		return true end
function modifier_boss_8_time_delay_stun:IsPurgeException()	return true end

function modifier_boss_8_time_delay_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_boss_8_time_delay_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_boss_8_time_delay_stun:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(128,128,255)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_boss_8_time_delay_stun:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end end

function modifier_boss_8_time_delay_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end