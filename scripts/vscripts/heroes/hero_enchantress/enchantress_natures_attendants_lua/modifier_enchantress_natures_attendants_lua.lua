modifier_enchantress_natures_attendants_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_enchantress_natures_attendants_lua:IsHidden()
	return false
end

function modifier_enchantress_natures_attendants_lua:IsDebuff()
	return false
end

function modifier_enchantress_natures_attendants_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_enchantress_natures_attendants_lua:OnCreated( kv )
	
	self.caster		= self:GetCaster()
	
	self.count = self:GetAbility():GetSpecialValueFor( "wisp_count" ) -- special value
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" ) -- special value
	self.interval = self:GetAbility():GetSpecialValueFor( "heal_interval" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str6")             
	if abil ~= nil then 
	self.count = self.count * 2
	end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str9")             
	if abil ~= nil then 
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
	
	--self.caster:EmitSound("Hero_Enchantress.NaturesAttendantsCast")
end

function modifier_enchantress_natures_attendants_lua:OnRefresh( kv )
	-- references
	self.count = self:GetAbility():GetSpecialValueFor( "wisp_count" ) -- special value
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" ) -- special value
	self.interval = self:GetAbility():GetSpecialValueFor( "heal_interval" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) -- special value
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str6")             
	if abil ~= nil then 
	self.count = self.count * 2
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str9")             
	if abil ~= nil then 
	self.heal = self.heal * 2
	end

	if IsServer() then
		self:SetDuration(kv.duration+0.1,false)
		
		-- Start interval
		self:StartIntervalThink( self.interval )
	end	
end

function modifier_enchantress_natures_attendants_lua:OnDestroy( kv )
	if IsServer() then

		-- stop effects
		local sound_cast = "Hero_Enchantress.NaturesAttendantsCast"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_enchantress_natures_attendants_lua:OnIntervalThink()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int10")             
	if abil ~= nil then 
	local enemyes = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius + self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false)
		
		for _,enemy in pairs(enemyes) do
			ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self, damage = (self.heal*10), damage_type = DAMAGE_TYPE_MAGICAL})	
		end
	end
	
	
	local allies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- filter full health alliees
	local targets = {}
	for i,ally in pairs(allies) do
		if ally:GetHealthPercent()<100 then
			table.insert( targets, i )
		end
	end
	if #targets<1 then return end
	local n = #targets
	
	for i=1,self.count do
		allies[targets[RandomInt(1,n)]]:Heal( self.heal, self:GetAbility() )
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int7")             
		if abil ~= nil then 
		allies[targets[RandomInt(1,n)]]:GiveMana( self.heal)
		end
	end

---------------------------------------------------------------------------------------------	

end


--------------------------------------------------------------------------------------------------

modifier_resist = class({})

--------------------------------------------------------------------------------
function modifier_resist:IsHidden()
	return true
end

function modifier_resist:IsPurgable()
	return false
end

function modifier_resist:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end


function modifier_resist:GetModifierMagicalResistanceBonus()
	return 50
end
