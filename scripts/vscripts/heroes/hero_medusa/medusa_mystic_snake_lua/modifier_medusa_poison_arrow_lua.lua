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
	self.damage = self:GetAbility():GetSpecialValueFor( "snake_poison_damage" )
	self:StartIntervalThink( 0.5 )
end

function modifier_medusa_poison_arrow_lua:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "snake_poison_damage" )
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