LinkLuaModifier( "modifier_npc_dota_hero_alchemist_agi8", "heroes/hero_alchemist/poison_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_npc_dota_hero_alchemist_agi8_debuff", "heroes/hero_alchemist/poison_attack", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_alchemist_agi8 = class({})

function npc_dota_hero_alchemist_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_alchemist_agi8"
end

-------------------------------------------
modifier_npc_dota_hero_alchemist_agi8 = class({})
function modifier_npc_dota_hero_alchemist_agi8:IsDebuff() return false end
function modifier_npc_dota_hero_alchemist_agi8:IsHidden() return true end
function modifier_npc_dota_hero_alchemist_agi8:IsPurgable() return false end
function modifier_npc_dota_hero_alchemist_agi8:IsPurgeException() return false end
function modifier_npc_dota_hero_alchemist_agi8:IsStunDebuff() return false end
function modifier_npc_dota_hero_alchemist_agi8:RemoveOnDeath() return false end

function modifier_npc_dota_hero_alchemist_agi8:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_npc_dota_hero_alchemist_agi8:OnAttackLanded( params )
	if IsServer() then
		local abil = self:GetCaster():FindAbilityByName("alchemist_acid_spray_lua")
		if abil ~= nil then 
			if (self:GetCaster() == params.attacker) and not params.target:IsBuilding() and not params.target:IsMagicImmune() then
				params.target:AddNewModifier(self:GetCaster(), abil, "modifier_npc_dota_hero_alchemist_agi8_debuff", {duration = 2})
			end
		end
	end
end

-------------------------------------------

modifier_npc_dota_hero_alchemist_agi8_debuff = class({})
function modifier_npc_dota_hero_alchemist_agi8_debuff:IsDebuff() return true end
function modifier_npc_dota_hero_alchemist_agi8_debuff:IsHidden() return false end
function modifier_npc_dota_hero_alchemist_agi8_debuff:IsStunDebuff() return false end
function modifier_npc_dota_hero_alchemist_agi8_debuff:RemoveOnDeath() return true end
function modifier_npc_dota_hero_alchemist_agi8_debuff:IgnoreTenacity()	return true end

function modifier_npc_dota_hero_alchemist_agi8_debuff:GetEffectName()
	return "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf"
end

function modifier_npc_dota_hero_alchemist_agi8_debuff:OnCreated(params)
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_int8")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetIntellect()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi7")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetAgility()
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str7")	
	if abil ~= nil then 
		self.damage = self:GetCaster():GetStrength()
	end
	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
	self:StartIntervalThink(1)
end

function modifier_npc_dota_hero_alchemist_agi8_debuff:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION ,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	SendOverheadEventMessage(self:GetCaster(), OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage, nil)
end