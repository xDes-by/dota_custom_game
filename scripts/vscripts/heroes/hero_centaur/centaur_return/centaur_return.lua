centaur_return_lua = centaur_return_lua or class({})
LinkLuaModifier("modifier_return_aura", "heroes/hero_centaur/centaur_return/centaur_return", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_return_passive", "heroes/hero_centaur/centaur_return/centaur_return", LUA_MODIFIER_MOTION_NONE)

function centaur_return_lua:GetIntrinsicModifierName()
	return "modifier_return_aura"
end

modifier_return_aura = class({})

function modifier_return_aura:OnCreated()
	self.caster = self:GetCaster()
	

	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_return_aura:GetAuraEntityReject(target)
	if self.caster == target then
		return false 
	else
	
	local abil = self.caster:FindAbilityByName("npc_dota_hero_centaur_int10")
	if abil ~= nil then
			return false
		end
	end

	return true
end

function modifier_return_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_return_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_return_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_return_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_return_aura:GetModifierAura()
	return "modifier_return_passive"
end

function modifier_return_aura:IsAura()
	return true
end

function modifier_return_aura:IsHidden()
	return true
end

function modifier_return_aura:IsPurgable()
	return false
end

modifier_return_passive = class({})

function modifier_return_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_return_passive:OnTakeDamage(keys)
	if IsServer() and self:GetAbility() then

		local caster = self:GetCaster()
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local attacker = keys.attacker
		local target = keys.unit
		local particle_return = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
		
		damage_type = DAMAGE_TYPE_MAGICAL
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				
		damage = ability:GetSpecialValueFor("damage")
		str_pct_as_damage = ability:GetSpecialValueFor("str_pct_as_damage")
		local abil = caster:FindAbilityByName("npc_dota_hero_centaur_int6")
		if abil ~= nil then
			damage_type = DAMAGE_TYPE_PURE
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		end		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_int_last") ~= nil then
			damage = ability:GetSpecialValueFor("damage") * 2
			str_pct_as_damage = ability:GetSpecialValueFor("str_pct_as_damage") * 2
		end

		local abil = caster:FindAbilityByName("npc_dota_hero_centaur_str11")
		if abil ~= nil then
			str_pct_as_damage = str_pct_as_damage + 50 
		end

		if self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_str_last") ~= nil then
			str_pct_as_damage = str_pct_as_damage + 100 
		end

		if not target:IsRealHero() then
			return nil
		end

		if parent:PassivesDisabled() then
			return nil
		end

		if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and not attacker:IsOther() and attacker:GetName() ~= "npc_dota_unit_undying_zombie" and not attacker:IsBuilding() then
		 if keys.damage_category == 1 then

			local particle_return_fx = ParticleManager:CreateParticle(particle_return, PATTACH_ABSORIGIN, parent)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(particle_return_fx, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(particle_return_fx)
			
			local abil = caster:FindAbilityByName("npc_dota_hero_centaur_agi6")
			if abil ~= nil then
				damage = damage + (self:GetParent():GetAgility() * str_pct_as_damage * 0.01)
			else
				damage = damage + (self:GetParent():GetStrength() * str_pct_as_damage * 0.01)
			end
			
			
			local abil = caster:FindAbilityByName("npc_dota_hero_centaur_str6")
			if abil ~= nil then 
				if caster:HasModifier("modifier_imba_borrowed_time_buff_hot_caster") then
					damage = damage * 2 
				end
			end
			local abil = caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_centaur_int50")
			if abil ~= nil and damage_type ~= DAMAGE_TYPE_PURE then 
				damage = damage * (1 + self:GetParent():GetSpellAmplification(false) * 0.1)
			end		

			ApplyDamage({
				victim = attacker,
				attacker = parent,
				damage = damage,
				damage_type = damage_type,
				damage_flags = damage_flags,
				ability = ability
			})
		end
	end
	end
end


function modifier_return_passive:IsHidden()
	return true
end

function modifier_return_passive:IsPurgable()
	return false
end
