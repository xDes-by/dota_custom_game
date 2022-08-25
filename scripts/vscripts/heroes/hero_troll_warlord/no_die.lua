LinkLuaModifier("modifier_npc_dota_hero_troll_warlord_str_last", "heroes/hero_troll_warlord/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_troll_warlord_str_last = class({})

function npc_dota_hero_troll_warlord_str_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_troll_warlord_str_last"
end

-----------------------------------------------------

modifier_npc_dota_hero_troll_warlord_str_last = class({})

function modifier_npc_dota_hero_troll_warlord_str_last:IsHidden()
	return true
end

function modifier_npc_dota_hero_troll_warlord_str_last:DeclareFunctions()		
	local decFuncs = 	{
						MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
						}		
	return decFuncs			
end

function modifier_npc_dota_hero_troll_warlord_str_last:GetModifierIncomingDamage_Percentage( params )
	if params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and self:GetParent() == params.target and not params.attacker:IsOther() and params.attacker:GetName() ~= "npc_dota_unit_undying_zombie"
		and IsServer() and self:GetAbility() and self:GetParent():IsRealHero() and self:GetParent():IsAlive() and not self:GetParent():PassivesDisabled() then
			if params.damage >= self:GetParent():GetHealth() then
				if RandomInt(1,100) <= 25 then
					self:GetCaster():EmitSound("Hero_Huskar.Inner_Fire.Cast")
						local pfxName = "particles/huskar/huskar.vpcf"
						local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
						ParticleManager:SetParticleControl( pfx, 0, self:GetParent():GetAbsOrigin() )
						ParticleManager:SetParticleControl( pfx, 1, Vector(1.5,1.5,1.5) )
						ParticleManager:SetParticleControl( pfx, 3, self:GetParent():GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex(pfx)
					self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * 0.25 )
				return -100
			end
		end
	end
end