medusa_mana_shield_lua = class({})
LinkLuaModifier("medusa_mana_shield_lua_passive", "heroes/hero_medusa/medusa_mana_shield_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_medusa_mana_shield_lua", "heroes/hero_medusa/medusa_mana_shield_lua", LUA_MODIFIER_MOTION_NONE)

function medusa_mana_shield_lua:GetIntrinsicModifierName()
	return "medusa_mana_shield_lua_passive"
end

function medusa_mana_shield_lua:ProcsMagicStick() return false end
function medusa_mana_shield_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end
function medusa_mana_shield_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function medusa_mana_shield_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.On")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_medusa_mana_shield_lua", {})
	else
		self:GetCaster():EmitSound("Hero_Medusa.ManaShield.Off")
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_medusa_mana_shield_lua", self:GetCaster())
	end
	
end

--
medusa_mana_shield_lua_passive = class({})

function medusa_mana_shield_lua_passive:IsDebuff() return false end
function medusa_mana_shield_lua_passive:IsHidden() return true end
function medusa_mana_shield_lua_passive:IsPurgable() return false end
function medusa_mana_shield_lua_passive:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function medusa_mana_shield_lua_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS
	}
end

function medusa_mana_shield_lua_passive:OnCreated(keys)
	self:OnRefresh(keys)
end

function medusa_mana_shield_lua_passive:OnRefresh(keys)
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
end

function medusa_mana_shield_lua_passive:GetModifierManaBonus()
	return self.bonus_mana
end

--
modifier_medusa_mana_shield_lua = class({})
function modifier_medusa_mana_shield_lua:GetEffectName()
	return ParticleManager:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", self:GetCaster())
end

function modifier_medusa_mana_shield_lua:IsPurgable() 		return false end
function modifier_medusa_mana_shield_lua:RemoveOnDeath()	return false end

function modifier_medusa_mana_shield_lua:OnCreated()
	self.ability = self:GetAbility()
	self.impact_particle = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf", self:GetCaster())
end

function modifier_medusa_mana_shield_lua:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_medusa_mana_shield_lua:GetModifierIncomingDamage_Percentage(keys)
	if not IsServer() then return end
	if not self.ability or self.ability:IsNull() or not self:GetParent() or self:GetParent():IsNull() then
		self:Destroy()
		return
	end

	local absorption_pct = self.ability:GetSpecialValueFor("absorption_pct")
	local damage_per_mana = self.ability:GetSpecialValueFor("damage_per_mana") * (1 + self:GetParent():GetSpellAmplification(false)) -- talent already calculated
	
	-- Calculate how much mana will be used in attempts to block some damage
	local mana_to_block	= keys.original_damage * absorption_pct * 0.01 / damage_per_mana
	local mana_spent = math.min(mana_to_block, self:GetParent():GetMana())
	self:GetParent():ReduceMana(mana_spent)

	--print("blocking "..keys.original_damage.." damage with "..mana_spent.." mana (ratio: "..damage_per_mana..")")

	self:GetParent():EmitSound("Hero_Medusa.ManaShield.Proc")
	local shield_particle = ParticleManager:CreateParticle(self.impact_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(shield_particle)
	
	return absorption_pct * (mana_spent / mana_to_block) * (-1)
end
