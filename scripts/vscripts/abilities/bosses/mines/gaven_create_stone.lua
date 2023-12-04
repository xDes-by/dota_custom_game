LinkLuaModifier("modifier_pulse", "abilities/bosses/mines/gaven_create_stone", LUA_MODIFIER_MOTION_NONE)

gaven_create_stone = class({})

function gaven_create_stone:OnSpellStart()
	if IsServer() then
		for i = 1, 3 do
			local caster_pos = self:GetCaster():GetAbsOrigin()
			local angle = RandomInt(0, 360)
			local variance = RandomInt(-700, 700)
			local dy = math.sin(angle) * variance
			local dx = math.cos(angle) * variance
			local target_point = Vector(caster_pos.x + dx, caster_pos.y + dy, caster_pos.z)
		
			local unit = CreateUnitByName("npc_dota_gaven_stone", target_point, true, nil, nil, self:GetCaster():GetTeamNumber())
			unit:AddNewModifier(unit, nil, "modifier_kill", {duration = 10})
			unit:AddNewModifier(unit, nil, "modifier_pulse", {duration = 10})
		end
	end
end

-------------------------------------------------------------------------------------------------------

modifier_pulse = class({})

function modifier_pulse:IsHidden()
	return true
end

function modifier_pulse:IsPurgable()
	return false
end

function modifier_pulse:OnCreated( kv )
		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
	self:StartIntervalThink(2)
end

function modifier_pulse:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsAlive() then
			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = 0.5} )
				self.damageTable.victim = enemy
				self.damageTable.damage = enemy:GetMaxHealth() * 0.10,
				ApplyDamage(self.damageTable)
			end
			self:PlayEffects()
		end
	end
end

function modifier_pulse:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 400, 400, 400 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end