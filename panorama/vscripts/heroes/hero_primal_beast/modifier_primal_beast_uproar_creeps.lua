---@class modifier_primal_beast_uproar_creeps:CDOTA_Modifier_Lua
modifier_primal_beast_uproar_creeps = class({})

function modifier_primal_beast_uproar_creeps:IsHidden() return true end
function modifier_primal_beast_uproar_creeps:IsPurgable() return false end
function modifier_primal_beast_uproar_creeps:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_primal_beast_uproar_creeps:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_primal_beast_uproar_creeps:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	if not self.ability then
		self:Destroy()
		return
	end

	self.acc = 0
end

function modifier_primal_beast_uproar_creeps:GetModifierTotal_ConstantBlock(event)
	if not IsValidEntity(self.ability) then
		self:Destroy()
		return
	end

	if not self.ability:IsTrained() then return end

	local attacker = event.attacker

	if attacker:GetTeam() == self.parent:GetTeam() then return end
	if attacker:IsControllableByAnyPlayer() then return end

	local min_damage = self.ability:GetSpecialValueFor("damage_min")
	local max_damage = self.ability:GetSpecialValueFor("damage_max")
	
	if event.damage >= min_damage and event.damage <= max_damage then
		self.acc = self.acc + event.damage

		local damage_limit = self.ability:GetSpecialValueFor("damage_limit")

		if self.acc >= damage_limit then
			self.acc = 0

			local uproar_modifier = self.parent:FindModifierByName("modifier_primal_beast_uproar")
			if uproar_modifier then
				local stack_duration  = self.ability:GetSpecialValueFor("stack_duration")
				
				uproar_modifier:ForceRefresh()
				uproar_modifier:SetDuration(stack_duration, true)
			end
		end
	end
end
