LinkLuaModifier("modifier_creature_crab_claw", "creatures/abilities/regular/creature_crab_claw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_crab_claw_debuff", "creatures/abilities/regular/creature_crab_claw", LUA_MODIFIER_MOTION_NONE)

creature_crab_claw = class({})

function creature_crab_claw:GetIntrinsicModifierName()
	return "modifier_creature_crab_claw"
end



modifier_creature_crab_claw = class({})

function modifier_creature_crab_claw:OnCreated()
	if IsClient() then return end

	self.ability = self:GetAbility()
	self.proc_chance = self.ability:GetSpecialValueFor("proc_chance")
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creature_crab_claw:IsHidden() return true end
function modifier_creature_crab_claw:IsDebuff() return false end
function modifier_creature_crab_claw:IsPurgable() return false end
function modifier_creature_crab_claw:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


if IsServer() then
	function modifier_creature_crab_claw:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_crab_claw:GetModifierProcAttack_Feedback(keys)
		if self.ability and self.ability:IsCooldownReady() and RollPercentage(self.proc_chance) then
			keys.target:EmitSound("CreatureCrabClaw.Proc")
			keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_crab_claw_debuff", {
				duration = self.duration * (1 - keys.target:GetStatusResistance()) 
			})
			self.ability:UseResources(false, false, true)
		end
	end
end


modifier_creature_crab_claw_debuff = class({})

function modifier_creature_crab_claw_debuff:IsHidden() return false end
function modifier_creature_crab_claw_debuff:IsDebuff() return true end
function modifier_creature_crab_claw_debuff:IsPurgable() return true end

function modifier_creature_crab_claw_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end
