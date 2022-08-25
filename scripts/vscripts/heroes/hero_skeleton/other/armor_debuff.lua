LinkLuaModifier( "modifier_armor_debuff_debuff", "heroes/hero_skeleton/other/armor_debuff", LUA_MODIFIER_MOTION_NONE )	

if modifier_armor_debuff == nil then modifier_armor_debuff = class({}) end

function modifier_armor_debuff:IsHidden()		return true end
function modifier_armor_debuff:IsPurgable()		return false end
function modifier_armor_debuff:RemoveOnDeath()	return false end
function modifier_armor_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

-- Possible projectile changes
function modifier_armor_debuff:OnCreated()
end

function modifier_armor_debuff:OnDestroy()
end

-- Declare modifier events/properties
function modifier_armor_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

-- On attack landed, apply the debuff
function modifier_armor_debuff:OnAttackLanded( keys )
	if IsServer() then
		local owner = self:GetParent()

		if owner ~= keys.attacker then
			return end

		local target = keys.target

		local ability = self:GetAbility()
	--	Desolate(owner, target, ability, "modifier_armor_debuff_debuff", {duration = 3 })
		target:AddNewModifier(owner, ability, "modifier_armor_debuff_debuff", {duration = 3 })
	end
end


if modifier_armor_debuff_debuff == nil then modifier_armor_debuff_debuff = class({}) end
function modifier_armor_debuff_debuff:IsHidden() return true end
function modifier_armor_debuff_debuff:IsDebuff() return true end
function modifier_armor_debuff_debuff:IsPurgable() return true end


function modifier_armor_debuff_debuff:OnCreated()
end


function modifier_armor_debuff_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_armor_debuff_debuff:GetModifierPhysicalArmorBonus()
	return -5 
end

function Desolate(attacker, target, ability, modifier_name, duration)

	-- Only play the sound when first applied
	if not target:HasModifier(modifier_name) then
		target:EmitSound("Item_Desolator.Target")
	end

	-- Apply the modifier
	target:AddNewModifier(attacker, ability, modifier_name, {duration = duration * (1 - target:GetStatusResistance())})
end