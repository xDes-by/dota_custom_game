LinkLuaModifier( "modifier_rda_pet_cleave", "items/pets/pet_rda_cleave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_pet_RDA_cleave", "items/pets/pet_rda_cleave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_bfury_lua_debuff", 'items/custom_items/item_bfury_lua.lua', LUA_MODIFIER_MOTION_NONE)

spell_item_pet_RDA_cleave = class({})

function spell_item_pet_RDA_cleave:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()
		
		self.caster:AddNewModifier(
		self.caster,
		self,
		"modifier_rda_pet_cleave", 
		{})
		EmitSoundOn( "Hero_Lion.Voodoo", self:GetCaster() )
	end
end

function spell_item_pet_RDA_cleave:GetIntrinsicModifierName()
	return "modifier_item_pet_RDA_cleave"
end

modifier_item_pet_RDA_cleave = class({})

function modifier_item_pet_RDA_cleave:IsHidden()
	return true
end

function modifier_item_pet_RDA_cleave:IsPurgable()
	return false
end

function modifier_item_pet_RDA_cleave:OnCreated( kv )
		if IsServer() then
	local point = self:GetCaster():GetAbsOrigin()
	if not self:GetCaster():IsIllusion() then
	self.pet = CreateUnitByName("pet_rda_cleave", point, true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.pet:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
	self.pet:SetOwner(self:GetCaster())
	end
	end
end
function modifier_item_pet_RDA_cleave:OnDestroy()
	UTIL_Remove(self.pet)
end
function modifier_item_pet_RDA_cleave:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
	}
	return funcs
end

function modifier_item_pet_RDA_cleave:OnAttackLanded(keys)
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
	
	local reduse, item = check_desolator(self:GetParent())
					
	local enemies = FindUnitsInCone( self:GetParent():GetTeamNumber(), keys.target:GetOrigin(), self:GetParent():GetOrigin(), range, 150, 360, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		if enemy ~= keys.target then
			if reduse ~= nil then 
				if not enemy:HasModifier("modifier_item_bfury_lua_debuff") then
					enemy:AddNewModifier(self:GetParent(), item, "modifier_item_bfury_lua_debuff", {duration = 5})
				end
			end
			ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
		end
	end
	self:PlayEffects1(direction )
end

function modifier_item_pet_RDA_cleave:PlayEffects1(direction )
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function check_desolator(target)
local desolator_dict = { 
	["modifier_item_desolator_lua"] = 7,
	["modifier_item_desolator_lua_2"] = 15,
	["modifier_item_desolator_lua_3"] = 20,
	["modifier_item_desolator_lua_4"] = 40,
	["modifier_item_desolator_lua_5"] = 80,
	["modifier_item_desolator_lua_6"] = 120,
	["modifier_item_desolator_lua_7"] = 200,
	["modifier_item_desolator_lua_8"] = 300,
	}
	
	for key,val in pairs(desolator_dict) do
		local modifier = target:FindModifierByName(key)
		if modifier then
			local item = modifier:GetAbility()
			return val, item
		end
	end
end

function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_rda_pet_cleave = class({})

function modifier_rda_pet_cleave:IsHidden()
	return true
end

function modifier_rda_pet_cleave:IsPurgable()
	return false
end

function modifier_rda_pet_cleave:OnCreated( kv )
	self.caster = self:GetCaster()
	
	self.speed = self:GetAbility():GetSpecialValueFor( "speed" )

end

function modifier_rda_pet_cleave:OnRefresh( kv )
end

function modifier_rda_pet_cleave:OnRemoved(kv)
end

function modifier_rda_pet_cleave:OnDestroy()
end

function modifier_rda_pet_cleave:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_rda_pet_cleave:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_SPENT_MANA,
	}
	return funcs
end

function modifier_rda_pet_cleave:GetModifierModelChange(params)
 return "models/items/courier/faceless_rex/faceless_rex.vmdl"
end

function modifier_rda_pet_cleave:GetModifierMoveSpeed_Absolute()
	return self.speed
end

function modifier_rda_pet_cleave:GetModifierIncomingDamage_Percentage()
	return 300
end

function modifier_rda_pet_cleave:OnAttack( params )
	if IsServer() then
	if params.attacker~=self:GetParent() then return end
	--if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then return end

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_cleave", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end

function modifier_rda_pet_cleave:OnSpentMana( params )
	if IsServer() then
	local ability = self:GetAbility()
	local parent = self:GetParent()

	local cost = params.cost
	local unit = params.unit
			
	if unit == parent then
	
	self.mana_loss = 0
	
    self.mana_loss = self.mana_loss + params.cost
	if self.mana_loss >= 10 then

	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_rda_pet_cleave", self:GetParent() )
	if not modifier then return end
	
	modifier:Destroy()
end
end
end
end