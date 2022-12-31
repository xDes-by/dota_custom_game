item_guardian_helmet = class({})

LinkLuaModifier("modifier_item_guardian_helmet", "items/guardian_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_helmet_aura", "items/guardian_helmet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_guardian_helmet_buff", "items/guardian_helmet", LUA_MODIFIER_MOTION_NONE)

function item_guardian_helmet:GetIntrinsicModifierName()
	return "modifier_item_guardian_helmet"
end

function item_guardian_helmet:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("replenish_radius")
	local health_restore = self:GetSpecialValueFor("replenish_health_pct") * 0.01
	local mana_restore = self:GetSpecialValueFor("replenish_mana_pct") * 0.01
	local duration = self:GetSpecialValueFor("buff_duration")
	local effect_prevent_duration = math.max(0.01, self.BaseClass.GetCooldown(self, 0) - 1)

	if IsClient() then return end

	-- Active effects
	caster:Purge(false, true, false, true, true)

	caster:EmitSound("Item.GuardianGreaves.Activate")

	local guardian_pfx = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(guardian_pfx)

	local allies = FindUnitsInRadius(caster:GetTeam(), 
		caster:GetAbsOrigin(), 
		nil, 
		radius, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
		FIND_ANY_ORDER, 
		false
	)

	for _, ally in pairs(allies) do

		-- Effects
		ally:EmitSound("Item.GuardianGreaves.Target")

		local particle_name = (ally:IsHero() and "particles/items3_fx/warmage_recipient.vpcf") or "particles/items3_fx/warmage_mana_nonhero.vpcf"
		local target_pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, ally)
		ParticleManager:ReleaseParticleIndex(target_pfx)

		-- Healing and mana replenishment
		local mana = ally:GetMaxMana() * mana_restore
		local health = ally:GetMaxHealth() * health_restore

		ally:GiveMana(mana)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, ally, mana, nil)

		if not ally:HasModifier("modifier_item_mekansm_noheal") then
			ally:Heal(health, ally)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, ally, health, nil)

			ally:AddNewModifier(caster, self, "modifier_item_mekansm_noheal", {duration = effect_prevent_duration})
		end

		-- Extra status resistance
		ally:AddNewModifier(caster, self, "modifier_item_guardian_helmet_buff", {duration = duration})
	end
end



-- Item Stats
modifier_item_guardian_helmet = class({})

function modifier_item_guardian_helmet:IsHidden() return true end
function modifier_item_guardian_helmet:IsDebuff() return false end
function modifier_item_guardian_helmet:IsPurgable() return false end
function modifier_item_guardian_helmet:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_guardian_helmet:IsAura() return true end
function modifier_item_guardian_helmet:GetModifierAura() return "modifier_item_guardian_helmet_aura" end
function modifier_item_guardian_helmet:GetAuraRadius() return self.aura_radius end
function modifier_item_guardian_helmet:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_guardian_helmet:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_guardian_helmet:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_item_guardian_helmet:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_guardian_helmet:OnRefresh(keys)
	local ability = self:GetAbility()

	if (not ability) or ability:IsNull() then return end

	self.bonus_ms = ability:GetSpecialValueFor("bonus_movement") or 0
	self.bonus_armor = ability:GetSpecialValueFor("bonus_armor") or 0
	self.bonus_health = ability:GetSpecialValueFor("bonus_health") or 0
	self.bonus_mana = ability:GetSpecialValueFor("bonus_mana") or 0

	self.aura_radius = ability:GetSpecialValueFor("aura_radius") or 0
	self.aura_threshold = ability:GetSpecialValueFor("aura_bonus_threshold") or 0
end

function modifier_item_guardian_helmet:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_guardian_helmet:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_ms
end

function modifier_item_guardian_helmet:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_guardian_helmet:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_guardian_helmet:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_guardian_helmet:GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then return end

	if (not keys.target) or keys.target:IsNull() or (not keys.target:IsAlive()) then return end

	local ability = self:GetAbility()

	if (not ability) or ability:IsNull() then return end

	if not keys.target:IsIllusion() and keys.target:GetHealthPercent() <= self.aura_threshold and ability:IsCooldownReady() and keys.target:IsAlive() then
		ability:UseResources(true, false, true)
		ability:OnSpellStart()
	end
end



-- Aura Modifier
modifier_item_guardian_helmet_aura = class({})

function modifier_item_guardian_helmet_aura:IsHidden() return false end
function modifier_item_guardian_helmet_aura:IsDebuff() return false end
function modifier_item_guardian_helmet_aura:IsPurgable() return false end
function modifier_item_guardian_helmet_aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_guardian_helmet_aura:OnCreated()
	local ability = self:GetAbility()

	if (not ability) or ability:IsNull() then self:Destroy() return end

	self.health_threshold = ability:GetSpecialValueFor("aura_bonus_threshold") or 0

	self.health_regen = ability:GetSpecialValueFor("aura_health_regen") or 0
	self.health_regen_bonus = ability:GetSpecialValueFor("aura_health_regen_bonus") or 0
	self.armor = ability:GetSpecialValueFor("aura_armor") or 0
	self.armor_bonus = ability:GetSpecialValueFor("aura_armor_bonus") or 0
	self.status_resistance = ability:GetSpecialValueFor("aura_status_resistance") or 0
	self.status_resistance_bonus = ability:GetSpecialValueFor("aura_status_resistance_bonus") or 0
end

function modifier_item_guardian_helmet_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_item_guardian_helmet_aura:GetModifierConstantHealthRegen()
	local parent = self:GetParent()

	if parent and (not parent:IsNull()) and parent:IsHero() and parent:GetHealthPercent() <= self.health_threshold then
		return self.health_regen + self.health_regen_bonus
	else
		return self.health_regen
	end
end

function modifier_item_guardian_helmet_aura:GetModifierPhysicalArmorBonus()
	local parent = self:GetParent()

	if parent and (not parent:IsNull()) and parent:IsHero() and parent:GetHealthPercent() <= self.health_threshold then
		return self.armor + self.armor_bonus
	else
		return self.armor
	end
end

function modifier_item_guardian_helmet_aura:GetModifierStatusResistanceStacking()
	local parent = self:GetParent()

	if parent and (not parent:IsNull()) and parent:IsHero() and parent:GetHealthPercent() <= self.health_threshold then
		return self.status_resistance + self.status_resistance_bonus
	else
		return self.status_resistance
	end
end



-- Active Buff
modifier_item_guardian_helmet_buff = class({})

function modifier_item_guardian_helmet_buff:IsHidden() return false end
function modifier_item_guardian_helmet_buff:IsDebuff() return false end
function modifier_item_guardian_helmet_buff:IsPurgable() return false end
function modifier_item_guardian_helmet_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_guardian_helmet_buff:OnCreated()
	local ability = self:GetAbility()

	if (not ability) or ability:IsNull() then self:Destroy() return end

	self.status_resistance = ability:GetSpecialValueFor("status_resistance_buff") or 0
end

function modifier_item_guardian_helmet_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_item_guardian_helmet_buff:GetModifierStatusResistanceStacking()
	return self.status_resistance
end
