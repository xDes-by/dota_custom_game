modifier_abaddon_borrowed_time_lua = class({})

function modifier_abaddon_borrowed_time_lua:IsHidden() 		return true end
function modifier_abaddon_borrowed_time_lua:IsPurgable() 	return false end

if not IsServer() then return end

function modifier_abaddon_borrowed_time_lua:OnCreated( ... )
	self:Init()
end

function modifier_abaddon_borrowed_time_lua:OnRefresh()
	self:Init()
end

function modifier_abaddon_borrowed_time_lua:Init( ... )
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	self.ability = ability
	
	self.const_damage_threshold = ability:GetSpecialValueFor("hp_threshold")
	self.pct_damage_threshold 	= ability:GetSpecialValueFor("hp_threshold_pct")
	self.duration 				= ability:GetSpecialValueFor("duration")
	self.duration_scepter 		= ability:GetSpecialValueFor("duration_scepter")

	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end
end

function modifier_abaddon_borrowed_time_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, -- OnTakeDamage
	}
end

function modifier_abaddon_borrowed_time_lua:GetModifierIncomingDamage_Percentage(params)
	if not self.parent or self.parent:IsNull() or not self.parent:IsAlive() then return end
	if self.parent:PassivesDisabled() then return end

	if not self.ability:IsCooldownReady() then return end

	if self.parent:GetHealth() < self.const_damage_threshold or self.parent:GetHealthPercent() < self.pct_damage_threshold then
		local duration
		if self.parent:HasScepter() then
			duration = self.duration_scepter
		else
			duration = self.duration
		end

		self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_borrowed_time_absorbtion", {duration=duration})
		self.ability:UseResources(false, false, true)
	end
end