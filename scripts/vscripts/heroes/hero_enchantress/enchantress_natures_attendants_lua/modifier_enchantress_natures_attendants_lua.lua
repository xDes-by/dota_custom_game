modifier_enchantress_natures_attendants_lua = class({})

function modifier_enchantress_natures_attendants_lua:IsHidden()
	return false
end

function modifier_enchantress_natures_attendants_lua:IsDebuff()
	return false
end

function modifier_enchantress_natures_attendants_lua:IsPurgable()
	return false
end

function modifier_enchantress_natures_attendants_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" ) -- special value
	self.interval = self:GetAbility():GetSpecialValueFor( "heal_interval" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str9")  ~= nil then 
		self.heal = self.heal * 2
	end

	if IsServer() then
		self:SetDuration(kv.duration+0.1,false)

		self:StartIntervalThink( self.interval )

		local sound_cast = "Hero_Enchantress.NaturesAttendantsCast"
		EmitSoundOn( sound_cast, self:GetParent() )
	end
		
	self.particle_name = "particles/units/heroes/hero_enchantress/enchantress_natures_attendants_count14.vpcf"
	
	self.particle = ParticleManager:CreateParticle(self.particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	
	for wisp = 3, 3 + 3 do
		ParticleManager:SetParticleControlEnt(self.particle, wisp, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
	
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_enchantress_natures_attendants_lua:OnRefresh( kv )
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" ) -- special value
	self.interval = self:GetAbility():GetSpecialValueFor( "heal_interval" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str9")  ~= nil then 
		self.heal = self.heal * 2
	end

	if IsServer() then
		self:SetDuration(kv.duration+0.1,false)
		
		self:StartIntervalThink( self.interval )
	end	
end

function modifier_enchantress_natures_attendants_lua:OnDestroy( kv )
	if IsServer() then
		local sound_cast = "Hero_Enchantress.NaturesAttendantsCast"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end


function modifier_enchantress_natures_attendants_lua:OnIntervalThink()
	local heal = self:GetParent():GetMaxHealth()/100*self.heal

	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int10") ~= nil then 
		local enemyes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
		for _,enemy in pairs(enemyes) do
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = heal, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})	
		end
	end
	
	local allies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false)
	for i,ally in pairs(allies) do
		if ally:GetHealthPercent()<100 then
			ally:Heal(heal, self:GetAbility() )
		end
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int7") ~= nil then 
			ally:GiveMana(heal)
		end
	end
end


--------------------------------------------------------------------------------------------------

modifier_resist = class({})

function modifier_resist:IsHidden()
	return true
end

function modifier_resist:IsPurgable()
	return false
end

function modifier_resist:OnCreated( kv )
end

function modifier_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_resist:GetModifierMagicalResistanceBonus()
	return 50
end
