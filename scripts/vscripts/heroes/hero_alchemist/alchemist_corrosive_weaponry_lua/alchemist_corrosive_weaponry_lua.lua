LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_lua", "heroes/hero_alchemist/alchemist_corrosive_weaponry_lua/alchemist_corrosive_weaponry_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_lua_debuff", "heroes/hero_alchemist/alchemist_corrosive_weaponry_lua/alchemist_corrosive_weaponry_lua", LUA_MODIFIER_MOTION_NONE )

alchemist_corrosive_weaponry_lua = class({})

function alchemist_corrosive_weaponry_lua:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end

function alchemist_corrosive_weaponry_lua:GetIntrinsicModifierName()
	return "modifier_alchemist_corrosive_weaponry_lua"
end

modifier_alchemist_corrosive_weaponry_lua = class({})
--Classifications template
function modifier_alchemist_corrosive_weaponry_lua:IsHidden()
	return true
end

function modifier_alchemist_corrosive_weaponry_lua:IsDebuff()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua:IsPurgable()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_alchemist_corrosive_weaponry_lua:IsStunDebuff()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua:RemoveOnDeath()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua:DestroyOnExpire()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua:OnCreated( kv )
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_alchemist_corrosive_weaponry_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_alchemist_corrosive_weaponry_lua:OnAttackLanded(data)
	if self:GetParent() == data.attacker and self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_alchemist_int50") then
        data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_corrosive_weaponry_lua_debuff", {duration = self.duration})
	end
end

modifier_alchemist_corrosive_weaponry_lua_debuff = class({})
--Classifications template
function modifier_alchemist_corrosive_weaponry_lua_debuff:IsHidden()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:IsDebuff()
	return true
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:IsPurgable()
	return true
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:IsPurgeException()
	return true
end

-- Optional Classifications
function modifier_alchemist_corrosive_weaponry_lua_debuff:IsStunDebuff()
	return false
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:RemoveOnDeath()
	return true
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:DestroyOnExpire()
	return true
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:OnCreated()
	
    self.interval = self:GetAbility():GetSpecialValueFor('interval')
    self.resistance = self:GetAbility():GetSpecialValueFor('resistance')
    self.damage_perc = self:GetAbility():GetSpecialValueFor('damage') / 100
    if not IsServer() then return end
	self:IncrementStackCount()
    self:StartIntervalThink(self.interval)
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:OnRefresh()
	if not IsServer() then
		return
	end
	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("max_stacks") then
		self:IncrementStackCount()
	end
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self:GetStackCount() * self:GetCaster():GetIntellect() * self.damage_perc * self.interval,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self:GetAbility()
    })
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_alchemist_corrosive_weaponry_lua_debuff:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * -self.resistance
end