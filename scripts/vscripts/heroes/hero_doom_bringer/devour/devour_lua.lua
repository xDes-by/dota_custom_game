doom_devour_lua = {}

LinkLuaModifier( "modifier_ability_devour", 'heroes/hero_doom_bringer/devour/devour_lua.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_ability_devour_souls", 'heroes/hero_doom_bringer/devour/devour_lua.lua', LUA_MODIFIER_MOTION_NONE)

modifier_ability_devour_souls = {}

function doom_devour_lua:CastFilterResultTarget( hTarget )
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end
	return UF_SUCCESS
end

function doom_devour_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("devour_time")
	
	caster:AddNewModifier(caster, self, "modifier_ability_devour", { duration = duration })

	if caster:HasModifier("modifier_ability_devour_souls") then
		local stacks = self:GetCaster():GetModifierStackCount("modifier_ability_devour_souls", self:GetCaster())
		caster:SetModifierStackCount("modifier_ability_devour_souls", self:GetCaster(), (stacks + 1))
	else
		caster:AddNewModifier(self:GetCaster(), self, "modifier_ability_devour_souls", nil)
		caster:SetModifierStackCount("modifier_ability_devour_souls", self:GetCaster(), 1)	
	end	

	target:AddNoDraw()

	target:Kill(self, caster)

	local particleName = "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf"
	caster.ManaDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.ManaDrainParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster.ManaDrainParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)

	EmitSoundOn( "Hero_DoomBringer.Devour", self:GetCaster() )
	EmitSoundOn( "Hero_DoomBringer.DevourCast", target )
end

--------------------------------

modifier_ability_devour = {}

function modifier_ability_devour:IsHidden()
	return false
end

function modifier_ability_devour:IsDebuff()
	return false
end

function modifier_ability_devour:IsPurgable()
	return false
end

function modifier_ability_devour:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ability_devour:RemoveOnDeath()
	return false
end

function modifier_ability_devour:OnCreated( kv )
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	self.bonus_regen = self:GetAbility():GetSpecialValueFor( "regen" )
end

function modifier_ability_devour:OnDestroy()
	if IsServer() then
		local player = PlayerResource:GetSelectedHeroEntity(self:GetParent():GetPlayerOwnerID() )
        PlayerResource:ModifyGoldFiltered( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
		SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, self:GetParent(), self.bonus_gold, nil)
    end
end

function modifier_ability_devour:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
end

function modifier_ability_devour:GetModifierConstantHealthRegen()
	return self.bonus_regen
end

-----------------------------------

modifier_ability_devour_souls = {}

function modifier_ability_devour_souls:GetTexture()
	return "soul"
end

function modifier_ability_devour_souls:IsHidden()
	return false
end

function modifier_ability_devour_souls:IsDebuff()
	return false
end

function modifier_ability_devour_souls:IsPurgable()
	return false
end

function modifier_ability_devour_souls:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
    }
end

function modifier_ability_devour_souls:GetModifierPreAttack_BonusDamage()
    return self:GetCaster():GetModifierStackCount("modifier_ability_devour_souls", self:GetCaster()) *  self:GetAbility():GetSpecialValueFor( "devour_damage" )
end