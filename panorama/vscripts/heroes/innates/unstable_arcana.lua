innate_unstable_arcana = class({})

LinkLuaModifier("modifier_innate_unstable_arcana", "heroes/innates/unstable_arcana", LUA_MODIFIER_MOTION_NONE)

function innate_unstable_arcana:GetIntrinsicModifierName()
	return "modifier_innate_unstable_arcana"
end





modifier_innate_unstable_arcana = class({})

modifier_innate_unstable_arcana.disallowed_abilities = {
	--["shadow_shaman_mass_serpent_ward"] = true,
	["ember_spirit_sleight_of_fist"] = true,
	["item_refresher"] = true,
	["rattletrap_overclocking"] = true,
	["item_ex_machina"] = true,
	["dazzle_good_juju"] = true,
}

function modifier_innate_unstable_arcana:IsHidden() return true end
function modifier_innate_unstable_arcana:IsDebuff() return false end
function modifier_innate_unstable_arcana:IsPurgable() return false end
function modifier_innate_unstable_arcana:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_unstable_arcana:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_unstable_arcana:OnRefresh(keys)
	if IsClient() then return end

	self.proc_chance = self:GetAbility():GetSpecialValueFor("refresh_chance") or 0
end

function modifier_innate_unstable_arcana:DeclareFunctions()
	if IsServer() then return { MODIFIER_EVENT_ON_ABILITY_FULLY_CAST } end
end

function modifier_innate_unstable_arcana:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() or (not keys.ability) or keys.ability:IsNull() then return end

	if self.disallowed_abilities[keys.ability:GetAbilityName()] then return end

	if keys.ability.IsRefreshableByUnstableArcana and not keys.ability:IsRefreshableByUnstableArcana() then return end

	if (keys.ability.charge_modifier or keys.ability:GetCooldown(keys.ability:GetLevel() - 1) > 0) and RollPercentage(self.proc_chance) then
		keys.unit:EmitSound("DOTA_Item.Refresher.Activate")

		local refresh_pfx = ParticleManager:CreateParticle("particles/custom/innates/unstable_arcana_proc.vpcf", PATTACH_POINT_FOLLOW, keys.unit)
		ParticleManager:SetParticleControlEnt(refresh_pfx, 0, keys.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:ReleaseParticleIndex(refresh_pfx)

		if keys.ability.IncrementCharges then
			keys.ability:IncrementCharges(1)
		end
		keys.ability:EndCooldown()
	end
end
