modifier_axe_counter_helix_lua = class({})


function modifier_axe_counter_helix_lua:IsHidden()
	return true
end

function modifier_axe_counter_helix_lua:IsPurgable()
	return false
end

function modifier_axe_counter_helix_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor( "damage" )
		
	end
end

function modifier_axe_counter_helix_lua:OnRefresh( kv )
	if IsServer() then
		local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	end
end

function modifier_axe_counter_helix_lua:OnDestroy( kv )

end


function modifier_axe_counter_helix_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function modifier_axe_counter_helix_lua:OnAttackLanded( params )
	if IsServer() then
	if self:GetAbility():IsFullyCastable() then
		self.chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )
		self.damage	 = self:GetAbility():GetSpecialValueFor( "damage" )
		
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() and ((params.target == self:GetParent() and not params.attacker:IsBuilding() and not params.attacker:IsOther() and params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber()) or (params.attacker == self:GetCaster() and HasTalent(self:GetCaster(), "npc_dota_hero_axe_agi11") )) then
	
	
		
	--	if  and params.attacker == self:GetCaster() then return end
		
	--	if params.target~=self:GetCaster() then return end
	--	if self:GetCaster():PassivesDisabled() then return end
	--	if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
	--	if params.attacker:IsOther() or params.attacker:IsBuilding() then return end
		

		
		
	caster = self:GetCaster()
	damage_type = DAMAGE_TYPE_PURE
	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int9")				--магический усиливаемый
		if abil ~= nil then 
		damage_type = DAMAGE_TYPE_MAGICAL
		damage_flags = DOTA_DAMAGE_FLAG_NONE
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_agi_last")				-- + к урону крутилки
		if abil ~= nil then 
		self.damage = self.damage + self:GetCaster():GetAgility()
	end
		
		
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_str9")               -- шанс крутилки 100%
			if abil ~= nil then 
				if caster:HasModifier("modifier_axe_berserkers_call_lua") then 
				  self.chance = 100
				end
		end
			
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int8")		-- шанс крутилки
			if abil ~= nil then 
			self.chance = self.chance + 15
		end
		local c = RandomInt(1,100)
				
		if c <= self.chance then 


		-- find enemies
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	
---------------------------------------------------
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = damage_type,
			ability = self:GetAbility(), --Optional.
			damage_flags = damage_flags, --Optional.
		}

		-- damage
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end

		-- cooldown
		self:GetAbility():UseResources( false, false, true )

		-- effects
		self:PlayEffects()
	end
	end
end
end
end

--------------------------------------------------------------------------------

function modifier_axe_counter_helix_lua:PlayEffects2( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


-- Graphics & Animations
function modifier_axe_counter_helix_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
	
	local sound_cast = "Hero_Axe.CounterHelix"
	
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end


function HasTalent(unit, talentName)
    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end