modifier_modifier_medusa_stone_gaze_visual_lua = class({})

function modifier_modifier_medusa_stone_gaze_visual_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_modifier_medusa_stone_gaze_visual_lua:GetModifierMiss_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str8") ~= nil then 
    	return 20 -- Установите значение, насколько сильно враг будет промахиваться (в процентах)
	end
	return 0
end

function modifier_modifier_medusa_stone_gaze_visual_lua:GetModifierIncomingDamage_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_str8") ~= nil then 
    	return -10 -- Установите значение снижения урона (отрицательное число)
	end
	return 0
end

function modifier_modifier_medusa_stone_gaze_visual_lua:GetModifierBaseAttack_BonusDamage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_medusa_agi7") then
		return 100
	end
	return 0
end

function modifier_modifier_medusa_stone_gaze_visual_lua:OnCreated( kv )
	if not IsServer() then return end
	self.parent = self:GetParent()
	self.center_unit = self:GetAuraOwner()
	self.stone_angle = 85
	self.facing = false
	self.stoned = 0
	self:PlayEffects1()
	self:PlayEffects2()
	self:OnIntervalThink()
	self:StartIntervalThink( 0.03 )
end

function modifier_modifier_medusa_stone_gaze_visual_lua:OnIntervalThink()
	if not IsServer() then return end
	local vector = self.center_unit:GetOrigin()-self.parent:GetOrigin()
	local center_angle = VectorToAngles( vector ).y
	local facing_angle = VectorToAngles( self.parent:GetForwardVector() ).y
	local distance = vector:Length2D()
	local prev_facing = self.facing
	self.facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) < self.stone_angle )

	if self.facing~=prev_facing then
		self:ChangeEffects( self.facing )
	end

	if self:GetParent():HasModifier("modifier_medusa_stone_gaze_curse_lua") then
		self.stoned = 0
		return
	end

	if self.facing then
		self.stoned = self.stoned + 0.03
	else
		self.stoned = 0
	end


	if not self:GetParent():HasModifier("modifier_medusa_stone_gaze_curse_applied_once_lua") and self.stoned >= self:GetAbility():GetSpecialValueFor("first_transformation_delay") then
		self:GetParent():AddNewModifier(self:GetAuraOwner(), self:GetAbility(), "modifier_medusa_stone_gaze_curse_lua", {duration = self:GetAbility():GetSpecialValueFor("first_transformation_duration")})
    elseif self.stoned >= self:GetAbility():GetSpecialValueFor("subsequent_transformations_delay") then
        self:GetParent():AddNewModifier(self:GetAuraOwner(), self:GetAbility(), "modifier_medusa_stone_gaze_curse_lua", {duration = self:GetAbility():GetSpecialValueFor("subsequent_transformations_duration")})
    end
end

function modifier_modifier_medusa_stone_gaze_visual_lua:PlayEffects1()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self.center_unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false)
end

function modifier_modifier_medusa_stone_gaze_visual_lua:PlayEffects2()
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( self.effect_cast, false, false, -1, false, false  )
end

function modifier_modifier_medusa_stone_gaze_visual_lua:ChangeEffects( IsNowFacing )
	local target = self.parent

	if IsNowFacing then
		target = self.center_unit
		EmitSoundOnClient( "Hero_Medusa.StoneGaze.Target", self:GetParent():GetPlayerOwner() )
	end

	ParticleManager:SetParticleControlEnt( self.effect_cast, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
end