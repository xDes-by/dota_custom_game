LinkLuaModifier("modifier_nyx_borrow", "abilities/bosses/dust/nyx_borrow", LUA_MODIFIER_MOTION_NONE)

nyx_borrow = class({})

function nyx_borrow:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_duration = self:GetSpecialValueFor("duration")
		caster:AddNewModifier(caster, self, "modifier_nyx_borrow", { duration = buff_duration })
	end
end

---------------------------------------------------------------------------------
modifier_nyx_borrow = class({})

modifier_nyx_borrow = class({})

function modifier_nyx_borrow:IsHidden() return true end
function modifier_nyx_borrow:IsPurgable() return false end
function modifier_nyx_borrow:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_nyx_borrow:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_nyx_borrow:GetEffectAttachType() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_nyx_borrow:StatusEffectPriority() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end

function modifier_nyx_borrow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_nyx_borrow:OnCreated()
	if IsServer() then
		self.target_current_health = self:GetParent():GetHealth()
		self:GetParent():EmitSound("Hero_Abaddon.BorrowedTime")
		self:GetParent():Purge(false, true, false, true, false)
	end
end

function modifier_nyx_borrow:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		local target_vector = self:GetParent():GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)
		local current_health = self:GetParent():GetHealth()
		local max_health = self:GetParent():GetMaxHealth()
		self:GetParent():HealWithParams(kv.damage, self:GetAbility(), false, true, self:GetCaster(), false)
		return -9999999
	end
end
