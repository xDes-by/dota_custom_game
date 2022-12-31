LinkLuaModifier("modifier_creature_countershock", "creatures/abilities/regular/creature_countershock", LUA_MODIFIER_MOTION_NONE)

creature_countershock = class({})

function creature_countershock:GetIntrinsicModifierName()
	return "modifier_creature_countershock"
end



modifier_creature_countershock = class({})

function modifier_creature_countershock:IsHidden() return true end
function modifier_creature_countershock:IsDebuff() return false end
function modifier_creature_countershock:IsPurgable() return false end
function modifier_creature_countershock:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

if not IsServer() then return end

function modifier_creature_countershock:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
	}
	return funcs
end

function modifier_creature_countershock:GetModifierIncomingDamage_Percentage(keys)
	local ability = self:GetAbility()
	if not ability or not ability:IsCooldownReady() then return end

	ability:UseResources(false, false, true)

	local parent_loc = keys.target:GetAbsOrigin()
	local damage = ability:GetSpecialValueFor("damage")

	keys.target:EmitSound("CreatureCountershock.Proc")

	local zap_pfx = ParticleManager:CreateParticle("particles/creature/countershock.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(zap_pfx, 0, parent_loc + Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(zap_pfx)

	local enemies = FindUnitsInRadius(
		keys.target:GetTeam(), 
		parent_loc,
		nil, 
		ability:GetSpecialValueFor("radius"), 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	)
	for _, enemy in pairs(enemies) do
		local actual_damage = ApplyDamage({
			victim = enemy, 
			attacker = keys.target, 
			damage = damage, 
			damage_type = DAMAGE_TYPE_MAGICAL
		})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, actual_damage, nil)
		enemy:Purge(true, false, false, false, false)
	end
end
