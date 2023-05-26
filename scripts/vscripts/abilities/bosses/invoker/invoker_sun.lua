LinkLuaModifier("modifier_invoker_sun", "abilities/bosses/invoker/invoker_sun", LUA_MODIFIER_MOTION_VERTICAL)

invoker_sun = class({})

function invoker_sun:OnSpellStart()       
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_sun", {duration = duration})
end
------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_invoker_sun = class({})

function modifier_invoker_sun:IsHidden()
	return true
end

function modifier_invoker_sun:IsPurgable()
	return false
end

function modifier_invoker_sun:OnCreated( kv )
	self:StartIntervalThink(0.7)
end

function modifier_invoker_sun:OnIntervalThink()
print(self:GetCaster():GetUnitName())
if not IsServer() then return end
	local particle_start = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
	local particle_end = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
	local damage = self:GetAbility():GetSpecialValueFor("damage")
	local delay = self:GetAbility():GetSpecialValueFor("delay")
	local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")
	local range = self:GetAbility():GetSpecialValueFor("range")
	local damage_table = {
						attacker = self:GetCaster(),
						damage_type = DAMAGE_TYPE_PURE,
						damage = damage
						}
	
	local hEnemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #hEnemies > 0 then
		for _, target in ipairs(hEnemies) do
			local point = target:GetAbsOrigin()
			local startFX = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, target)
			ParticleManager:SetParticleControl(startFX, 0, point)
			ParticleManager:SetParticleControl(startFX, 1, Vector(damage_radius, 0, 0))
			EmitSoundOn("Hero_Invoker.SunStrike.Charge", target)
			Timers:CreateTimer(delay, function()
				ParticleManager:DestroyParticle(startFX, false)
				local endFX = ParticleManager:CreateParticle(particle_end, PATTACH_ABSORIGIN, target)
				ParticleManager:SetParticleControl(endFX, 0, point)
				ParticleManager:SetParticleControl(endFX, 1, Vector(damage_radius, 0, 0))
				EmitSoundOn("Hero_Invoker.SunStrike.Ignite", target)
				local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, point, nil, damage_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false)
				for _, unit in ipairs(units) do
					damage_table.victim = unit
					ApplyDamage(damage_table)
				end
			end)
		end
	end
end
