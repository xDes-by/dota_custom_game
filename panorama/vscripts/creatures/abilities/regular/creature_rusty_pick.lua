LinkLuaModifier("modifier_creature_rusty_pick", "creatures/abilities/regular/creature_rusty_pick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_rusty_pick_debuff", "creatures/abilities/regular/creature_rusty_pick", LUA_MODIFIER_MOTION_NONE)

creature_rusty_pick = class({})

function creature_rusty_pick:GetIntrinsicModifierName()
	return "modifier_creature_rusty_pick"
end



modifier_creature_rusty_pick = class({})

function modifier_creature_rusty_pick:OnCreated()
	if IsClient() then return end

	self.ability = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_creature_rusty_pick:IsHidden() return true end
function modifier_creature_rusty_pick:IsDebuff() return false end
function modifier_creature_rusty_pick:IsPurgable() return false end
function modifier_creature_rusty_pick:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if IsServer() then
	function modifier_creature_rusty_pick:DeclareFunctions()
		local funcs = {
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
		return funcs
	end

	function modifier_creature_rusty_pick:GetModifierProcAttack_Feedback(keys)
		if not self.ability or not self.ability:IsCooldownReady() then return end
		if keys.target:IsMagicImmune() or keys.target:HasModifier("modifier_creature_rusty_pick_debuff") then return end

		keys.target:EmitSound("CreatureRustyPick.Proc")
		keys.target:AddNewModifier(keys.attacker, self.ability, "modifier_creature_rusty_pick_debuff", {duration = self.duration})
		ability:UseResources(false, false, true)
	end
end



modifier_creature_rusty_pick_debuff = class({})

function modifier_creature_rusty_pick_debuff:IsHidden() return false end
function modifier_creature_rusty_pick_debuff:IsDebuff() return true end
function modifier_creature_rusty_pick_debuff:IsPurgable() return true end

function modifier_creature_rusty_pick_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end
