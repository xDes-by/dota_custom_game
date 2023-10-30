modifier_sand_caustic_debuff = class({})

function modifier_sand_caustic_debuff:IsHidden()
	return false
end

function modifier_sand_caustic_debuff:IsDebuff()
	return true
end

function modifier_sand_caustic_debuff:IsPurgable()
	return true
end

function modifier_sand_caustic_debuff:DestroyOnExpire()
	return true
end

function modifier_sand_caustic_debuff:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "caustic_finale_radius" ) -- special value
	self.damage = self:GetAbility():GetSpecialValueFor( "caustic_finale_damage" ) -- special value
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "caustic_finale_slow_duration" ) -- special value
	
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int11") ~= nil then 
		self.damage = self.damage + self:GetCaster():GetIntellect()
	end
		
	if IsServer() then
		self:StartIntervalThink( kv.duration )
	end
end

function modifier_sand_caustic_debuff:OnRefresh( kv )
	
end

function modifier_sand_caustic_debuff:OnDestroy( kv )

end

function modifier_sand_caustic_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_sand_caustic_debuff:OnDeath( params )
	if IsServer() then
		if params.unit~=self:GetParent() then return end
		if params.unit:GetTeamNumber()==params.attacker:GetTeamNumber() then return end
		self:Explode( true )
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_sand_king_int50") ~= nil then
			self:GetCaster():ModifyIntellect(1)
			self:GetCaster():CalculateStatBonus(true)
		end
	end
end

function modifier_sand_caustic_debuff:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sand_king_int6") ~= nil then 
		self:Explode( false )
	end
end

--------------------------------------------------------------------------------
-- Helper function
function modifier_sand_caustic_debuff:Explode( death )
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage table
	local dmg = self.damage
	if death then dmg = self.damage * 2 end
	local damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = dmg,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}

	for _,enemy in pairs(enemies) do
	
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- effects
	self:PlayEffects()

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sand_caustic_debuff:GetEffectName()
	return "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf"
end

function modifier_sand_caustic_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sand_caustic_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local sound_cast = "Ability.SandKing_CausticFinale"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end