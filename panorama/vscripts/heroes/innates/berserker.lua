innate_berserker = class({})

LinkLuaModifier("modifier_innate_berserker", "heroes/innates/berserker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_berserker_transition", "heroes/innates/berserker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_innate_berserker_active", "heroes/innates/berserker", LUA_MODIFIER_MOTION_NONE)

function innate_berserker:GetIntrinsicModifierName()
	return "modifier_innate_berserker"
end



modifier_innate_berserker = class({})

function modifier_innate_berserker:IsHidden() return true end
function modifier_innate_berserker:IsDebuff() return false end
function modifier_innate_berserker:IsPurgable() return false end
function modifier_innate_berserker:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_berserker:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_berserker:OnRefresh(keys)
	if IsClient() then return end

	local ability = self:GetAbility()

	self.hp_pct_activation_threshold = 0.01 * ability:GetSpecialValueFor("hp_pct_activation_threshold") or 0
	self.damage_immunity_duration = ability:GetSpecialValueFor("damage_immunity_duration") or 0
end

function modifier_innate_berserker:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_AVOID_DAMAGE } end
end

-- This function is used to check if a damage instance would make the hero's health go under threshold
-- BEFORE it is applied.
function modifier_innate_berserker:GetModifierAvoidDamage(keys)
	local parent = self:GetParent()

	if parent:IsIllusion() then return 0 end

	-- Stop if the ability was already activated this round
	if parent:HasModifier("modifier_innate_berserker_transition") then return 0 end
	if parent:HasModifier("modifier_innate_berserker_active") then return 0 end
	if parent:HasModifier("modifier_abaddon_borrowed_time") then return 0 end
	if parent:HasModifier("modifier_oracle_false_promise") then return 0 end

	-- Aeon Disk have should proc first
	local aeon_disk_modifier = parent:FindModifierByName("modifier_item_aeon_disk_lua")
	if aeon_disk_modifier and aeon_disk_modifier:CanProcPassive(keys.damage) then return 0 end

	-- Activate ability if health will fall below the threshold
	local activation_threshold = parent:GetMaxHealth() * self.hp_pct_activation_threshold
	if (parent:GetHealth() - keys.damage) >= activation_threshold then return 0 end

	parent:Purge(false, true, false, true, false)
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_innate_berserker_transition", {duration = self.damage_immunity_duration})
	parent:SetHealth(activation_threshold)
	return 1
end



modifier_innate_berserker_transition = class({})

function modifier_innate_berserker_transition:IsHidden() return true end
function modifier_innate_berserker_transition:IsDebuff() return false end
function modifier_innate_berserker_transition:IsPurgable() return false end
function modifier_innate_berserker_transition:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_berserker_transition:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf"
end

-- Make em red
function modifier_innate_berserker_transition:OnCreated()
	if IsClient() then return end

	local parent = self:GetParent()

	parent:EmitSound("DOTA_Item.Satanic.Activate")
	parent:EmitSound("Hero_Ursa.Enrage")

	parent:SetRenderColor(255,0,0)

	self.berserker_prepare_pfx = ParticleManager:CreateParticle("particles/custom/innates/berserker_prepare.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(self.berserker_prepare_pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
end

function modifier_innate_berserker_transition:OnDestroy()
	if IsClient() or self.over then return end

	local parent = self:GetParent()
	if (not parent) then return end

	parent:SetRenderColor(255,255,255)
	parent:AddNewModifier(parent, self:GetAbility(), "modifier_innate_berserker_active", {})

	parent:EmitSound("Hero_Sven.GodsStrength")
	parent:EmitSound("DOTA_Item.MaskOfMadness.Activate")

	local roar_pfx = ParticleManager:CreateParticle("particles/custom/innates/berserker_prepare_cry.vpcf", PATTACH_ABSORIGIN, self:GetParent())
	ParticleManager:SetParticleControl(roar_pfx, 0, parent:GetAbsOrigin() + Vector(0,0,200))
	ParticleManager:ReleaseParticleIndex(roar_pfx)

	if self.berserker_prepare_pfx then
		ParticleManager:DestroyParticle(self.berserker_prepare_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.berserker_prepare_pfx)
	end
end

function modifier_innate_berserker_transition:DeclareFunctions()
	if IsServer() then return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	} end
end

function modifier_innate_berserker_transition:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_innate_berserker_transition:GetAbsoluteNoDamageMagical() return 1 end
function modifier_innate_berserker_transition:GetAbsoluteNoDamagePure() return 1 end

function modifier_innate_berserker_transition:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_berserker_transition:OnPvpEndedForDuelists(keys)
	if IsClient() then return end
	self.over = true
	self:Destroy()
end



modifier_innate_berserker_active = class({})

function modifier_innate_berserker_active:IsHidden() return false end
function modifier_innate_berserker_active:IsDebuff() return false end
function modifier_innate_berserker_active:IsPurgable() return false end
function modifier_innate_berserker_active:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_berserker_active:GetEffectName()
	return "particles/custom/innates/berserker_buff.vpcf"
end

function modifier_innate_berserker_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_innate_berserker_active:GetStatusEffectName()
	return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_innate_berserker_active:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end

function modifier_innate_berserker_active:HeroEffectPriority()
	return 10
end

function modifier_innate_berserker_active:OnCreated(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.berserk_outgoing_damage = ability:GetSpecialValueFor("berserk_damage_increase") or 0
	self.lifesteal = ability:GetSpecialValueFor("berserk_lifesteal") or 0
end

function modifier_innate_berserker_active:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
			MODIFIER_PROPERTY_TOOLTIP
		}
	else
		return {
			MODIFIER_PROPERTY_TOOLTIP
		}
	end
end

function modifier_innate_berserker_active:OnTooltip()
	return self.lifesteal or 0
end

function modifier_innate_berserker_active:GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsClient() then return end

	if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.target:IsBuilding()) and keys.original_damage > 0 then 
		if keys.damage_flags and 
		(bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or 
		bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION) then 
			return 
		end

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/custom/innates/berserker_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

		local actual_damage = keys.original_damage
		if keys.inflictor then
			actual_damage = keys.original_damage * (1 + (keys.attacker:GetSpellAmplification(false) or 0))
		end

		if keys.damage_type then
			if keys.damage_type == DAMAGE_TYPE_MAGICAL then
				actual_damage = actual_damage * (1 - keys.target:GetMagicalArmorValue())
			elseif keys.damage_type == DAMAGE_TYPE_PHYSICAL then
				local phys_armor = keys.target:GetPhysicalArmorValue(false)
				actual_damage = actual_damage * (1 - (0.06 * phys_armor) / (1 + 0.06 * math.abs(phys_armor)))
			end
		end
		keys.attacker:Heal(actual_damage * self.lifesteal * 0.01, self:GetAbility())
	end

	return self.berserk_outgoing_damage or 0
end

function modifier_innate_berserker_active:OnRoundEndForTeam(keys)
	self:OnPvpEndedForDuelists(keys)
end

function modifier_innate_berserker_active:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	self:Destroy()
end
