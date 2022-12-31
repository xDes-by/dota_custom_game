innate_revenge = class({})

function innate_revenge:GetIntrinsicModifierName()
	return "modifier_innate_revenge"
end

function innate_revenge:Spawn()
	if IsClient() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_innate_second_chance", {})
end

function innate_revenge:OnDestroy()
    if IsClient() then return end
    local modifier = self:GetCaster():FindModifierByName("modifier_innate_second_chance")
    if modifier then
        modifier:Destroy()
    end
end

modifier_innate_revenge = class({})
modifier_innate_second_chance = class({})

LinkLuaModifier("modifier_innate_revenge", "heroes/innates/revenge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_second_chance", "heroes/innates/revenge", LUA_MODIFIER_MOTION_NONE)

function modifier_innate_second_chance:IsHidden() return false end
function modifier_innate_second_chance:IsDebuff() return false end
function modifier_innate_second_chance:IsPurgable() return false end
function modifier_innate_second_chance:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_revenge:IsHidden() return true end
function modifier_innate_revenge:IsDebuff() return false end
function modifier_innate_revenge:IsPurgable() return false end
function modifier_innate_revenge:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_revenge:Revengesplosion()
	if IsClient() then return end

	local parent = self:GetParent()
	local spawns = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil, 2900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _, creep in pairs(spawns) do
		creep:EmitSound("Revenge.Explosion")

		local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(explosion_pfx, 0, creep:GetAbsOrigin())
		ParticleManager:SetParticleControl(explosion_pfx, 1, Vector(100, 0, 0))
		ParticleManager:SetParticleControl(explosion_pfx, 2, creep:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(explosion_pfx)

		ApplyDamage({
			victim = creep,
			attacker = parent,
			damage = creep:GetMaxHealth() * 100,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
		})
	end
end
