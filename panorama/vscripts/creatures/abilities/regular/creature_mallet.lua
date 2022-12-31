LinkLuaModifier("modifier_creature_mallet", "creatures/abilities/regular/creature_mallet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_mallet_debuff", "creatures/abilities/regular/creature_mallet", LUA_MODIFIER_MOTION_NONE)

creature_mallet = class({})

function creature_mallet:GetIntrinsicModifierName()
	return "modifier_creature_mallet"
end



modifier_creature_mallet = class({})

function modifier_creature_mallet:OnCreated()
	if IsClient() then return end

	self.ability = self:GetAbility()

	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creature_mallet:IsHidden() return true end
function modifier_creature_mallet:IsDebuff() return false end
function modifier_creature_mallet:IsPurgable() return false end
function modifier_creature_mallet:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_mallet:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_mallet:GetModifierProcAttack_Feedback(keys)
		if not self.ability or not self.ability:IsCooldownReady() then return end
		if keys.target:IsMagicImmune() or keys.target:HasModifier("modifier_creature_mallet_debuff") then return end

		keys.target:EmitSound("CreatureMallet.Proc")
		keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_mallet_debuff", {
			duration = self.duration * (1 - keys.target:GetStatusResistance()) 
		})
		self.ability:UseResources(false, false, true)
	end
end



modifier_creature_mallet_debuff = class({})

function modifier_creature_mallet_debuff:IsHidden() return false end
function modifier_creature_mallet_debuff:IsDebuff() return true end
function modifier_creature_mallet_debuff:IsPurgable() return false end

function modifier_creature_mallet_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_creature_mallet_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
	return funcs
end

function modifier_creature_mallet_debuff:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end
