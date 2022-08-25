modifier_jakiro_dual_breath_lua_fire = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_dual_breath_lua_fire:IsHidden()
	return false
end

function modifier_jakiro_dual_breath_lua_fire:IsDebuff()
	return true
end

function modifier_jakiro_dual_breath_lua_fire:IsStunDebuff()
	return false
end

function modifier_jakiro_dual_breath_lua_fire:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_dual_breath_lua_fire:OnCreated( kv )
if IsServer() then
	local caster = self:GetCaster()
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	
		local abil = caster:FindAbilityByName("special_bonus_unique_jakiro_custom2")
		if abil ~= nil and abil:IsTrained()	then 
		bonus = abil:GetSpecialValueFor( "value" )
		damage = damage + bonus
		end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end
	-- Start interval
	self:StartIntervalThink( 0.5 )
	self:OnIntervalThink()
end

function modifier_jakiro_dual_breath_lua_fire:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	if not IsServer() then return end
	
	-- update damage
	self.damageTable.damage = damage
end

function modifier_jakiro_dual_breath_lua_fire:OnRemoved()
end

function modifier_jakiro_dual_breath_lua_fire:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_jakiro_dual_breath_lua_fire:OnIntervalThink()
if IsServer() then
	ApplyDamage( self.damageTable )
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jakiro_dual_breath_lua_fire:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_jakiro_dual_breath_lua_fire:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end