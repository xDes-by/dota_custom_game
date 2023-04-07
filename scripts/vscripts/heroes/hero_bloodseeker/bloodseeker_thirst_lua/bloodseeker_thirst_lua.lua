LinkLuaModifier( "modifier_bloodseeker_thirst_lua", "heroes/hero_bloodseeker/bloodseeker_thirst_lua/bloodseeker_thirst_lua", LUA_MODIFIER_MOTION_NONE )

bloodseeker_thirst_lua = class({})

function bloodseeker_thirst_lua:GetManaCost(iLevel)
	return math.min(65000, self:GetCaster():GetIntellect())
end

function bloodseeker_thirst_lua:OnSpellStart()
	local caster = self:GetCaster()
	local hit_self = self:GetSpecialValueFor("hit_self")
	local duration = self:GetSpecialValueFor("duration")
	EmitSoundOn( "hero_bloodseeker.bloodRage", caster )
	caster:AddNewModifier( caster, self, "modifier_bloodseeker_thirst_lua", { duration = duration } )
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") ~= nil then 
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
	end
	
	local damage_table	=  {victim = caster,
			attacker = caster,
			damage = caster:GetMaxHealth()/100*hit_self,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = df
		}
	ApplyDamage(damage_table)
end

---------------------------------------------------------------------------------------

modifier_bloodseeker_thirst_lua = class({})

function modifier_bloodseeker_thirst_lua:IsHidden()
	return false
end

function modifier_bloodseeker_thirst_lua:IsPurgable()
	return true
end

function modifier_bloodseeker_thirst_lua:OnCreated( kv )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.bonus_lifesteal = self:GetAbility():GetSpecialValueFor( "bonus_lifesteal" )
	self.bonus_movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	
	self.try_damage = self.bonus_damage
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi6") ~= nil then
		self.try_damage = self.bonus_damage + self:GetCaster():GetAgility()
	end
	
end

function modifier_bloodseeker_thirst_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_MAX,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_bloodseeker_thirst_lua:OnAttackLanded(params)
	if IsServer() then
		if params.attacker==self:GetParent() and self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi9") ~= nil then
			local damage = params.original_damage * 0.5
			DoCleaveAttack(self:GetParent(),params.target,self:GetAbility(),damage, 150, 360, 360, 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf')
		end
	end
end

function modifier_bloodseeker_thirst_lua:GetModifierTotalDamageOutgoing_Percentage(k)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int9") ~= nil then
		if k.damage_type ~= 1 then
			return 15
		end
	end
end

function modifier_bloodseeker_thirst_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.bonus_movespeed
end

function modifier_bloodseeker_thirst_lua:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_bloodseeker_thirst_lua:GetModifierMoveSpeed_Max()
	return 9999
end

function modifier_bloodseeker_thirst_lua:GetModifierPreAttack_BonusDamage()
	return self.try_damage
end

function modifier_bloodseeker_thirst_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local pass = false
		if params.target:GetTeamNumber()~=self:GetParent():GetTeamNumber() then
			if (not params.target:IsBuilding()) and (not params.target:IsOther()) then
				pass = true
			end
		end
		if pass then
			self.attack_record = params.record
		end
	end
end

function modifier_bloodseeker_thirst_lua:OnTakeDamage( params )
	if IsServer() then	
		local pass = false
		if self.attack_record and params.record == self.attack_record then
			pass = true
			self.attack_record = nil
		end
		if pass then
			local heal = params.damage * self.bonus_lifesteal/100
			self:GetParent():Heal( heal, self:GetAbility() )
			self:PlayEffects2( self:GetParent() )
		end
	end
end

function modifier_bloodseeker_thirst_lua:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end