medusa_poison_arrow_lua = class({})
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_poison_arrow_lua", "heroes/hero_medusa/medusa_poison_arrow_lua/medusa_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_magic_resist", "heroes/hero_medusa/medusa_poison_arrow_lua/medusa_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_medusa_poison_arrow_orb", "heroes/hero_medusa/medusa_poison_arrow_lua/medusa_poison_arrow_lua", LUA_MODIFIER_MOTION_NONE )

function medusa_poison_arrow_lua:GetIntrinsicModifierName()
	return "modifier_medusa_poison_arrow_orb"
end

function medusa_poison_arrow_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_medusa_int50") ~= nil then
		return 0
	end
	return 40 + math.min(65000, self:GetCaster():GetIntellect()/200)
end

function medusa_poison_arrow_lua:GetProjectileName()
	return "particles/medusa_arrow.vpcf"
end

function medusa_poison_arrow_lua:OnOrbFire( params )
end

function medusa_poison_arrow_lua:OnOrbImpact( params )
	local duration = self:GetSpecialValueFor("duration")

	params.target:AddNewModifier(self:GetCaster(), self, "modifier_medusa_poison_arrow_lua", { duration = duration })
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int7")
	if abil ~= nil then 
		params.target:AddNewModifier(self:GetCaster(), self, "modifier_medusa_magic_resist", { duration = duration })
	end
end

----------------------------------------------------------------------
----------------------------------------------------------------------

modifier_medusa_poison_arrow_orb = class({})

function modifier_medusa_poison_arrow_orb:IsHidden()
	return true
end

function modifier_medusa_poison_arrow_orb:IsDebuff()
	return false
end

function modifier_medusa_poison_arrow_orb:IsPurgable()
	return false
end

function modifier_medusa_poison_arrow_orb:OnCreated( kv )
	if not IsServer() then return end

	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_orb_effect_lua", -- modifier name
		{  } -- kv
	)
end

----------------------------------------------------------------------
----------------------------------------------------------------------

modifier_medusa_poison_arrow_lua = class({})

function modifier_medusa_poison_arrow_lua:IsHidden()
	return false
end

function modifier_medusa_poison_arrow_lua:IsDebuff()
	return true
end

function modifier_medusa_poison_arrow_lua:IsStunDebuff()
	return false
end

function modifier_medusa_poison_arrow_lua:IsPurgable()
	return true
end

function modifier_medusa_poison_arrow_lua:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self:StartIntervalThink( 0.5 )
end

function modifier_medusa_poison_arrow_lua:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_medusa_poison_arrow_lua:OnRemoved()
end

function modifier_medusa_poison_arrow_lua:OnDestroy()
end

function modifier_medusa_poison_arrow_lua:OnIntervalThink()

damage = self.damage / 2

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int8")
	if abil ~= nil then 
	damage = self:GetCaster():GetIntellect()/2
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_int_last")
	if abil ~= nil then 
	damage = damage * 2
	end
	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	
	ApplyDamage( self.damageTable )
end

function modifier_medusa_poison_arrow_lua:GetEffectName()
	return "particles/units/heroes/hero_viper/viper_poison_debuff.vpcf"
end

function modifier_medusa_poison_arrow_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------

if modifier_medusa_magic_resist == nil then modifier_medusa_magic_resist = class({}) end
function modifier_medusa_magic_resist:IsHidden() return true end
function modifier_medusa_magic_resist:IsDebuff() return true end
function modifier_medusa_magic_resist:IsPurgable() return true end


function modifier_medusa_magic_resist:OnCreated()
end

function modifier_medusa_magic_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_medusa_magic_resist:GetModifierMagicalResistanceBonus()
	return -15
end