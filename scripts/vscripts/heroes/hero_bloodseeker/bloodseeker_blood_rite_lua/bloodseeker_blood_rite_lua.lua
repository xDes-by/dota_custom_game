LinkLuaModifier( "modifier_bloodseeker_blood_rite_lua_effect", "heroes/hero_bloodseeker/bloodseeker_blood_rite_lua/bloodseeker_blood_rite_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_blood_rite_lua_thinker", "heroes/hero_bloodseeker/bloodseeker_blood_rite_lua/bloodseeker_blood_rite_lua", LUA_MODIFIER_MOTION_NONE )

bloodseeker_blood_rite_lua = class({})

function bloodseeker_blood_rite_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function bloodseeker_blood_rite_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function bloodseeker_blood_rite_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if self.cast_position ~= nil then
		point = self.cast_position
	end
	CreateModifierThinker( caster, self, "modifier_bloodseeker_blood_rite_lua_thinker", {}, point, caster:GetTeamNumber(), false )
	EmitSoundOn( "Hero_Bloodseeker.BloodRite.Cast", caster )
	self.cast_position = nil
end

--------------------------------------------------------------------------------------------------------------------------------------------

modifier_bloodseeker_blood_rite_lua_thinker = class({})

function modifier_bloodseeker_blood_rite_lua_thinker:IsPurgable()
	return false
end

function modifier_bloodseeker_blood_rite_lua_thinker:OnCreated( kv )
	if IsServer() then
		local delay = self:GetAbility():GetSpecialValueFor("delay")
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.duration = self:GetAbility():GetSpecialValueFor("duration")
		local vision = 200
		
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetAgility() * self:GetAbility():GetSpecialValueFor("agility_dmg")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi7") ~= nil then
			self.damage = self.damage + self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetAgility() * 1.5
		end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int7") then
			delay = 1
		end

		self:StartIntervalThink( delay )

		AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), vision, 3, true)

		self:PlayEffects1()
	end
end

function modifier_bloodseeker_blood_rite_lua_thinker:OnDestroy( kv )
	if IsServer() then
		UTIL_Remove(self:GetParent())
	end
end

function modifier_bloodseeker_blood_rite_lua_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		
	flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	dam_type = DAMAGE_TYPE_PURE
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int7") ~= nil then
		flags = DOTA_DAMAGE_FLAG_NONE 
		dam_type = DAMAGE_TYPE_MAGICAL
	end
		
	local damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = dam_type,
		damage_flags = flags,
	}
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		
		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bloodseeker_blood_rite_lua_effect",  { duration = self.duration } )
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str9") ~= nil then
			enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned",  { duration = self.duration } )
		end
		
		self:PlayEffects3( enemy )
	end
	self:PlayEffects2()
	self:Destroy()
end

function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects1()
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_ring.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Bloodseeker.BloodRite", self:GetCaster() )
end

function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects2()
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

function modifier_bloodseeker_blood_rite_lua_thinker:PlayEffects3( target )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

-------------------------------------------------------------------------------------------------------------------

modifier_bloodseeker_blood_rite_lua_effect = class({})

function modifier_bloodseeker_blood_rite_lua_effect:IsHidden()
	return false
end

function modifier_bloodseeker_blood_rite_lua_effect:IsPurgable()
	return false
end

function modifier_bloodseeker_blood_rite_lua_effect:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_bloodseeker_blood_rite_lua_effect:OnIntervalThink()
	if not IsServer() then return end
	
	flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	dam_type = DAMAGE_TYPE_PURE
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int7") ~= nil then
		flags = DOTA_DAMAGE_FLAG_NONE 
		dam_type = DAMAGE_TYPE_MAGICAL
	end
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.try_damage,
		damage_type = dam_type,
		damage_flags = flags ,
	}
	SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE, self:GetParent(), self.try_damage, nil )
	ApplyDamage( self.damageTable )
end


function modifier_bloodseeker_blood_rite_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bloodseeker_blood_rite_lua_effect:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_DISABLE_HEALING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_bloodseeker_blood_rite_lua_effect:GetModifierMoveSpeedBonus_Percentage()
	return 50
end

function modifier_bloodseeker_blood_rite_lua_effect:GetDisableHealing()
	return 1
end

function modifier_bloodseeker_blood_rite_lua_effect:GetModifierIncomingDamage_Percentage(keys)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi10") ~= nil then
		if keys.attacker == self:GetCaster()  then
			return 25
		end
	end
	return 0
end
