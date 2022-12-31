LinkLuaModifier("modifier_creature_shared_soul", "creatures/abilities/regular/creature_shared_soul", LUA_MODIFIER_MOTION_NONE)

creature_shared_soul = class({})

function creature_shared_soul:OnSpellStart()
	if IsServer() then
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_creature_shared_soul", {max_difference = 0.01 * self:GetSpecialValueFor("max_distance")})
		self:SetActivated(false)
	end
end



modifier_creature_shared_soul = class({})

function modifier_creature_shared_soul:IsHidden() return true end
function modifier_creature_shared_soul:IsDebuff() return false end
function modifier_creature_shared_soul:IsPurgable() return false end
function modifier_creature_shared_soul:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_shared_soul:OnCreated(keys)
	self.parent = self:GetParent()

	if IsServer() then
		self.max_difference = keys.max_difference

		self.link_pfx = ParticleManager:CreateParticle("particles/creature/shared_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.link_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(self.link_pfx, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	end
end

function modifier_creature_shared_soul:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.link_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.link_pfx)
	end
end

function modifier_creature_shared_soul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
	return funcs
end

function modifier_creature_shared_soul:GetModifierAvoidDamage(kv)
	if IsClient() then return end
		
	local caster = self:GetCaster()
	if (not caster) or (not caster:IsAlive()) or caster:IsNull() then return end
	local twin_health = caster:GetHealth()
	local max_health = caster:GetMaxHealth()

	if self.parent:GetHealth() - kv.damage > 0 and self.parent:GetHealth() - kv.damage < twin_health - self.max_difference * max_health then
		caster:EmitSound("Twinned_Fates.Threshold_Block")
		local shield_particle = ParticleManager:CreateParticle("particles/items3_fx/lotus_orb_reflect.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(shield_particle)

		self.parent:SetHealth(twin_health - self.max_difference * max_health)
		return 1
	end
end
