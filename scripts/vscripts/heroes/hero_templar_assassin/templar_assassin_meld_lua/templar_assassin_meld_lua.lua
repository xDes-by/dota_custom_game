LinkLuaModifier("modifier_templar_assassin_meld_lua", "heroes/hero_templar_assassin/templar_assassin_meld_lua/templar_assassin_meld_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_meld_lua_debuff", "heroes/hero_templar_assassin/templar_assassin_meld_lua/templar_assassin_meld_lua", LUA_MODIFIER_MOTION_NONE)

templar_assassin_meld_lua = class({})

function templar_assassin_meld_lua:GetIntrinsicModifierName()
	return "modifier_templar_assassin_meld_lua"
end

-----------------------------------------------------------------------------------
modifier_templar_assassin_meld_lua = class({})

function modifier_templar_assassin_meld_lua:IsHidden()
	return true
end

function modifier_templar_assassin_meld_lua:IsPurgable()
	return false
end

function modifier_templar_assassin_meld_lua:IsPurgeException()
	return false
end

function modifier_templar_assassin_meld_lua:RemoveOnDeath()
	return false
end

function modifier_templar_assassin_meld_lua:OnCreated()
	self:StartIntervalThink(0.1)
end


function modifier_templar_assassin_meld_lua:OnIntervalThink()
	if not IsServer() then return end
	if self:GetAbility():IsFullyCastable() then
		self:GetAbility().meld_record = true
	end	
end

function modifier_templar_assassin_meld_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_FAIL,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_templar_assassin_meld_lua:OnAttack(keys)
	if self:GetAbility().meld_record and keys.attacker == self:GetParent() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown and keys.target:GetUnitName() ~= "npc_dota_observer_wards" and keys.target:GetUnitName() ~= "npc_dota_sentry_wards" then
		self:SetStackCount(2)
		self:GetAbility():UseResources( false,true, true, true )
	end
end

function modifier_templar_assassin_meld_lua:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		if self:GetAbility().meld_record then
			if self:GetStackCount() == 2 then 
				keys.target:EmitSound("Hero_TemplarAssassin.Meld.Attack")
				self:GetAbility():ApplyMeld(keys.target, self:GetParent())
				keys.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_meld_lua_debuff", {duration = 3})
				self:GetAbility().meld_record = false
				self:SetStackCount(1)
			end
		end
	end
end

function modifier_templar_assassin_meld_lua:GetModifierProjectileName()
	if self:GetAbility().meld_record then
		return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_attack.vpcf"
	end
end

function templar_assassin_meld_lua:ApplyMeld(target, attacker)
	ApplyDamage({
		victim 			= target,
		damage 			= self:GetSpecialValueFor("bonus_damage"),
		damage_type		= DAMAGE_TYPE_PHYSICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= attacker,
		ability 		= self
	})

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, self:GetSpecialValueFor("bonus_damage"), nil)
end

----------------------------------------------------------
modifier_templar_assassin_meld_lua_debuff  = class({}) 

function modifier_templar_assassin_meld_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf"
end

function modifier_templar_assassin_meld_lua_debuff:OnCreated()
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_templar_assassin_tal1")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.bonus_armor = self.bonus_armor - 6
	end

	if not IsServer() then return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_meld_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, false, true)
end

function modifier_templar_assassin_meld_lua_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_templar_assassin_meld_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end