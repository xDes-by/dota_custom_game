LinkLuaModifier("modifier_creature_troll_heal", "creatures/abilities/regular/creature_troll_heal", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_troll_heal_effect", "creatures/abilities/regular/creature_troll_heal", LUA_MODIFIER_MOTION_NONE)

creature_troll_heal = class({})

function creature_troll_heal:OnSpellStart()
	if IsServer() then
		local target = self:GetCursorTarget()

		target:EmitSound("TrollHeal.Cast")

		target:AddNewModifier(self:GetCaster(), self, "modifier_creature_troll_heal", {duration = self:GetSpecialValueFor("duration"), heal = self:GetSpecialValueFor("hps")})
	end
end



modifier_creature_troll_heal = class({})

function modifier_creature_troll_heal:IsHidden() return false end
function modifier_creature_troll_heal:IsDebuff() return false end
function modifier_creature_troll_heal:IsPurgable() return true end
function modifier_creature_troll_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_troll_heal:GetEffectName()
	return "particles/generic_gameplay/rune_regen_owner.vpcf"
end

function modifier_creature_troll_heal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_troll_heal:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.heal)
		self:OnIntervalThink()
		self:StartIntervalThink(1.0)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_creature_troll_heal_effect", {})
	end
end

function modifier_creature_troll_heal:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_creature_troll_heal_effect")
	end
end

function modifier_creature_troll_heal:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local heal_tick = 0.01 * self:GetStackCount() * (parent:GetMaxHealth() - parent:GetHealth())

		parent:Heal(heal_tick, nil)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, parent, heal_tick, nil)

		local heal_pfx = ParticleManager:CreateParticle("particles/neutral_fx/troll_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(heal_pfx, 0, parent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(heal_pfx)
	end
end

function modifier_creature_troll_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

function modifier_creature_troll_heal:OnTooltip()
	return self:GetStackCount()
end




modifier_creature_troll_heal_effect = class({})

function modifier_creature_troll_heal_effect:IsHidden() return true end
function modifier_creature_troll_heal_effect:IsDebuff() return false end
function modifier_creature_troll_heal_effect:IsPurgable() return true end
function modifier_creature_troll_heal_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_creature_troll_heal_effect:GetEffectName()
	return "particles/creature/troll_heal_buff.vpcf"
end

function modifier_creature_troll_heal_effect:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_creature_troll_heal_effect:ShouldUseOverheadOffset()
	return true
end
