-- modifier_liquid_ice_lua = class({})

-- function modifier_liquid_ice_lua:IsDebuff()			return true end
-- function modifier_liquid_ice_lua:IsHidden() 			return false end
-- function modifier_liquid_ice_lua:IsPurgable() 		return true end
-- function modifier_liquid_ice_lua:IsPurgeException() 	return true end

-- function modifier_liquid_ice_lua:GetEffectName() return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf" end
-- function modifier_liquid_ice_lua:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

-- function modifier_liquid_ice_lua:OnCreated()
-- 	if IsServer() then
-- 		self:StartIntervalThink(1.0)
-- 	end
-- end

-- function modifier_liquid_ice_lua:OnIntervalThink()
-- 	local dmg = self:GetCaster():GetIntellect() * (self:GetAbility():GetSpecialValueFor("int_damage") / 100)
-- 	local damageTable = {
-- 						victim = self:GetParent(),
-- 						attacker = self:GetCaster(),
-- 						damage = dmg,
-- 						damage_type = self:GetAbility():GetAbilityDamageType(),
-- 						ability = self:GetAbility(), --Optional.
-- 						}
-- 	ApplyDamage(damageTable)
-- end

-- function modifier_liquid_ice_lua:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end

-- function modifier_liquid_ice_lua:GetModifierMoveSpeedBonus_Constant()
-- 	if self:GetCaster() then
-- 		return -1*self:GetAbility():GetSpecialValueFor("movement_slow")  
-- 	end
-- end

-- modifier_liquid_ice_lua_orb = class({})

-- function modifier_liquid_ice_lua_orb:IsDebuff()			return false end
-- function modifier_liquid_ice_lua_orb:IsHidden() 			return true end
-- function modifier_liquid_ice_lua_orb:IsPurgable() 		return false end
-- function modifier_liquid_ice_lua_orb:IsPurgeException() 	return false end

-- function modifier_liquid_ice_lua_orb:OnCreated()
-- 	if IsServer() then
-- 	end
-- end

-- function modifier_liquid_ice_lua_orb:DeclareFunctions()
--     return {
--         MODIFIER_EVENT_ON_ATTACK,
--         MODIFIER_EVENT_ON_ATTACK_LANDED,
--     }
-- end

-- function modifier_liquid_ice_lua_orb:OnAttack(keys)
-- 	if not IsServer() then
-- 		return 
-- 	end
-- 	if keys.attacker ~= self:GetParent() then
-- 		return
-- 	end
--     if self:GetParent():IsSilenced() or self:GetParent():IsIllusion() or not self:GetAbility():IsCooldownReady() or not self:GetAbility():GetAutoCastState() then
--         return
--     end
-- 	self:SetStackCount(1)
-- 	self:GetParent():StartGesture(ACT_DOTA_ATTACK2)
-- 	self:GetAbility():UseResources(true, false, true, true)
-- end

-- function modifier_liquid_ice_lua_orb:OnAttackLanded(keys)
-- 	if not IsServer() then
-- 		return 
-- 	end
-- 	if keys.attacker ~= self:GetParent() then
-- 		return
-- 	end
--     if self:GetParent():IsIllusion() then return end
-- 	if self:GetStackCount() ~= 1 then
-- 		return
-- 	end
-- 	self:SetStackCount(0)
-- 	self:GetAbility():OnProjectileHit(keys.target, keys.target:GetAbsOrigin())
-- end

modifier_jakiro_liquid_ice_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_liquid_ice_lua:IsHidden()
	return false
end

function modifier_jakiro_liquid_ice_lua:IsDebuff()
	return true
end

function modifier_jakiro_liquid_ice_lua:IsStunDebuff()
	return false
end

function modifier_jakiro_liquid_ice_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_liquid_ice_lua:OnCreated( kv )
	-- references
	local damage = self:GetCaster():GetIntellect() * (self:GetAbility():GetSpecialValueFor("int_damage") / 100)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str13") then
		damage = damage + self:GetCaster():GetMaxHealth() * (self:GetAbility():GetSpecialValueFor("max_hp_damage") / 100)
	end
	self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_jakiro_liquid_ice_lua:OnRefresh( kv )
end

function modifier_jakiro_liquid_ice_lua:OnRemoved()
end

function modifier_jakiro_liquid_ice_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jakiro_liquid_ice_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_jakiro_liquid_ice_lua:GetModifierAttackSpeedBonus_Constant()
	return self.slow
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_jakiro_liquid_ice_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jakiro_liquid_ice_lua:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_ready.vpcf"
end

function modifier_jakiro_liquid_ice_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end