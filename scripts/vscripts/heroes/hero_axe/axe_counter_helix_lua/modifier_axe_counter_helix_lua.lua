modifier_axe_counter_helix_lua = class({})


function modifier_axe_counter_helix_lua:IsHidden()
	if self:GetStackCount() ~= 0 then
		return false
	end
	return true
end

function modifier_axe_counter_helix_lua:IsPurgable()
	return false
end

function modifier_axe_counter_helix_lua:OnCreated( kv )
	-- references
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
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}

	return funcs
end

function modifier_axe_counter_helix_lua:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetAbility():IsFullyCastable() then
		self.chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )
		self.damage	 = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		
		if self:GetAbility() and not self:GetCaster():PassivesDisabled() and ((params.target == self:GetParent() and not params.attacker:IsBuilding() and not params.attacker:IsOther() and params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber()) or (params.attacker == self:GetCaster() and HasTalent(self:GetCaster(), "npc_dota_hero_axe_agi11") )) then
			
			caster = self:GetCaster()
			damage_type = DAMAGE_TYPE_PURE
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
			
			if self:GetAbility():GetAutoCastState() then
				damage_type = DAMAGE_TYPE_MAGICAL
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				if caster:FindAbilityByName("npc_dota_hero_axe_str9") then 
					self.damage = self.damage + caster:GetStrength()
				end
				if caster:FindAbilityByName("npc_dota_hero_axe_agi10") then 
					self.damage = self.damage + caster:GetAgility()
				end
				if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int9") then
					self.damage = self.damage + caster:GetIntellect()
				end
			else
				if caster:FindAbilityByName("npc_dota_hero_axe_str_last") then
					if caster:GetMaxHealth() * 0.002 <= 2000 then
						self.damage = self.damage + caster:GetMaxHealth() * 0.002
					else
						self.damage = self.damage + 2000
					end
				end
				if caster:FindAbilityByName("npc_dota_hero_axe_int11") then
					self.damage = self.damage + self:GetAbility():GetLevel() * 30
				end
			end
			
			if caster:FindAbilityByName("npc_dota_hero_axe_agi8") then
				self.radius = self.radius + 100
			end
			if caster:FindAbilityByName("npc_dota_hero_axe_int8") and RandomInt(1, 100) <= 50 then
				self.damage = self.damage * 2
			end
			if caster:FindAbilityByName("npc_dota_hero_axe_int6") ~= nil then 
				self.chance = self.chance + 15
			end
			if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_axe_int50") ~= nil then 
				self.damage = self.damage * 3
			end
			if RandomInt(1,100) <= self.chance then 
				-- find enemies
				local enemies = FindUnitsInRadius(
					caster:GetTeamNumber(),	-- int, your team number
					caster:GetOrigin(),	-- point, center point
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
					attacker = caster,
					damage = self.damage,
					damage_type = damage_type,
					ability = self:GetAbility(), --Optional.
					damage_flags = damage_flags, --Optional.
				}

				-- damage
				for _,enemy in pairs(enemies) do
					if caster:FindAbilityByName("npc_dota_hero_axe_str8") then
						if not enemy:HasModifier("modifire_dota_hero_axe_str8") then
							enemy:AddNewModifier(caster, self:GetAbility(), "modifire_dota_hero_axe_str8", {})
						end
						enemy:FindModifierByName("modifire_dota_hero_axe_str8"):AddStack(15)
					end
					self.damageTable.victim = enemy
					ApplyDamage( self.damageTable )
					if caster:FindAbilityByName("npc_dota_hero_axe_agi_last") and not self:GetAbility():GetAutoCastState() then
						caster:PerformAttack(
							enemy, -- hTarget
							false, -- bUseCastAttackOrb
							true, -- bProcessProcs
							true, -- bSkipCooldown
							false, -- bIgnoreInvis
							false, -- bUseProjectile
							false, -- bFakeAttack
							false -- bNeverMiss
						)
					end
				end

				-- cooldown
				self:GetAbility():UseResources( false, false, false, true)

				-- effects
				self:PlayEffects()
			end
		end
	end
end

function modifier_axe_counter_helix_lua:OnDeath(data)
	if data.attacker ~= self:GetParent() then
		return
	end
	if data.inflictor and data.inflictor:GetAbilityName() == "axe_counter_helix_lua" then
		if self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_axe_str50") then
			self:IncrementStackCount()
		end
	end
end

function modifier_axe_counter_helix_lua:GetModifierConstantHealthRegen()
	return self:GetStackCount() * 3
end

function modifier_axe_counter_helix_lua:GetModifierHealthBonus()
	return self:GetStackCount() * 30
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