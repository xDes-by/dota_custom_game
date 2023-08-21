LinkLuaModifier("modifier_templar_assassin_refraction_lua_damage", "heroes/hero_templar_assassin/templar_assassin_refraction_lua/templar_assassin_refraction_lua", LUA_MODIFIER_MOTION_NONE)

templar_assassin_refraction_lua = class({})

function templar_assassin_refraction_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_TemplarAssassin.Refraction")

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_refraction_lua_damage", {duration = self:GetSpecialValueFor("duration")})
end

-------------------------------------------------------
modifier_templar_assassin_refraction_lua_damage = class({})

function modifier_templar_assassin_refraction_lua_damage:IsPurgable()
	return false
end

function modifier_templar_assassin_refraction_lua_damage:GetTexture()
	return "templar_assassin_refraction_damage"
end

function modifier_templar_assassin_refraction_lua_damage:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	
	if not IsServer() then return end
	
	if self.damage_particle then
		ParticleManager:DestroyParticle(self.damage_particle, false)
		ParticleManager:ReleaseParticleIndex(self.damage_particle)
	end
	
	self.refraction_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refraction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.refraction_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.refraction_particle, false, false, -1, true, false)
	
	count = self:GetAbility():GetSpecialValueFor("instances")
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_templar_assassin_tal2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		count = count + 6
	end
	
	self:SetStackCount(count)
end

function modifier_templar_assassin_refraction_lua_damage:OnRefresh()
	self:OnCreated()
end

function modifier_templar_assassin_refraction_lua_damage:OnStackCountChanged(iStackCount)
	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end

function modifier_templar_assassin_refraction_lua_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

function modifier_templar_assassin_refraction_lua_damage:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_templar_assassin_refraction_lua_damage:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		keys.target:EmitSound("Hero_TemplarAssassin.Refraction.Damage")
		self:DecrementStackCount()
	end
end

function modifier_templar_assassin_refraction_lua_damage:GetAbsoluteNoDamagePhysical(keys)
	if keys.attacker and ((keys.damage and keys.damage >= 5) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) then
		return 1
	end
end

function modifier_templar_assassin_refraction_lua_damage:GetAbsoluteNoDamageMagical(keys)
	if keys.attacker and ((keys.damage and keys.damage >= 5) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) then
		return 1
	end
end

function modifier_templar_assassin_refraction_lua_damage:GetAbsoluteNoDamagePure(keys)
	if keys.attacker and ((keys.damage and keys.damage >= 5) or keys.damage_type == DAMAGE_TYPE_PHYSICAL or keys.damage_type == DAMAGE_TYPE_PURE) then
		self:GetParent():EmitSound("Hero_TemplarAssassin.Refraction.Absorb")
		
		local warp_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_plasma_contact_warp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(warp_particle)
		
		local hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(hit_particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(hit_particle)
		
		self:DecrementStackCount()
		return 1
	end
end