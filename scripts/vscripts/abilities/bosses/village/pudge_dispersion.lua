
LinkLuaModifier("modifier_pudge_dispersion", "abilities/bosses/village/pudge_dispersion.lua", LUA_MODIFIER_MOTION_NONE )

pudge_dispersion = class({})


function pudge_dispersion:GetIntrinsicModifierName()
    return "modifier_pudge_dispersion"
end
function pudge_dispersion:OnUpgrade()
	self:GetCaster():RemoveModifierByName("modifier_pudge_dispersion")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pudge_dispersion" , {})
end

------------------------------------------------------------------------

modifier_pudge_dispersion = class({})

function modifier_pudge_dispersion:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end
function modifier_pudge_dispersion:OnCreated()	
	self.damage_reflect_pct = self:GetAbility():GetSpecialValueFor("damage_reflection_pct") * 0.01
	self.min_radius = self:GetAbility():GetSpecialValueFor("min_radius")
	local think_interval = 3
	self:StartIntervalThink(think_interval)
end
if IsServer() then
function modifier_pudge_dispersion:OnTakeDamage (event)
	
	if event.unit == self:GetParent() then
		if event.damage_flags ~= 16 then
			local post_damage = event.damage
			local original_damage = event.original_damage
			
			local unit = event.attacker
			if unit:GetTeam() ~= self:GetParent():GetTeam() then
				local vparent = self:GetParent():GetAbsOrigin()
				local vUnit = unit:GetAbsOrigin()

				local reflect_damage = 0.0
				local particle_name = ""

				local distance = (vUnit - vparent):Length2D()
				
				--Within 300 radius		
				if distance <= self.min_radius then
					reflect_damage = original_damage * self.damage_reflect_pct
					particle_name = "particles/units/heroes/hero_spectre/spectre_dispersion.vpcf"
					if self:GetParent():IsAlive() then
						self:GetParent():SetHealth(self:GetParent():GetHealth() + (post_damage * self.damage_reflect_pct) )
					end
				--Between 301 and 475 radius
				else
					local ratio = self.damage_reflect_pct * (1 - (distance - self.min_radius) * 0.142857 * 0.01)
					reflect_damage = original_damage *  ratio
					particle_name = "particles/units/heroes/hero_spectre/spectre_dispersion_b_fallback_mid.vpcf"
					if self:GetParent():IsAlive() then
						self:GetParent():SetHealth(self:GetParent():GetHealth() + (post_damage * ratio) )
					end
				end
				
				--Create particle
				local particle = ParticleManager:CreateParticle( particle_name, PATTACH_POINT_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl(particle, 0, vparent)
				ParticleManager:SetParticleControl(particle, 1, vUnit)
				ParticleManager:SetParticleControl(particle, 2, vparent)	
				ApplyDamage({
					ability = self:GetAbility(),
					attacker = self:GetParent(),
					damage = reflect_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					victim = unit,
				})

			end
		end
	end

end

function modifier_pudge_dispersion:OnIntervalThink()
	local talent = self:GetParent():FindAbilityByName("special_bonus_unique_spectre_5")
	if talent and talent:GetLevel() > 0 then
		self.damage_reflect_pct = self.damage_reflect_pct + talent:GetSpecialValueFor("value") * 0.01
		self:StartIntervalThink(-1)
	end
end
end
function modifier_pudge_dispersion:IsHidden()
	return true
end

function modifier_pudge_dispersion:RemoveOnDeath()
	return false
end

function modifier_pudge_dispersion:IsPurgable()
	return false
end