alchemist_chemical_rage_lua = class({})
LinkLuaModifier( "modifier_alchemist_chemical_rage_lua", "heroes/hero_alchemist/alchemist_chemical_rage_lua/alchemist_chemical_rage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_bkb", "heroes/hero_alchemist/alchemist_chemical_rage_lua/alchemist_chemical_rage_lua", LUA_MODIFIER_MOTION_NONE )

function alchemist_chemical_rage_lua:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect()*3)
    end
end


function alchemist_chemical_rage_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "duration" )

	caster:AddNewModifier( caster, self, "modifier_alchemist_chemical_rage_lua", { duration = duration } )

	local sound_cast = "Hero_Alchemist.ChemicalRage.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str6")	
	if abil ~= nil then 
		caster:AddNewModifier( caster, self, "modifier_alchemist_bkb", { duration = 5 } )
	end
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------
modifier_alchemist_bkb = class({})

function modifier_alchemist_bkb:IsHidden() return false end
function modifier_alchemist_bkb:IsPurgable() return false end
function modifier_alchemist_bkb:IsDebuff() return false end

function modifier_alchemist_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_alchemist_bkb:OnCreated()
end

function modifier_alchemist_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alchemist_bkb:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}
    return state
end

function modifier_alchemist_bkb:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_alchemist_bkb:GetModifierModelScale()
    return 30
end

--------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

modifier_alchemist_chemical_rage_lua = class({})

function modifier_alchemist_chemical_rage_lua:IsHidden()
	return false
end

function modifier_alchemist_chemical_rage_lua:IsDebuff()
	return false
end

function modifier_alchemist_chemical_rage_lua:IsStunDebuff()
	return false
end

function modifier_alchemist_chemical_rage_lua:IsPurgable()
	return false
end

function modifier_alchemist_chemical_rage_lua:AllowIllusionDuplicate()
	return true
end

function modifier_alchemist_chemical_rage_lua:OnCreated( kv )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )

	if not IsServer() then return end

	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )
end

function modifier_alchemist_chemical_rage_lua:OnRefresh( kv )
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )

	if not IsServer() then return end

	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )
end

function modifier_alchemist_chemical_rage_lua:OnRemoved()
end

function modifier_alchemist_chemical_rage_lua:OnDestroy()
	if not IsServer() then return end

	local sound_cast = "Hero_Alchemist.ChemicalRage"
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_alchemist_chemical_rage_lua:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}

	return funcs
end

function modifier_alchemist_chemical_rage_lua:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi11")
		if abil ~= nil and params.attacker==self:GetParent() then 
			self:AddStack()
		end
	end
end

function modifier_alchemist_chemical_rage_lua:AddStack()
	self.count = 3
	if self:GetStackCount() < self.count and (self.record == false or self.record == nil) then
		self:SetStackCount(self:GetStackCount() + 1)
	end
		
	if self:GetStackCount() >= self.count then
		self.record = true
	end
end

function modifier_alchemist_chemical_rage_lua:GetModifierPreAttack_CriticalStrike( params )
	if params.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
	if self.record == true then
		self:ResetStack()
		return 200
	end
end

function modifier_alchemist_chemical_rage_lua:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self.record = false
		self:SetStackCount(0)
	end
end


---------------------------------------------------------------------------------------


function modifier_alchemist_chemical_rage_lua:GetModifierPreAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_agi10") ~= nil then 
		return self:GetCaster():GetAgility()
	end
	return 0
end

function modifier_alchemist_chemical_rage_lua:GetModifierTotalPercentageManaRegen()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str10") ~= nil then 
		return 1.5
	end
	return 0
end


function modifier_alchemist_chemical_rage_lua:GetModifierHealthRegenPercentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str10") ~= nil then 
		return 3
	end
	return 0
end


function modifier_alchemist_chemical_rage_lua:GetModifierPhysicalArmorBonus()
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_alchemist_str9")	
	if abil ~= nil then 
		return self:GetCaster():GetLevel()
	end
	return 0
end

function modifier_alchemist_chemical_rage_lua:GetActivityTranslationModifiers()
	return "chemical_rage"
end

function modifier_alchemist_chemical_rage_lua:GetModifierBaseAttackTimeConstant()
	return 1
end

function modifier_alchemist_chemical_rage_lua:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_alchemist_chemical_rage_lua:GetModifierConstantManaRegen()
	return self.mana_regen
end

function modifier_alchemist_chemical_rage_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end

function modifier_alchemist_chemical_rage_lua:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
end

function modifier_alchemist_chemical_rage_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_alchemist_chemical_rage_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_chemical_rage.vpcf"
end

function modifier_alchemist_chemical_rage_lua:StatusEffectPriority()
	return 10
end

function modifier_alchemist_chemical_rage_lua:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_alchemist_chemical_rage_lua:HeroEffectPriority()
	return 10
end