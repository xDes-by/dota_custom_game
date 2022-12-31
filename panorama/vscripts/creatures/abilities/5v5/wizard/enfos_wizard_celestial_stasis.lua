enfos_wizard_celestial_stasis = class({})

LinkLuaModifier("modifier_celestial_stasis_creep_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_celestial_stasis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_celestial_stasis_hero_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_celestial_stasis", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_celestial_stasis:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local duration = self:GetSpecialValueFor("duration")

	EmitGlobalSound("wizard_celestial_stasis")
	EmitGlobalSound("wizard_celestial_stasis_loop")

	local elapsed_duration = 0

	Timers:CreateTimer(0, function()

		for _, creep in pairs(Enfos.current_creeps[team]) do
			if creep:IsAlive() and not creep:HasModifier("modifier_celestial_stasis_creep_debuff") then
				creep:AddNewModifier(caster, nil, "modifier_celestial_stasis_creep_debuff", {duration = duration - elapsed_duration})
			end
		end

		for _, hero in pairs(HeroList:GetAllHeroes()) do
			if hero:IsAlive() and hero:GetTeam() ~= team and not hero:HasModifier("modifier_celestial_stasis_hero_debuff") then
				if hero:IsIllusion() then
					hero:AddNewModifier(caster, nil, "modifier_celestial_stasis_creep_debuff", {duration = duration - elapsed_duration})
				else
					hero:AddNewModifier(caster, nil, "modifier_celestial_stasis_hero_debuff", {duration = duration - elapsed_duration})
				end
			end
		end

		elapsed_duration = elapsed_duration + 0.1
		if elapsed_duration < duration then
			return 0.1
		else
			StopGlobalSound("wizard_celestial_stasis_loop")
		end
	end)

	EnfosWizard:CastSpellResult(caster, "celestial_stasis")
end



modifier_celestial_stasis_creep_debuff = class({})

function modifier_celestial_stasis_creep_debuff:IsHidden() return false end
function modifier_celestial_stasis_creep_debuff:IsDebuff() return true end
function modifier_celestial_stasis_creep_debuff:IsPurgable() return false end

function modifier_celestial_stasis_creep_debuff:GetTexture() return "enfos_wizard_celestial_stasis" end

function modifier_celestial_stasis_creep_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true
	}
end



modifier_celestial_stasis_hero_debuff = class({})

function modifier_celestial_stasis_hero_debuff:IsHidden() return false end
function modifier_celestial_stasis_hero_debuff:IsDebuff() return true end
function modifier_celestial_stasis_hero_debuff:IsPurgable() return false end

function modifier_celestial_stasis_hero_debuff:GetTexture() return "enfos_wizard_celestial_stasis" end

function modifier_celestial_stasis_hero_debuff:GetEffectName()
	return "particles/5v5/celestial_stasis_debuff.vpcf"
end

function modifier_celestial_stasis_hero_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_celestial_stasis_hero_debuff:GetStatusEffectName()
	return "particles/5v5/celestial_statis_status_effect.vpcf"
end

function modifier_celestial_stasis_hero_debuff:OnCreated(keys)
	if IsClient() then return end

	self.aura_pfx = ParticleManager:CreateParticle("particles/5v5/enfos_wizard_celestial_stasis_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.aura_pfx, 1, Vector(250, 250, 250))
	self:AddParticle(self.aura_pfx, false, false, 255, true, false)
end

function modifier_celestial_stasis_hero_debuff:OnDestroy()
	if IsClient() then return end

	if self.aura_pfx then
		ParticleManager:DestroyParticle(self.aura_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.aura_pfx)
	end
end

function modifier_celestial_stasis_hero_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end

function modifier_celestial_stasis_hero_debuff:GetModifierMoveSpeedBonus_Percentage() return -10000 end
function modifier_celestial_stasis_hero_debuff:GetModifierAttackSpeedBonus_Constant() return -10000 end
function modifier_celestial_stasis_hero_debuff:GetModifierProjectileSpeedBonus() return -500 end
function modifier_celestial_stasis_hero_debuff:GetModifierTurnRate_Percentage() return -90 end
function modifier_celestial_stasis_hero_debuff:GetModifierPercentageCooldown() return -100 end
