modifier_phantom_assassin_coup_de_grace_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_phantom_assassin_coup_de_grace_lua:IsHidden()
	-- actual true
	return true
end

function modifier_phantom_assassin_coup_de_grace_lua:IsPurgable()
	return false
end

function modifier_phantom_assassin_coup_de_grace_lua:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi10") ~= nil then
		self.crit_chance = self.crit_chance + 10
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi_last") ~= nil then
		self.crit_chance = self.crit_chance + 35
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi9") ~= nil then
		self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" ) + 200
	end
	self:StartIntervalThink(1)
end

function modifier_phantom_assassin_coup_de_grace_lua:OnRefresh( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" )

	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi10") ~= nil then
		self.crit_chance = self.crit_chance + 10
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi_last") ~= nil then
		self.crit_chance = self.crit_chance + 35
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_agi9") ~= nil then
		self.crit_bonus = self:GetAbility():GetSpecialValueFor( "crit_bonus" ) + 200
	end
end


function modifier_phantom_assassin_coup_de_grace_lua:OnIntervalThink()
self:OnRefresh()
end

function modifier_phantom_assassin_coup_de_grace_lua:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_phantom_assassin_coup_de_grace_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_phantom_assassin_coup_de_grace_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if self:RollChance( self.crit_chance ) then
			self.record = params.record

				if self:GetCaster():FindAbilityByName("npc_dota_hero_phantom_assassin_int9") ~= nil	then 
				--if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "phantom_assassin_knifes" then return end
					local abil2 = self:GetCaster():FindAbilityByName("phantom_assassin_knifes")
						if abil2 ~= nil and abil2:GetLevel() > 0 then
						local r2 = RandomInt(1,4)
						if r2 == 1 and not self:GetCaster():HasModifier("modifier_phantom_assassin_knifes_attack") then
							abil2:OnSpellStart()
						end
					end
				end
			return self.crit_bonus
		end
	end
end

function modifier_phantom_assassin_coup_de_grace_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record then
			self.record = nil
			self:PlayEffects( params.target )
		end
	end
end

function modifier_phantom_assassin_coup_de_grace_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end

function modifier_phantom_assassin_coup_de_grace_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
	local sound_cast = "Hero_PhantomAssassin.CoupDeGrace"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( sound_cast, target )
end