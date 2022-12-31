modifier_shadow_demon_disruption_creep = class({})

function modifier_shadow_demon_disruption_creep:IsPurgable() return false end
function modifier_shadow_demon_disruption_creep:IsDebuff() return true end

function modifier_shadow_demon_disruption_creep:OnRemoved()
	if not IsServer() then return end
	
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not ability or not caster or not parent or not parent:IsAlive() then return end

	for i = 1, 2 do
		local pos = parent:GetAbsOrigin() + RandomVector(100)
		local unit = CreateUnitByName(parent:GetUnitName(), pos, true, caster, caster, caster:GetTeam())
		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
		
		unit:SetBaseMaxHealth(parent:GetMaxHealth())
		unit:SetMaxHealth(parent:GetMaxHealth())
		unit:SetHealth(parent:GetHealth())
		unit:SetBaseDamageMin(parent:GetBaseDamageMin())
		unit:SetBaseDamageMax(parent:GetBaseDamageMax())
		unit:SetBaseAttackTime(parent:GetBaseAttackTime())

		unit:AddNewModifier(caster, ability, "modifier_illusion", {
			duration = ability:GetSpecialValueFor("illusion_duration"),
			outgoing_damage = ability:GetSpecialValueFor("illusion_outgoing_damage"),
			incoming_damage = ability:GetSpecialValueFor("illusion_incoming_damage")
		})

		unit:MakeIllusion()

		unit:SetRenderColor(50, 50, 200)
		local pFX = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/disruption_illusion_creep.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:ReleaseParticleIndex(pFX)
	end
end
