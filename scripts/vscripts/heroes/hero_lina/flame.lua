LinkLuaModifier("modifier_npc_dota_hero_lina_agi9", "heroes/hero_lina/flame", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_lina_flame", "heroes/hero_lina/flame", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_lina_agi9 = class({})

function npc_dota_hero_lina_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_lina_agi9"
end

if modifier_npc_dota_hero_lina_agi9 == nil then 
    modifier_npc_dota_hero_lina_agi9 = class({})
end

function modifier_npc_dota_hero_lina_agi9:DeclareFunctions()
	return {
      	MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_npc_dota_hero_lina_agi9:IsHidden()
	return false
end

function modifier_npc_dota_hero_lina_agi9:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_lina_agi9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_lina_agi9:OnAttackLanded( params )
if not IsServer() then return end
	if params.target==self:GetParent() then return end
	if params.attacker == self:GetCaster() then
		params.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_lina_flame", { duration = 2 } )
	end
end


---------------------------------------------------------------------------------

modifier_lina_flame = class({})


function modifier_lina_flame:IsHidden()
	return false
end

function modifier_lina_flame:IsDebuff()
	return true
end

function modifier_lina_flame:IsStunDebuff()
	return false
end

function modifier_lina_flame:IsPurgable()
	return true
end


function modifier_lina_flame:OnCreated( kv )
if IsServer() then
		local damage = self:GetCaster():GetAgility()/2
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
		self:StartIntervalThink( 0.5 )
		self:OnIntervalThink()
	end
end

function modifier_lina_flame:OnRefresh( kv )
end

function modifier_lina_flame:OnRemoved()
end

function modifier_lina_flame:OnDestroy()
end

function modifier_lina_flame:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_lina_flame:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_lina_flame:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
