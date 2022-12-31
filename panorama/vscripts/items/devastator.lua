item_devastator = class({})

LinkLuaModifier("modifier_item_devastator", "items/devastator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_devastator_debuff", "items/devastator", LUA_MODIFIER_MOTION_NONE)

function item_devastator:GetAOERadius()
	return self:GetSpecialValueFor("active_radius")
end

function item_devastator:OnSpellStart()
	if IsClient() then return end

	self:GetCaster():EmitSound("Devastator.Cast")

	GridNav:DestroyTreesAroundPoint(self:GetCursorPosition(), self:GetSpecialValueFor("active_radius"), true)
end

function item_devastator:GetIntrinsicModifierName()
	return "modifier_item_devastator"
end

modifier_item_devastator = class({})

function modifier_item_devastator:IsHidden() return true end
function modifier_item_devastator:IsDebuff() return false end
function modifier_item_devastator:IsPurgable() return false end
function modifier_item_devastator:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_devastator:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_devastator:OnRefresh(keys)
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if (not parent) or (not ability) or parent:IsNull() or ability:IsNull() then return end

	self.bonus_dmg = ability:GetSpecialValueFor("bonus_dmg") or 0
	self.health_regen = ability:GetSpecialValueFor("health_regen") or 0
	self.mana_regen = ability:GetSpecialValueFor("mana_regen") or 0

	if IsClient() then return end

	self.cleave_pct = 0.01 * ability:GetSpecialValueFor("cleave_pct") or 0
	self.start_radius = ability:GetSpecialValueFor("start_radius") or 0
	self.end_radius = ability:GetSpecialValueFor("end_radius") or 0
	self.distance = ability:GetSpecialValueFor("distance") or 0
	self.duration = ability:GetSpecialValueFor("duration") or 0
end

function modifier_item_devastator:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
			MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
		}
	else
		return {
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
			MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
		}
	end
end

function modifier_item_devastator:GetModifierPreAttack_BonusDamage() return self.bonus_dmg end
function modifier_item_devastator:GetModifierConstantHealthRegen() return self.health_regen end
function modifier_item_devastator:GetModifierConstantManaRegen() return self.mana_regen end

function modifier_item_devastator:GetModifierProcAttack_Feedback(keys)
	if keys.attacker and keys.target and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.attacker:GetTeam() == keys.target:GetTeam()) then

		keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_devastator_debuff", {duration = self.duration})

		if keys.target:IsBuilding() or keys.target:IsOther() or keys.attacker:IsRangedAttacker() then return end

		local fury_swipes_damage = 0
	
		if keys.attacker:HasAbility("ursa_fury_swipes") and keys.target:HasModifier("modifier_ursa_fury_swipes_damage_increase") then
			local ursa_swipes = keys.attacker:FindAbilityByName("ursa_fury_swipes")
			if ursa_swipes and not ursa_swipes:IsNull() then
				local stacks = keys.target:GetModifierStackCount("modifier_ursa_fury_swipes_damage_increase", keys.attacker)
				fury_swipes_damage = stacks * ursa_swipes:GetSpecialValueFor("damage_per_stack")
			end
		end
		
		local cleave_damage = (keys.damage + fury_swipes_damage) * self.cleave_pct

		DoCleaveAttack(keys.attacker, keys.target, self:GetAbility(), cleave_damage, self.start_radius, self.end_radius, self.distance, "particles/items/devastator_passive_cleave.vpcf")
	end
end

function modifier_item_devastator:GetModifierTotalDamageOutgoing_Percentage(keys)
	if keys.attacker and keys.target and keys.inflictor and keys.inflictor == self:GetAbility() and not (keys.attacker:IsNull() or keys.target:IsNull() or keys.inflictor:IsNull()) then
		keys.target:AddNewModifier(keys.attacker, keys.inflictor, "modifier_item_devastator_debuff", {duration = self.duration})
	end
end



modifier_item_devastator_debuff = class({})

function modifier_item_devastator_debuff:IsHidden() return false end
function modifier_item_devastator_debuff:IsDebuff() return true end
function modifier_item_devastator_debuff:IsPurgable() return true end

function modifier_item_devastator_debuff:GetTexture() return "item_devastator" end

function modifier_item_devastator_debuff:OnCreated(keys)
	local ability = self:GetAbility()

	if ability and (not ability:IsNull()) then self.armor_reduction = ability:GetSpecialValueFor("armor_reduction") end
end

function modifier_item_devastator_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_item_devastator_debuff:GetModifierPhysicalArmorBonus()
	return self.armor_reduction or 0
end
