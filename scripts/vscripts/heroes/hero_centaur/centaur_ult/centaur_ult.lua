LinkLuaModifier("modifier_imba_borrowed_time_handler", "heroes/hero_centaur/centaur_ult/centaur_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_borrowed_time_buff_hot_caster", "heroes/hero_centaur/centaur_ult/centaur_ult.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_centaur_ult_hp", "heroes/hero_centaur/modifier_centaur_ult_hp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stomp", "heroes/hero_centaur/modifier_stomp", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ult_damage", "heroes/hero_centaur/centaur_ult/centaur_ult", LUA_MODIFIER_MOTION_NONE)

borrowed_time_datadriven = class({})

function borrowed_time_datadriven:GetIntrinsicModifierName()
	if self:GetCaster():IsRealHero() then
		return "modifier_imba_borrowed_time_handler"
	end
end

function borrowed_time_datadriven:IsNetherWardStealable()
	return false
end

function borrowed_time_datadriven:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local buff_duration = self:GetSpecialValueFor("duration")
		
		local abil = caster:FindAbilityByName("npc_dota_hero_centaur_str9")
		if abil ~= nil then
			buff_duration = buff_duration + 3
		end

		caster:AddNewModifier(caster, self, "modifier_imba_borrowed_time_buff_hot_caster", { duration = buff_duration })
		-- local responses = {"abaddon_abad_borrowedtime_02","abaddon_abad_borrowedtime_03","abaddon_abad_borrowedtime_04","abaddon_abad_borrowedtime_05","abaddon_abad_borrowedtime_06","abaddon_abad_borrowedtime_07","abaddon_abad_borrowedtime_08","abaddon_abad_borrowedtime_09","abaddon_abad_borrowedtime_10","abaddon_abad_borrowedtime_11"}
		-- if not caster:EmitCasterSound("npc_dota_hero_abaddon",responses, 50, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS,nil,nil) then
			-- caster:EmitCasterSound("npc_dota_hero_abaddon",{"abaddon_abad_borrowedtime_01"}, 1, DOTA_CAST_SOUND_FLAG_BOTH_TEAMS, nil,nil)
		-- end
	end
end

---------------------------------------------------------------------------------------

modifier_imba_borrowed_time_handler = class({
	IsHidden				= function(self) return true end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	AllowIllusionDuplicate	= function(self) return false end,
})

function modifier_imba_borrowed_time_handler:_CheckHealth(damage)
	if IsServer() then
	
		if self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled() and self:GetParent():IsAlive() then
			if self:GetParent():GetHealthPercent() <= self.hp_threshold then
				self:GetParent():CastAbilityImmediately(self:GetAbility(), self:GetParent():GetPlayerID())
			end
		end
	end
end

function modifier_imba_borrowed_time_handler:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		if target:IsIllusion() then
			self:Destroy()
		else
			self.hp_threshold = self:GetAbility():GetSpecialValueFor("hp_threshold")
			self:_CheckHealth(0)
		end
	end
end

function modifier_imba_borrowed_time_handler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_STATE_CHANGED
	}

	return funcs
end

function modifier_imba_borrowed_time_handler:OnTakeDamage(kv)
	if IsServer() then
		if self:GetParent() == kv.unit then
			self:_CheckHealth(kv.damage)
		end
	end
end

function modifier_imba_borrowed_time_handler:OnStateChanged(kv)
	if IsServer() then
		local target = self:GetParent()
		if target == kv.unit then
			self:_CheckHealth(0)
		end
	end
end

-----------------------------------------------------------------------------------------------

modifier_imba_borrowed_time_buff_hot_caster = class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return false end,
	IsDebuff	  			= function(self) return false end,
	GetEffectName			= function(self) return "particles/centaur/borrow.vpcf" end,
	GetEffectAttachType		= function(self) return PATTACH_ABSORIGIN_FOLLOW end,
	GetStatusEffectName		= function(self) return "particles/centaur/status_effect.vpcf" end,
	StatusEffectPriority	= function(self) return 15 end,
})

function modifier_imba_borrowed_time_buff_hot_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_imba_borrowed_time_buff_hot_caster:OnCreated()
	if IsServer() then
		local target = self:GetParent()
		self.target_current_health = target:GetHealth()
		target._borrowed_time_buffed_allies = {}
		target:EmitSound("Hero_Abaddon.BorrowedTime")
		target:Purge(false, true, false, true, false)
		
		local buff_duration = self:GetAbility():GetSpecialValueFor("duration")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_str9")
		if abil ~= nil then
			buff_duration = buff_duration + 3
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_str10")
		if abil ~= nil then
			if not caster:HasModifier("modifier_centaur_ult_hp") then
				self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_centaur_ult_hp",{  })
			end
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_agi10")
		if abil ~= nil then
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_stomp",{ duration = buff_duration })
		end	
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_centaur_agi_last")
		if abil ~= nil then
			self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ult_damage",{ duration = buff_duration })
		end	
	end
end

function modifier_imba_borrowed_time_buff_hot_caster:OnDestroy()
end

function modifier_imba_borrowed_time_buff_hot_caster:GetModifierIncomingDamage_Percentage(kv)
	if IsServer() then
		local target 	= self:GetParent()
		local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local target_vector = target:GetAbsOrigin()
		ParticleManager:SetParticleControl(heal_particle, 0, target_vector)
		ParticleManager:SetParticleControl(heal_particle, 1, target_vector)
		ParticleManager:ReleaseParticleIndex(heal_particle)

		if self.has_talent then
			local current_health = target:GetHealth()
			local max_health = target:GetMaxHealth()
			self:SetStackCount( self:GetStackCount() + math.floor(kv.damage / self.ratio) )
		end
		target:Heal(kv.damage, target)
		return -9999999
	end
end

-------------------------------------
modifier_ult_damage = class({})

function modifier_ult_damage:IsHidden()
	return false
end

function modifier_ult_damage:IsPurgable()
	return false
end

function modifier_ult_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_ult_damage:GetModifierBaseDamageOutgoing_Percentage()
	return 300
end