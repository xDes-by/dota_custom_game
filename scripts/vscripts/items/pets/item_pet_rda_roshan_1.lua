LinkLuaModifier( "modifier_pet_rda_secret_1", "items/pets/item_pet_rda_roshan_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_rda_roshan_1", "items/pets/item_pet_rda_roshan_1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_take_drop_gem", "modifiers/modifier_take_drop_gem", LUA_MODIFIER_MOTION_NONE )

spell_item_pet_rda_roshan_1 = class({})

function spell_item_pet_rda_roshan_1:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_pet_rda_secret_1", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_rda_roshan_1:GetIntrinsicModifierName()
	return "modifier_item_pet_rda_roshan_1"
end

modifier_item_pet_rda_roshan_1 = class({})

function modifier_item_pet_rda_roshan_1:IsHidden()
	return true
end

function modifier_item_pet_rda_roshan_1:IsPurgable()
	return false
end

function modifier_item_pet_rda_roshan_1:OnCreated( kv )
	if IsServer() then
		local point = self:GetCaster():GetAbsOrigin()
		if not self:GetCaster():IsIllusion() then
			self.pet = CreateUnitByName("pet_rda_roshan_1", point + Vector(500,500,500), true, nil, nil, DOTA_TEAM_GOODGUYS)
			self.pet:AddNewModifier(self:GetParent(),nil,"modifier_take_drop_gem",{})
			self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
			self.pet:SetOwner(self:GetCaster())
			self:StartIntervalThink(1)
		end
	end
end

function modifier_item_pet_rda_roshan_1:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local ability = self:GetAbility()
		local gold = ability:GetSpecialValueFor("gold")
		parent:ModifyGoldFiltered(gold, true, 0)
	end
end

function modifier_item_pet_rda_roshan_1:OnDestroy()
	UTIL_Remove(self.pet)
end

function modifier_item_pet_rda_roshan_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		MODIFIER_PROPERTY_GOLD_RATE_BOOST 
	}
end

function modifier_item_pet_rda_roshan_1:GetModifierBaseAttack_BonusDamage( params )
	return self:GetAbility():GetSpecialValueFor( "dmg" ) * self:GetCaster():GetLevel()
end

function modifier_item_pet_rda_roshan_1:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_health") * self:GetCaster():GetLevel()
end

function modifier_item_pet_rda_roshan_1:GetModifierIncomingDamage_Percentage()
	return - self:GetAbility():GetSpecialValueFor( "block" )
end

function modifier_item_pet_rda_roshan_1:OnAttackLanded(keys)
    if not (
        IsServer()
        and self:GetParent() == keys.attacker
        and keys.attacker:GetTeam() ~= keys.target:GetTeam()
        and not keys.attacker:IsRangedAttacker()
    ) then return end
    
    local ability = self:GetAbility()
    local damage = keys.original_damage
    local damageMod = ability:GetSpecialValueFor( "cleave_amount" )
    local radius = ability:GetSpecialValueFor( "cleave_radius" )
    local particle_cast = 'particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf'
    
    damageMod = damageMod * 0.01
    damage = damage * damageMod
	
	local direction = keys.target:GetOrigin()-self:GetParent():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local range = self:GetParent():GetOrigin() + direction*radius/2
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_pet_rda_roshan_1:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_item_pet_rda_roshan_1:GetModifierPercentageGoldRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end

function modifier_item_pet_rda_roshan_1:GetModifierPercentageExpRateBoost()
	return self:GetAbility():GetSpecialValueFor("goex")
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_pet_rda_secret_1 = class({})

function modifier_pet_rda_secret_1:IsHidden()
	return true
end

function modifier_pet_rda_secret_1:IsDebuff()
	return false
end

function modifier_pet_rda_secret_1:IsPurgable()
	return false
end

function modifier_pet_rda_secret_1:OnCreated( kv ) 
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_pet_rda_secret_1:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_pet_rda_secret_1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end



function modifier_pet_rda_secret_1:GetModifierModelChange(params)
 return "models/courier/baby_rosh/babyroshan_ti10_dire_flying.vmdl"
end

function modifier_pet_rda_secret_1:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_pet_rda_secret_1:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_pet_rda_secret_1:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_secret_1", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_pet_rda_secret_1:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_pet_rda_secret_1", self:GetParent() )
	if not modifier then return end
	
	-- modifier:Destroy()
end
end
end
end