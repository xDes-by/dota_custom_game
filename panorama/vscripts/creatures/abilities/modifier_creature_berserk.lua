modifier_creature_berserk = class({})

function modifier_creature_berserk:GetTexture() return "ogre_magi_bloodlust" end
function modifier_creature_berserk:IsHidden() return false end
function modifier_creature_berserk:IsDebuff() return false end
function modifier_creature_berserk:IsPurgable() return false end
function modifier_creature_berserk:IsPermanent() return false end
function modifier_creature_berserk:GetEffectName() return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf" end

function modifier_creature_berserk:OnCreated(keys)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_truesight_aura", {})
		self:StartIntervalThink(1.0)
	end
end

function modifier_creature_berserk:OnIntervalThink()
	if IsServer() then
		self:IncrementStackCount()
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 200, true )
	end
end

function modifier_creature_berserk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}
	return funcs
end


function modifier_creature_berserk:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
	return state
end

function modifier_creature_berserk:GetModifierSpellAmplify_Percentage() return self:GetStackCount() * 15 end
function modifier_creature_berserk:GetModifierStatusResistanceStacking() return self:GetStackCount() * 5 end
function modifier_creature_berserk:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount() * 5 end
function modifier_creature_berserk:GetModifierDamageOutgoing_Percentage() return self:GetStackCount() * 15 end
function modifier_creature_berserk:GetModifierMoveSpeedBonus_Constant() return self:GetStackCount() * 30 end
function modifier_creature_berserk:GetModifierAttackRangeBonus() return 300 end
function modifier_creature_berserk:GetModifierModelScale() return math.min(2 * self:GetStackCount(), 40) end
function modifier_creature_berserk:GetModifierIgnoreMovespeedLimit() return 1 end
function modifier_creature_berserk:GetModifierPercentageCasttime() return 100 end

if IsClient() then return end

function modifier_creature_berserk:GetModifierProcAttack_Feedback(keys)
	if keys.target then
		local modifier = keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_creature_armor_reduction_boost", {duration = 10})
		if modifier then
			modifier:SetStackCount(modifier:GetStackCount() + 10)
		end
	end

	if self:GetStackCount() > 60 then
		ApplyDamage({
			attacker = keys.attacker, 
			victim = keys.target, 
			damage_type = DAMAGE_TYPE_PURE, 
			damage = keys.target:GetMaxHealth() * 0.01 * (self:GetStackCount() - 60), 
			damage_flags = DOTA_DAMAGE_FLAG_HPLOSS
		})
	end
end
