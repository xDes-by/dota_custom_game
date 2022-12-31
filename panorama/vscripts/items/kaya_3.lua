item_kaya_3 = class({})

function item_kaya_3:GetIntrinsicModifierName()
	return "modifier_item_starforce"
end

function item_kaya_3:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	target:EmitSound("Starforce.Cast")
	target:AddNewModifier(caster, self, "modifier_item_starforce_shield", {duration = self:GetSpecialValueFor("barrier_duration")})
end

LinkLuaModifier("modifier_item_starforce", "items/kaya_3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_starforce_shield", "items/kaya_3", LUA_MODIFIER_MOTION_NONE)

modifier_item_starforce = class({})

function modifier_item_starforce:IsHidden() return true end
function modifier_item_starforce:IsDebuff() return false end
function modifier_item_starforce:IsPurgable() return false end
function modifier_item_starforce:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_starforce:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
		}
	else
		return {
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
			MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
		}
	end
end

function modifier_item_starforce:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_starforce:OnRefresh()
	if (not self.ability) or self.ability:IsNull() then return end

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_intellect")
	self.mana_regen_multiplier = self.ability:GetSpecialValueFor("mana_regen_multiplier")
	self.spell_lifesteal_amp = self.ability:GetSpecialValueFor("spell_lifesteal_amp")
	self.bonus_spell_resist = self.ability:GetSpecialValueFor("bonus_spell_resist")
	self.creep_spell_amp = self.ability:GetSpecialValueFor("creep_spell_amp")
	self.duel_spell_amp = self.ability:GetSpecialValueFor("duel_spell_amp")
	self.creep_lifesteal = 0.01 * self.ability:GetSpecialValueFor("creep_lifesteal")
	self.hero_lifesteal = 0.01 * self.ability:GetSpecialValueFor("hero_lifesteal")
	
	if IsServer() and self.parent and (not self.parent:IsNull()) and self.parent.CalculateStatBonus then self.parent:CalculateStatBonus(false) end
end

function modifier_item_starforce:GetModifierBonusStats_Intellect()
	return self.bonus_int or 0
end

function modifier_item_starforce:GetModifierMPRegenAmplify_Percentage()
	return self.mana_regen_multiplier or 0
end

function modifier_item_starforce:GetModifierSpellLifestealRegenAmplify_Percentage()
	return self.spell_lifesteal_amp or 0
end

function modifier_item_starforce:GetModifierMagicalResistanceBonus()
	return self.bonus_spell_resist or 0
end

function modifier_item_starforce:GetModifierSpellAmplify_PercentageUnique()
	if (not self.parent) or (self.parent:IsNull()) then return end
	if not self.parent.GetIntellect then return 0 end -- Bear exlusion
	
	if self.parent:HasModifier("modifier_hero_dueling") then
		return self.duel_spell_amp * self.parent:GetIntellect()
	else
		return self.creep_spell_amp * self.parent:GetIntellect()
	end
end

function modifier_item_starforce:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.attacker and keys.target and keys.inflictor and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.inflictor:IsNull() or keys.target:IsBuilding()) and keys.original_damage > 0 then 
		if keys.damage_flags and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		if keys.damage_flags and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL  then return end

		local lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
		ParticleManager:ReleaseParticleIndex(lifesteal_pfx)

		local actual_damage = keys.original_damage * (1 + (keys.attacker:GetSpellAmplification(false) or 0))

		if keys.damage_type then
			if keys.damage_type == DAMAGE_TYPE_MAGICAL then
				actual_damage = actual_damage * (1 - keys.target:GetMagicalArmorValue())
			elseif keys.damage_type == DAMAGE_TYPE_PHYSICAL then
				local phys_armor = keys.target:GetPhysicalArmorValue(false)
				actual_damage = actual_damage * (1 - (0.06 * phys_armor) / (1 + 0.06 * math.abs(phys_armor)))
			end
		end

		keys.attacker:Heal(actual_damage * ((keys.target:IsHero() and self.hero_lifesteal) or self.creep_lifesteal), keys.inflictor)
	end
end



modifier_item_starforce_shield = class({})

function modifier_item_starforce_shield:IsHidden() return false end
function modifier_item_starforce_shield:IsDebuff() return false end
function modifier_item_starforce_shield:IsPurgable() return false end
function modifier_item_starforce_shield:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_starforce_shield:OnCreated(keys)
	if IsServer() then
		self.parent = self:GetParent()

		self.shield_health = self:GetAbility():GetSpecialValueFor("barrier_block")

		self.shield_pfx = ParticleManager:CreateParticle("particles/items/starforce_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(self.shield_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
		ParticleManager:SetParticleControlEnt(self.shield_pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)

		self:AddParticle(self.shield_pfx, false, false, 255, true, false)
	end
end

function modifier_item_starforce_shield:OnDestroy()
	if self.shield_pfx then
		ParticleManager:DestroyParticle(self.shield_pfx, false)
		ParticleManager:ReleaseParticleIndex(self.shield_pfx)
	end
end

function modifier_item_starforce_shield:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE 
		}
	end
end

function modifier_item_starforce_shield:GetModifierTotal_ConstantBlock()
	return self.shield_health
end

function modifier_item_starforce_shield:GetModifierIncomingDamage_Percentage(keys)
	if self.shield_health <= keys.original_damage then
		keys.target:GiveMana(self.shield_health)
		self:Destroy()
	else
		keys.target:GiveMana(keys.original_damage)
		self.shield_health = self.shield_health - keys.original_damage
	end
end
