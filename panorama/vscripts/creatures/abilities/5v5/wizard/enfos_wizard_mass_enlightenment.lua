enfos_wizard_mass_enlightenment = class({})

LinkLuaModifier("modifier_mass_enlightenment_buff", "creatures/abilities/5v5/wizard/enfos_wizard_mass_enlightenment", LUA_MODIFIER_MOTION_NONE)

function enfos_wizard_mass_enlightenment:OnSpellStart()
	local caster = self:GetCaster()
	local team = caster:GetTeam()
	local all_heroes = Enfos:GetAllMainHeroes()

	EmitAnnouncerSoundForTeam("wizard_enlightenment", team)

	local bonus_exp = self:GetSpecialValueFor("bonus_exp")

	for _, hero in pairs(all_heroes) do
		if hero:GetTeam() == team then
			local level_pfx = ParticleManager:CreateParticle("particles/5v5/upgrade_wizard.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
			ParticleManager:ReleaseParticleIndex(level_pfx)

			Timers:CreateTimer(0, function()
				local modifier = hero:AddNewModifier(hero, self, "modifier_mass_enlightenment_buff", { bonus_exp = bonus_exp })

				if modifier then
					modifier:IncrementStackCount()
				else
					return 1
				end
			end)
		end
	end

	EnfosWizard:CastSpellResult(caster, "mass_enlightenment")
end



modifier_mass_enlightenment_buff = class({})

function modifier_mass_enlightenment_buff:IsHidden() return false end
function modifier_mass_enlightenment_buff:IsDebuff() return false end
function modifier_mass_enlightenment_buff:IsPurgable() return false end
function modifier_mass_enlightenment_buff:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_mass_enlightenment_buff:RemoveOnDeath() return false end

function modifier_mass_enlightenment_buff:GetTexture() return "enfos_wizard_mass_enlightenment" end

function modifier_mass_enlightenment_buff:OnCreated(keys)
	self:SetHasCustomTransmitterData(true)

	if IsServer() then
		self.bonus_exp = keys.bonus_exp
		self:SendBuffRefreshToClients()
	end
end

function modifier_mass_enlightenment_buff:AddCustomTransmitterData()
	return { bonus_exp = self.bonus_exp }
end

function modifier_mass_enlightenment_buff:HandleCustomTransmitterData(data)
	self.bonus_exp = data.bonus_exp
end

function modifier_mass_enlightenment_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_mass_enlightenment_buff:OnTooltip()
	return self.bonus_exp * self:GetStackCount()
end
