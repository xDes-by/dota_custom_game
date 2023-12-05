item_pudge_heart_lua = class({})

LinkLuaModifier("modifier_item_pudge_heart_passive", 'items/custom_items/item_pudge_heart.lua', LUA_MODIFIER_MOTION_NONE)

function item_pudge_heart_lua:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "all/pudge" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/item_pudge_heart_lua" .. level
	end
end

function item_pudge_heart_lua:GetIntrinsicModifierName()
	if (self:GetItemSlot() > 5 or self:GetItemSlot() == -1) then
		return
	end
	return "modifier_item_pudge_heart_passive"
end

function item_pudge_heart_lua:OnSpellStart()
if not IsServer() then return end

	local radius = self:GetSpecialValueFor("radius")
	
	EmitSoundOn( "Hero_Pudge.Eject", self:GetCaster() )
	
	self.damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_HPLOSS,
		ability = self
	}
	
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetCaster():GetOrigin())
	ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(400, 0, 0))
	ParticleManager:ReleaseParticleIndex(particle_blast_fx)
	
	self.damageTable.victim = self:GetCaster()
	self.damageTable.damage = self:GetCaster():GetMaxHealth()/2
	ApplyDamage( self.damageTable )
	
	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = self:GetCaster():GetStrength()
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage( self.damageTable )
	end
end


-----------------------------------------------------------------------------------------------

modifier_item_pudge_heart_passive = class({})

function modifier_item_pudge_heart_passive:IsHidden()
	return true
end

function modifier_item_pudge_heart_passive:IsPurgable()
	return false
end

function modifier_item_pudge_heart_passive:DestroyOnExpire()
	return false
end

function modifier_item_pudge_heart_passive:OnCreated()
	self.parent = self:GetParent()
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_pudge_heart_passive:OnRefresh()
    self.bonus_str = self:GetAbility():GetSpecialValueFor("bonus_str")
end

function modifier_item_pudge_heart_passive:GetAttributes() 
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_item_pudge_heart_passive:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,        
		MODIFIER_ATTRIBUTE_NONE
	}
	return funcs
end

function modifier_item_pudge_heart_passive:GetModifierBonusStats_Strength( params )
	return self.bonus_str
end