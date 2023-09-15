LinkLuaModifier( "modifier_meat_hook_lua", "heroes/hero_pudge/hook/hook_spell.lua" ,LUA_MODIFIER_MOTION_HORIZONTAL )

pudge_meat_hook_lua = class({})

function pudge_meat_hook_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function pudge_meat_hook_lua:OnSpellStart()
	target = self:GetCursorTarget()

	EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )
	EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster() )
	
	
	self.pfx = ParticleManager:CreateParticle("particles/econ/items/pudge/pudge_arcana/pudge_arcana_dismember_default.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(self.pfx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.pfx, 8, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(self.pfx, 15, Vector(253, 144, 63))

	if not target:TriggerSpellAbsorb(self) then
		target:AddNewModifier(self:GetCaster(), self, "modifier_meat_hook_lua", {duration = self:GetSpecialValueFor( "duration" )})
	end
end

-----------------------------------------------------------------------------------------------------------------

modifier_meat_hook_lua = class({})

function modifier_meat_hook_lua:IsHidden()
	return false
end

function modifier_meat_hook_lua:IsPurgable()
	return false
end

function modifier_meat_hook_lua:OnDestroy( kv )
	if self:GetAbility().pfx then
		ParticleManager:DestroyParticle(self:GetAbility().pfx, false)
		ParticleManager:ReleaseParticleIndex(self:GetAbility().pfx)
	end
end	

function modifier_meat_hook_lua:OnCreated( kv )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_agi10") ~= nil then
		damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():GetBaseDamageMin()
	end
	
	self.damage_type = DAMAGE_TYPE_PURE
	self.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pudge_int11") ~= nil then
		self.damage_type = DAMAGE_TYPE_MAGICAL
		self.damage_flags = DOTA_DAMAGE_FLAG_NONE
	end

	if not IsServer() then return end
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage/2,
		damage_type = self.damage_type,
		damage_flags = self.damage_flags,
	}
	self:StartIntervalThink(0.5)
end

function modifier_meat_hook_lua:OnIntervalThink()
EmitSoundOn( "Hero_Pudge.Dismember", self:GetCaster() )
	ApplyDamage( self.damageTable )
end

function modifier_meat_hook_lua:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true,}
	return state
end

function modifier_meat_hook_lua:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_meat_hook_lua:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end