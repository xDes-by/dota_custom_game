LinkLuaModifier( "modifier_bloodseeker_bloodrage_lua", "heroes/hero_bloodseeker/bloodseeker_bloodrage_lua/bloodseeker_bloodrage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bloodseeker_bloodrage_lua_proc", "heroes/hero_bloodseeker/bloodseeker_bloodrage_lua/bloodseeker_bloodrage_lua", LUA_MODIFIER_MOTION_NONE )

bloodseeker_bloodrage_lua = class({})

function bloodseeker_bloodrage_lua:GetAOERadius()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int_last") ~= nil then 
		return 300
	end
	return 0
end

function bloodseeker_bloodrage_lua:GetManaCost(iLevel)
	return math.min(65000, self:GetCaster():GetIntellect())
end

function bloodseeker_bloodrage_lua:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function bloodseeker_bloodrage_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	EmitSoundOn( "hero_bloodseeker.bloodRage", caster )
	
	local target = self:GetCursorTarget()
	target:AddNewModifier( caster, self, "modifier_bloodseeker_bloodrage_lua", { duration = duration } )
end

---------------------------------------------------------------------------------------

modifier_bloodseeker_bloodrage_lua = class({})

function modifier_bloodseeker_bloodrage_lua:IsHidden()
	return false
end

function modifier_bloodseeker_bloodrage_lua:IsPurgable()
	return true
end

function modifier_bloodseeker_bloodrage_lua:OnCreated( kv )
	self.bonus_as = self:GetAbility():GetSpecialValueFor( "bonus_as" )
	self.bonus_spell_amp = self:GetAbility():GetSpecialValueFor( "bonus_spell_amp" )
	self.hp_loss = self:GetAbility():GetSpecialValueFor( "hp_loss" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_int_last") then
		self.bonus_spell_amp = self.bonus_spell_amp + self:GetParent():GetIntellect() * 0.3
	end
	self:StartIntervalThink(0.1)
end

function modifier_bloodseeker_bloodrage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDEDs
	}
	return funcs
end

function modifier_bloodseeker_bloodrage_lua:OnAttackLanded(keys)
	if IsServer() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_agi11") ~= nil and self:GetParent() == keys.attacker and RandomInt(1,100) <= 10 then
			keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_lua_proc", {duration = 0.01})
		end
	end
end	
			
function modifier_bloodseeker_bloodrage_lua:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str8") ~= nil then 
		return self.bonus_as / 2
	end
	return 0
end

function modifier_bloodseeker_bloodrage_lua:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str11") ~= nil then 
		return 25
	end
	return 0
end

function modifier_bloodseeker_bloodrage_lua:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end

function modifier_bloodseeker_bloodrage_lua:GetModifierSpellAmplify_Percentage()
	return self.bonus_spell_amp
end

function modifier_bloodseeker_bloodrage_lua:OnIntervalThink()
if not IsServer() then return end
	df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	if self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str10") ~= nil then 
		df = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NON_LETHAL
	end
	local damage_table	=  {victim = self:GetParent(),
			attacker = self:GetParent(),
			damage = self:GetParent():GetMaxHealth()/1000*self.hp_loss,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = df
		}
	ApplyDamage(damage_table)
end

function modifier_bloodseeker_bloodrage_lua:GetModifierProcAttack_Feedback( params )
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

function modifier_bloodseeker_bloodrage_lua:OnTakeDamage( params )
	if IsServer() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bloodseeker_str6")
		if abil ~= nil then 
		
			local pass = false
			if self.attack_record and params.record == self.attack_record then
				pass = true
				self.attack_record = nil
			end
			if pass then
				local heal = params.damage * 0.1
				self:GetParent():Heal( heal, self:GetAbility() )
				self:PlayEffects2( self:GetParent() )
			end
		end
	end
end

function modifier_bloodseeker_bloodrage_lua:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_bloodseeker_bloodrage_lua:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_bloodseeker_bloodrage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bloodseeker_bloodrage_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

----------------------------------------------------------

modifier_bloodseeker_bloodrage_lua_proc	= modifier_bloodseeker_bloodrage_lua_proc or class({})

function modifier_bloodseeker_bloodrage_lua_proc:IsHidden() return true end
function modifier_bloodseeker_bloodrage_lua_proc:IsPurgable() return false end

function modifier_bloodseeker_bloodrage_lua_proc:DeclareFunctions()
	return {MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR}
end

function modifier_bloodseeker_bloodrage_lua_proc:GetModifierIgnorePhysicalArmor(keys)
	return 1
end