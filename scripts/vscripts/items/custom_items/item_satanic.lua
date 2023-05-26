LinkLuaModifier("modifier_satanic_lua", "items/custom_items/item_satanic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satanic_lua_active", "items/custom_items/item_satanic", LUA_MODIFIER_MOTION_NONE)

item_satanic_lua1 = item_satanic_lua1 or class({})
item_satanic_lua2 = item_satanic_lua1 or class({})
item_satanic_lua3 = item_satanic_lua1 or class({})
item_satanic_lua4 = item_satanic_lua1 or class({})
item_satanic_lua5 = item_satanic_lua1 or class({})
item_satanic_lua6 = item_satanic_lua1 or class({})
item_satanic_lua7 = item_satanic_lua1 or class({})
item_satanic_lua8 = item_satanic_lua1 or class({})

function item_satanic_lua1:GetIntrinsicModifierName()
	return "modifier_satanic_lua"
end

function item_satanic_lua1:OnSpellStart()
	EmitSoundOn("DOTA_Item.Satanic.Activate", self:GetCaster())
	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_satanic_lua_active", {duration = self:GetSpecialValueFor("duration")})
end

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

modifier_satanic_lua = class({})

function modifier_satanic_lua:IsHidden() return true end
function modifier_satanic_lua:IsPurgable() return false end
function modifier_satanic_lua:RemoveOnDeath() return false end
function modifier_satanic_lua:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_satanic_lua:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_pct")
end

function modifier_satanic_lua:OnDestroy()
end

function modifier_satanic_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_satanic_lua:GetModifierPreAttack_BonusDamage()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("damage_bonus")
	end
end

function modifier_satanic_lua:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("strength_bonus")
	end
end

------------------------------------------------------------------------------------------------------

modifier_satanic_lua_active = modifier_satanic_lua_active or class({})

function modifier_satanic_lua_active:GetEffectName()
	return "particles/items2_fx/satanic_buff.vpcf"
end

function modifier_satanic_lua_active:OnCreated()
self.lifesteal_aura = self:GetAbility():GetSpecialValueFor("lifesteal_bonus")
end

function modifier_satanic_lua_active:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

function modifier_satanic_lua_active:OnAttackLanded( params )
	if IsServer() then
	local attacker = self:GetParent()	
	if attacker ~= params.attacker then
		return
	end
		local heal = params.damage * self.lifesteal_aura/100
		self:GetParent():Heal( heal, self:GetAbility() )
		self:PlayEffects( self:GetParent() )
	end
end

function modifier_satanic_lua_active:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end