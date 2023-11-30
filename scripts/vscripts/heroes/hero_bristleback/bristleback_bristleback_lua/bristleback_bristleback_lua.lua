LinkLuaModifier( "modifier_bristleback_bristleback_lua", "heroes/hero_bristleback/bristleback_bristleback_lua/bristleback_bristleback_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sptay_realise", "heroes/hero_bristleback/bristleback_bristleback_lua/bristleback_bristleback_lua", LUA_MODIFIER_MOTION_NONE )

bristleback_bristleback_lua = class({})

function bristleback_bristleback_lua:GetIntrinsicModifierName()
	return "modifier_bristleback_bristleback_lua"
end

-----------------------------------------------------------------------------------------------------------

modifier_bristleback_bristleback_lua = class({})

function modifier_bristleback_bristleback_lua:OnCreated()
	self.caster = self:GetCaster()
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self:GetAbility():GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self:GetAbility():GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self:GetAbility():GetSpecialValueFor("side_angle")
	self.back_angle					= self:GetAbility():GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self:GetAbility():GetSpecialValueFor("quill_release_threshold")
end

function modifier_bristleback_bristleback_lua:OnRefresh()
	self.caster = self:GetCaster()
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self:GetAbility():GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self:GetAbility():GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self:GetAbility():GetSpecialValueFor("side_angle")
	self.back_angle					= self:GetAbility():GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self:GetAbility():GetSpecialValueFor("quill_release_threshold")
end

function modifier_bristleback_bristleback_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_bristleback_bristleback_lua:GetModifierIncomingDamage_Percentage(params)
	if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

		self.front_damage_reduction		= 0
		self.side_damage_reduction		= self:GetAbility():GetSpecialValueFor("side_damage_reduction")
		self.back_damage_reduction		= self:GetAbility():GetSpecialValueFor("back_damage_reduction")
		self.quill_release_threshold	= self:GetAbility():GetSpecialValueFor("quill_release_threshold")

		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_str10")
		if abil ~= nil then 
			self.side_damage_reduction = self.back_damage_reduction
		end

		local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_agi50")
		if abil ~= nil then 
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle)
		
			local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(particle2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle2)
			
			self:GetParent():EmitSound("Hero_Bristleback.Bristleback")
			return self.back_damage_reduction * (-1)
		end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_str50") or (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(particle2, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self:GetParent():EmitSound("Hero_Bristleback.Bristleback")
		
		return self.back_damage_reduction * (-1)
	elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		return self.side_damage_reduction * (-1)
	else
		return self.front_damage_reduction * (-1)
	end
end

function modifier_bristleback_bristleback_lua:OnTakeDamage( params )
	if IsServer() and not self:GetParent():HasModifier("modifier_sptay_realise") then
		if params.unit == self:GetParent() then
			if params.attacker == self:GetParent() or self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or not self:GetParent():HasAbility("bristleback_quill_spray_lua") or not self:GetParent():FindAbilityByName("bristleback_quill_spray_lua"):IsTrained() then return end
			
			if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
			if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
			if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "ability_npc_boss_plague_squirrel_spell2"  then return end
				
			if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_str50") then
				self.special_bonus_unique_npc_dota_hero_bristleback_str50 = true
			else
				forwardVector = self.caster:GetForwardVector()
				forwardAngle = math.deg(math.atan2(forwardVector.x, forwardVector.y))
						
				reverseEnemyVector = (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
				reverseEnemyAngle = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

				difference = math.abs(forwardAngle - reverseEnemyAngle)
			end

			if self.special_bonus_unique_npc_dota_hero_bristleback_str50 or (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
				self:SetStackCount(self:GetStackCount() + params.damage)
				
				local ability = self:GetParent():FindAbilityByName("bristleback_quill_spray_lua")
				if self:GetCaster():FindAbilityByName("npc_dota_hero_bristleback_int6") ~= nil then 
					if ability ~= nil and ability:GetLevel()>=1 then
						ApplyDamage({victim = params.attacker, attacker = self:GetCaster(), damage = ability:GetSpecialValueFor("quill_base_damage"), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
					end
				end
				if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_bristleback_agi50") then
					local m = self:GetCaster():FindModifierByName("modifier_bristleback_warpath_lua")
					if m then
						m.counter = m.counter + 1
						m:SetStackCount(math.min(m.counter, m.max_stacks))
					end
				end
				if ability and ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
					self:GetParent():AddNewModifier(self:GetParent(),nil,"modifier_sptay_realise",{ duration = 0.1 })
					ability:OnSpellStart()
					self:SetStackCount(0)
				end
			end
		end
	end
end

function modifier_bristleback_bristleback_lua:IsHidden()
	return true
end

----------------------------------------------------------------------
modifier_sptay_realise = class({})

function modifier_sptay_realise:IsHidden()
	return true
end

function modifier_sptay_realise:IsDebuff()
	return false
end

function modifier_sptay_realise:IsPurgable()
	return true
end