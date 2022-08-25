modifier_blade_mail	= class({})

function modifier_blade_mail:IsHidden() return true end
function modifier_blade_mail:IsPurgable() return false end
function modifier_blade_mail:IsPurgeException() return false end

function modifier_blade_mail:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end

function modifier_blade_mail:OnCreated()
	-- if not IsServer() then return end

	
	-- self.return_damage_pct = 15
end

function modifier_blade_mail:GetModifierHealthRegenPercentage(params)
return 2
	-- if not IsServer() then return end

	-- if params.unit == self:GetParent() and not params.attacker:IsBuilding() and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and params.damage_type == 1 then
		-- local damage = (params.damage / 100 * self.return_damage_pct)

		-- ApplyDamage({
			-- victim = params.attacker,
			-- attacker = params.unit,
			-- damage = damage,
			-- damage_type = DAMAGE_TYPE_PHYSICAL,
			-- damage_flags	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		-- })
	-- end
end
