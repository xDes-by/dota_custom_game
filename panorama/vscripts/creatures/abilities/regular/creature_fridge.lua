LinkLuaModifier("modifier_creature_fridge", "creatures/abilities/regular/creature_fridge", LUA_MODIFIER_MOTION_NONE)

creature_fridge = class({})

function creature_fridge:GetIntrinsicModifierName()
	return "modifier_creature_fridge"
end

modifier_creature_fridge = class({})

function modifier_creature_fridge:IsHidden() return true end
function modifier_creature_fridge:IsDebuff() return false end
function modifier_creature_fridge:IsPurgable() return false end
function modifier_creature_fridge:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_creature_fridge:RemoveOnDeath() return false end

function modifier_creature_fridge:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_EVENT_ON_ATTACK_START,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
		}
	end
end

function modifier_creature_fridge:OnAttackStart(keys)
	if keys.attacker and keys.attacker == self:GetParent() then
		keys.attacker:SetAngles(0, 0, 0)
	end
end

function modifier_creature_fridge:GetModifierProcAttack_Feedback(keys)
	keys.attacker:SetAngles(45, 0, 0)

	if (not keys.target) then return end

	if RollPercentage(12) then
		keys.target:EmitSound("Fridge.RareHit")
	else
		keys.target:EmitSound("Fridge.Hit")
	end		
end
