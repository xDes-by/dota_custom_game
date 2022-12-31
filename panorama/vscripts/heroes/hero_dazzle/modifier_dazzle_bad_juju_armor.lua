---@class modifier_dazzle_bad_juju_armor_lua:CDOTA_Modifier_Lua
modifier_dazzle_bad_juju_armor_lua = class({})

function modifier_dazzle_bad_juju_armor_lua:IsHidden() return false end
function modifier_dazzle_bad_juju_armor_lua:IsPurgable() return false end
function modifier_dazzle_bad_juju_armor_lua:IsDebuff() return self.is_on_enemy end

function modifier_dazzle_bad_juju_armor_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_dazzle_bad_juju_armor_lua:GetModifierPhysicalArmorBonus()
	return self.armor * self:GetStackCount() * (self.is_on_enemy and -1 or 1)
end

function modifier_dazzle_bad_juju_armor_lua:OnCreated()
	local parent = self:GetParent()

	self.is_on_enemy = parent:GetTeamNumber() ~= self:GetCaster():GetTeamNumber()
	self.armor = self:GetAbility():GetSpecialValueFor("armor_reduction")

	if IsClient() then 
		local fx_name = "particles/units/heroes/hero_dazzle/dazzle_armor_friend.vpcf"
		if self.is_on_enemy then
			fx_name = "particles/units/heroes/hero_dazzle/dazzle_armor_enemy.vpcf"
		end

		local pfx = ParticleManager:CreateParticle(fx_name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(pfx, 1, parent, PATTACH_CUSTOMORIGIN_FOLLOW, "", Vector(0,0,0), false)
		self:AddParticle(pfx, false, false, 0, false, true)
		
		return 
	end

	self:OnRefresh()
end

function modifier_dazzle_bad_juju_armor_lua:OnRefresh()
	if IsClient() then return end

	self:IncrementStackCount()

	Timers:CreateTimer(self:GetDuration(), function() 
		if not self:IsNull() then 
			self:DecrementStackCount()
		end
	end)
end
