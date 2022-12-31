LinkLuaModifier("modifier_creature_web", "creatures/abilities/regular/creature_web", LUA_MODIFIER_MOTION_NONE)

creature_web = class({})

function creature_web:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_team = caster:GetTeam()
		local target_loc = self:GetCursorPosition()
		local duration = self:GetSpecialValueFor("duration")
		local radius = self:GetSpecialValueFor("radius")
		local slow = self:GetSpecialValueFor("slow")

		caster:EmitSound("CreatureWeb.Cast")

		local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_spin_web_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(cast_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(cast_pfx, 1, target_loc)
		ParticleManager:SetParticleControl(cast_pfx, 2, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(cast_pfx)

		local web_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_web.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(web_pfx, 0, target_loc)

		Timers:CreateTimer(0, function()
			local enemies = FindUnitsInRadius(caster_team, target_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, enemy in pairs(enemies) do
				if (not enemy:IsMagicImmune()) then
					enemy:AddNewModifier(caster, self, "modifier_creature_web", {slow = slow, duration = 0.5})
				end
			end

			duration = duration - 0.1
			if duration <= 0 then
				ParticleManager:DestroyParticle(web_pfx, false)
				ParticleManager:ReleaseParticleIndex(web_pfx)
			else
				return 0.1
			end
		end)
	end
end



modifier_creature_web = class({})

function modifier_creature_web:IsHidden() return true end
function modifier_creature_web:IsDebuff() return true end
function modifier_creature_web:IsPurgable() return true end

function modifier_creature_web:GetEffectName()
	return "particles/creature/web_debuff.vpcf"
end

function modifier_creature_web:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_creature_web:OnCreated(keys)
	if IsServer() then
		self.slow = keys.slow
	end
end

function modifier_creature_web:DeclareFunctions()
	if IsServer() then
		return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
	end
end

function modifier_creature_web:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end
