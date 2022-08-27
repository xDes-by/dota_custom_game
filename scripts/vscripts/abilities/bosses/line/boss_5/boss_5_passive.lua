LinkLuaModifier("modifier_boss_5_passive", 	"abilities/bosses/line/boss_5/boss_5_passive", LUA_MODIFIER_MOTION_NONE)

boss_5_passive = class({})

function boss_5_passive:GetIntrinsicModifierName()
    return "modifier_boss_5_passive"
end

---------------------------------------------------------------

modifier_boss_5_passive = class({})

function modifier_boss_5_passive:OnCreated()
	self.shield_particle = ParticleManager:CreateParticle("particles/items2_fx/mjollnir_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.shield_particle, false, false, -1, false, false)

	self.static_chance	 	= self:GetAbility():GetSpecialValueFor("static_chance")
	self.static_strikes	 	= self:GetAbility():GetSpecialValueFor("static_strikes")
	self.static_damage	 	= self:GetAbility():GetSpecialValueFor("static_damage")
	self.static_radius		= self:GetAbility():GetSpecialValueFor("static_radius")
	self.static_cooldown	= self:GetAbility():GetSpecialValueFor("static_cooldown")

	self.prock = true
end

function modifier_boss_5_passive:DeclareFunctions()
	return{
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}
end

function modifier_boss_5_passive:OnIntervalThink()
	self.prock = true
	self:StartIntervalThink(-1)
end

function modifier_boss_5_passive:OnTakeDamage(keys)
	local bResult = xpcall(function()
	if keys.unit == self:GetParent() and keys.attacker ~= self:GetParent() and self.prock == true and keys.damage >= 5 and RandomInt(0,100) == self.static_chance then
		self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
		if (keys.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.static_radius and not keys.attacker:IsBuilding() and not keys.attacker:IsOther() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local static_particle	= nil
			static_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.unit)
			ParticleManager:SetParticleControlEnt(static_particle, 0, keys.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.attacker:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(static_particle)
			
			ApplyDamage({
				victim 			= keys.attacker,
				damage 			= self.static_damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})	
		end
		
		local unit_count = 0
		
		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.static_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)) do
			if enemy ~= keys.attacker then
				static_particle = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControlEnt(static_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(static_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(static_particle)
				ApplyDamage({
					victim 			= enemy,
					damage 			= self.static_damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= self:GetCaster(),
					ability 		= self:GetAbility()
				})
								
				unit_count = unit_count + 1
				
				if (unit_count >= self.static_strikes and self.static_strikes > 0) then
					break
				end
			end
		end
		
		self.bStaticCooldown = true
		self:StartIntervalThink(self.static_cooldown)
	end
	end,
		function(e)
		print("-------------Error-------------")
		print(e)
		print("-------------Error-------------")
	end)  
	--дебаг
	
	--вызов вункции в которой может быть ошибка
	if bResult then
	--print("all ok")
	else
	print("error")
	end		
end