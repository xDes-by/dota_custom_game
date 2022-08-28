LinkLuaModifier("modifier_boss_5_passive2", "abilities/bosses/line/boss_5/boss_5_passive2", LUA_MODIFIER_MOTION_NONE)

boss_5_passive2 = class({})

function boss_5_passive2:GetIntrinsicModifierName()
	return "modifier_boss_5_passive2"
end

----------------------------------------------------------

modifier_boss_5_passive2 = class({})

function modifier_boss_5_passive2:IsHidden()
	return false
end

function modifier_boss_5_passive2:RemoveOnDeath()
	return true
end

function modifier_boss_5_passive2:OnCreated()	
if IsServer() then
	self:StartIntervalThink(3)
	end
end

function modifier_boss_5_passive2:OnIntervalThink()
	local hEnemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if hEnemies ~= nil then
		for _,unit in pairs(hEnemies) do
			local damage = {
				victim = unit,
				attacker = self:GetCaster(),
				damage = unit:GetMaxHealth()*0.1,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			}
			ApplyDamage( damage )
			local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(lightningBolt, 0, Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y , self:GetCaster():GetAbsOrigin().z))   
			ParticleManager:SetParticleControl(lightningBolt, 1, Vector(unit:GetAbsOrigin().x, unit:GetAbsOrigin().y, unit:GetAbsOrigin().z))
			self:GetCaster():EmitSound("Hero_Zuus.ArcLightning.Cast")
		end	
	end
end