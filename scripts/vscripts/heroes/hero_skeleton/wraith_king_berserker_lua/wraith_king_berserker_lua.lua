wraith_king_berserker_lua = class({})
LinkLuaModifier( "modifier_wraith_king_berserker_lua", "heroes/hero_skeleton/wraith_king_berserker_lua/wraith_king_berserker_lua", LUA_MODIFIER_MOTION_NONE )

function wraith_king_berserker_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_berserker_lua"
end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

modifier_wraith_king_berserker_lua = class({})

function modifier_wraith_king_berserker_lua:IsHidden()
	return true
end

function modifier_wraith_king_berserker_lua:IsDebuff()
	return false
end

function modifier_wraith_king_berserker_lua:IsPurgable()
	return false
end

function modifier_wraith_king_berserker_lua:OnCreated( kv )
	self.max_as = self:GetAbility():GetSpecialValueFor( "maximum_attack_speed" )
	self.max_mr = self:GetAbility():GetSpecialValueFor( "maximum_resistance" )
	self.max_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )
	self.range = 100-self.max_threshold
	self.max_size = 35

	self:PlayEffects()
end

function modifier_wraith_king_berserker_lua:OnRefresh( kv )
	self.max_as = self:GetAbility():GetSpecialValueFor( "maximum_attack_speed" )
	self.max_mr = self:GetAbility():GetSpecialValueFor( "maximum_resistance" )
	self.max_threshold = self:GetAbility():GetSpecialValueFor( "hp_threshold_max" )	
	self.range = 100-self.max_threshold
end

function modifier_wraith_king_berserker_lua:OnRemoved()
end

function modifier_wraith_king_berserker_lua:OnDestroy()
end

function modifier_wraith_king_berserker_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_wraith_king_berserker_lua:GetModifierMagicalResistanceBonus()
	-- interpolate missing health
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_mr
end

function modifier_wraith_king_berserker_lua:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str8")
		if abil ~= nil then 
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_mr
	else
	return 0
	end
end

function modifier_wraith_king_berserker_lua:GetModifierAttackSpeedBonus_Constant()
	-- interpolate missing health
	local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)
	return (1-pct)*self.max_as
end


function modifier_wraith_king_berserker_lua:GetModifierModelScale()
	if IsServer() then
		local pct = math.max((self:GetParent():GetHealthPercent()-self.max_threshold)/self.range,0)

		-- set dynamic effects
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( (1-pct)*100,0,0 ) )

		return (1-pct)*self.max_size
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wraith_king_berserker_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_berserkers_blood_glow.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

function modifier_wraith_king_berserker_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			pass = true
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_int8")
		if abil ~= nil then 

			if pass and self:RollChance(30) then
				self.attack_record = params.record
				return self:GetCaster():GetIntellect()/10
			end
		end
	end
	return 0
end

function modifier_wraith_king_berserker_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if self.attack_record and params.record==self.attack_record then
			pass = true
			self.attack_record = nil
		end

		if pass then
			self:PlayEffects2( params.target )
		end
	end
end

function modifier_wraith_king_berserker_lua:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and  self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_int_last") ~= nil and RandomInt(1, 100) <= 5 and params.attacker:FindAbilityByName("wraith_king_sceleton") ~= nil then
		if params.attacker:FindAbilityByName("wraith_king_sceleton"):GetLevel() > 0 then
			self:GetCaster():FindAbilityByName("wraith_king_sceleton"):OnSpellStart()
		end
	end
end

function modifier_wraith_king_berserker_lua:PlayEffects2( target )
	--local particle_impact = "particles/units/heroes/hero_skeletonking/skeletonking_mortalstrike.vpcf"
	local sound_impact = "Hero_SkeletonKing.CriticalStrike"
	--local effect_impact = ParticleManager:CreateParticle( particle_impact, PATTACH_ABSORIGIN_FOLLOW, target )
--	ParticleManager:SetParticleControl( effect_impact, 2, target:GetOrigin() )
	--ParticleManager:ReleaseParticleIndex( effect_impact )

	EmitSoundOn( sound_impact, target )
end

function modifier_wraith_king_berserker_lua:RollChance( chance )
	local rand = math.random()
	if rand<chance/100 then
		return true
	end
	return false
end