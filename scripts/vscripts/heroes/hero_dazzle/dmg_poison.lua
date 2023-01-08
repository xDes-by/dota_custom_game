LinkLuaModifier("modifier_npc_dota_hero_dazzle_agi9", "heroes/hero_dazzle/dmg_poison", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_dazzle_poison", "heroes/hero_dazzle/dmg_poison", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_dazzle_agi9 = class({})

function npc_dota_hero_dazzle_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_dazzle_agi9"
end

if modifier_npc_dota_hero_dazzle_agi9 == nil then 
    modifier_npc_dota_hero_dazzle_agi9 = class({})
end

function modifier_npc_dota_hero_dazzle_agi9:DeclareFunctions()
	return {
      	MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_npc_dota_hero_dazzle_agi9:IsHidden()
	return false
end

function modifier_npc_dota_hero_dazzle_agi9:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_dazzle_agi9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_dazzle_agi9:OnAttackLanded( params )
	if not IsServer() then return end
	if params.target == self:GetParent() then return end
	if self:GetParent() == params.attacker then
		params.target:AddNewModifier( self:GetCaster(), self, "modifier_dazzle_poison", { duration = 2 })
	end	
end


---------------------------------------------------------------------------------

modifier_dazzle_poison = class({})

function modifier_dazzle_poison:IsHidden()
	return false
end

function modifier_dazzle_poison:IsDebuff()
	return true
end

function modifier_dazzle_poison:IsStunDebuff()
	return false
end

function modifier_dazzle_poison:IsPurgable()
	return true
end

function modifier_dazzle_poison:OnCreated( kv )
	if IsServer() then
		self.caster = self:GetCaster()
		local abil = self:GetCaster():FindAbilityByName("dazzle_poison_touch_lua")
		if abil ~= nil and abil:GetLevel() > 0 then
			local damage = abil:GetSpecialValueFor( "damage" )

			damage_type = DAMAGE_TYPE_PHYSICAL
			
			self.damageTable = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = damage,
				damage_type = damage_type,
				ability = self, --Optional.
			}

			self:StartIntervalThink(1)
			self:OnIntervalThink()
		end
	end
end

function modifier_dazzle_poison:OnIntervalThink()
	ApplyDamage( self.damageTable )
	EmitSoundOn( "Hero_Dazzle.Poison_Tick", self:GetParent() )
end

function modifier_dazzle_poison:GetEffectName()
	return "particles/units/heroes/hero_dazzle/dazzle_poison_debuff.vpcf"
end

function modifier_dazzle_poison:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_dazzle_poison:GetStatusEffectName()
	return "particles/status_fx/status_effect_poison_dazzle_copy.vpcf"
end