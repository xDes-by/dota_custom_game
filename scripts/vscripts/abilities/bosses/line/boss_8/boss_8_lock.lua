LinkLuaModifier("modifier_boss_8_lock", "abilities/bosses/line/boss_8/boss_8_lock", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_8_lock_stun", "abilities/bosses/line/boss_8/boss_8_lock", LUA_MODIFIER_MOTION_NONE)

boss_8_lock = class({})

function boss_8_lock:GetIntrinsicModifierName()
	return "modifier_boss_8_lock"
end


--------------------------------

modifier_boss_8_lock = class({})

function modifier_boss_8_lock:IsPurgable()			return false end
function modifier_boss_8_lock:IsDebuff()			return false end
function modifier_boss_8_lock:IsHidden()			return true end

function modifier_boss_8_lock:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
	return funcs
end

function modifier_boss_8_lock:GetModifierProcAttack_BonusDamage_Magical( keys )
	if IsServer() then
		local target = keys.target		-- Unit getting hit
		local attacker = keys.attacker	-- Unit landing the hit
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local bonus_damage_to_main_target = 0

		if parent == attacker and not target:IsOther() and not target:IsBuilding() and not parent:PassivesDisabled() and parent:GetTeamNumber() ~= target:GetTeamNumber() then
			local bashChance = ability:GetSpecialValueFor("bash_chance")
			local bashDamage = ability:GetSpecialValueFor("bash_damage")
			local bashDuration = ability:GetSpecialValueFor("bash_duration")

			if RandomInt(0,100) < bashChance then
				target:AddNewModifier(parent, ability, "modifier_boss_8_lock_stun", { duration = bashDuration * (1 - target:GetStatusResistance())})
				ApplyDamage({attacker = parent, victim = enemy, ability = ability, damage = bashDamage, damage_type = DAMAGE_TYPE_MAGICAL})
				EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", enemy)
			end
		end
	end
end

--------------------------------

if modifier_boss_8_lock_stun == nil then modifier_boss_8_lock_stun = class({}) end
function modifier_boss_8_lock_stun:IsPurgable()		return false end
function modifier_boss_8_lock_stun:IsDebuff()			return true end
function modifier_boss_8_lock_stun:IsHidden()			return true end
function modifier_boss_8_lock_stun:IsStunDebuff()		return true end
function modifier_boss_8_lock_stun:IsPurgeException()	return true end

function modifier_boss_8_lock_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf" end

function modifier_boss_8_lock_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW end

function modifier_boss_8_lock_stun:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(128,128,255)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack02.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

function modifier_boss_8_lock_stun:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end end

function modifier_boss_8_lock_stun:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end