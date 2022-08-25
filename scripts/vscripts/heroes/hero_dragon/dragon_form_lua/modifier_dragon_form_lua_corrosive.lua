
modifier_dragon_form_lua_corrosive = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_dragon_form_lua_corrosive:IsHidden()
	return false
end

function modifier_dragon_form_lua_corrosive:IsDebuff()
	return true
end

function modifier_dragon_form_lua_corrosive:IsStunDebuff()
	return false
end

function modifier_dragon_form_lua_corrosive:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_dragon_form_lua_corrosive:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "corrosive_breath_damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int9") 
	if abil ~= nil then
	damage = self:GetCaster():GetIntellect()
	end
	
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}

	if not IsServer() then return end
	self:StartIntervalThink( 1 )
end

function modifier_dragon_form_lua_corrosive:OnRefresh( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "corrosive_breath_damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int9") 
	if abil ~= nil then
	damage = self:GetCaster():GetIntellect()
	end


	self.damageTable.damage = damage
end

function modifier_dragon_form_lua_corrosive:OnRemoved()
end

function modifier_dragon_form_lua_corrosive:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dragon_form_lua_corrosive:OnIntervalThink()
	ApplyDamage(self.damageTable)
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dragon_form_lua_corrosive:GetEffectName()
	return "particles/units/heroes/hero_dragon_knight/dragon_knight_corrosion_debuff.vpcf"
end

function modifier_dragon_form_lua_corrosive:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end