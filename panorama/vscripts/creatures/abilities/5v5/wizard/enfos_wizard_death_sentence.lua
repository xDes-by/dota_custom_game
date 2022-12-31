enfos_wizard_death_sentence = class({})

LinkLuaModifier("modifier_death_sentence_delay", "creatures/abilities/5v5/wizard/enfos_wizard_death_sentence", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_death_sentence_debuff", "creatures/abilities/5v5/wizard/enfos_wizard_death_sentence", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_death_sentence:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local delay = self:GetSpecialValueFor("delay")

	target:EmitSound("Wizard.DeathSentence.Cast")

	local cast_pfx = ParticleManager:CreateParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	target:AddNewModifier(caster, self, "modifier_death_sentence_delay", {duration = delay})

	EnfosWizard:CastSpellResult(caster, "death_sentence")
end

modifier_death_sentence_delay = class({})

function modifier_death_sentence_delay:IsHidden() return false end
function modifier_death_sentence_delay:IsDebuff() return true end
function modifier_death_sentence_delay:IsPurgable() return false end
function modifier_death_sentence_delay:IsPurgeException() return false end
function modifier_death_sentence_delay:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_death_sentence_delay:GetTexture() return "enfos_wizard_death_sentence" end

function modifier_death_sentence_delay:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_death_sentence_delay:OnCreated(keys)
	if IsClient() then return end

	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.health = self:GetAbility():GetSpecialValueFor("health")
	
	local time = tostring(keys.duration):reverse()
	local first_digit = tonumber(string.sub(time, 1, 1))
	local second_digit = tonumber(string.sub(time, 2, 2))
	
	self.count_pfx = ParticleManager:CreateParticle("particles/5v5/enfos_wizard_death_sentence_counter.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.count_pfx, 2, Vector(1, first_digit, second_digit))
	self:AddParticle(self.count_pfx, true, false, 255, true, true)

	self:StartIntervalThink(1)
end 

function modifier_death_sentence_delay:OnIntervalThink()
	if not self.count_pfx then return end 

	self:GetParent():EmitSound("Wizard.DeathSentence.Tick")

	local time = tostring(math.ceil(self:GetRemainingTime())):reverse()
	local first_digit = tonumber(string.sub(time, 1, 1))
	local second_digit = tonumber(string.sub(time, 2, 2))
	
	local needs_new_particle = (second_digit == "")

	if needs_new_particle and (not self.new_particle_created) then 
		self.new_particle_created = true

		ParticleManager:DestroyParticle(self.count_pfx, true)
		ParticleManager:ReleaseParticleIndex(self.count_pfx)

		self.count_pfx = ParticleManager:CreateParticle('particles/5v5/enfos_wizard_death_sentence_counter_b.vpcf', PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.count_pfx, true, false, 255, true, true)
	end 

	if needs_new_particle then 
		ParticleManager:SetParticleControl(self.count_pfx, 2, Vector(1, first_digit, 0))
	else
		ParticleManager:SetParticleControl(self.count_pfx, 2, Vector(1, first_digit, second_digit))
	end
end

function modifier_death_sentence_delay:OnDestroy()
	if IsClient() then return end
	local parent = self:GetParent()

	parent:EmitSound("Wizard.DeathSentence.End")

	if parent:IsAlive() then
		parent:SetHealth(self.health)
	end

	parent:Purge(true, false, false, false, true)
	parent:AddNewModifier(self:GetCaster(), nil, "modifier_death_sentence_debuff", {duration = self.duration})

	local proc_pfx = ParticleManager:CreateParticle("particles/econ/items/doom/doom_ti8_immortal_arms/doom_ti8_immortal_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(proc_pfx, 1, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(proc_pfx)
end



modifier_death_sentence_debuff = class({})

function modifier_death_sentence_debuff:IsHidden() return false end
function modifier_death_sentence_debuff:IsDebuff() return true end
function modifier_death_sentence_debuff:IsPurgable() return false end
function modifier_death_sentence_debuff:IsPurgeException() return false end
function modifier_death_sentence_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_death_sentence_debuff:GetTexture() return "enfos_wizard_death_sentence" end

function modifier_death_sentence_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_death_sentence_debuff:OnCreated()
	if IsClient() then return end
	
	self.doom_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_doom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.doom_pfx, 60, Vector(255, 140, 0))
	ParticleManager:SetParticleControl(self.doom_pfx, 61, Vector(1, 0, 0))

	self:AddParticle(self.doom_pfx, true, false, 255, true, false)
end

function modifier_death_sentence_debuff:OnDestroy()
	if IsClient() then return end

	ParticleManager:DestroyParticle(self.doom_pfx, false)
	ParticleManager:ReleaseParticleIndex(self.doom_pfx)
end

function modifier_death_sentence_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end

function modifier_death_sentence_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_death_sentence_debuff:GetDisableHealing()
	return 1
end
