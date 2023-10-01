LinkLuaModifier("modifier_item_meteor_hammer_lua", 'items/custom_items/item_meteor_hammer_lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_meteor_hammer_lua_burn", 'items/custom_items/item_meteor_hammer_lua', LUA_MODIFIER_MOTION_NONE)

item_meteor_hammer_lua = class({})


function item_meteor_hammer_lua:GetIntrinsicModifierName()
	return "modifier_item_meteor_hammer_lua"
end

function item_meteor_hammer_lua:GetAOERadius()
	return self:GetSpecialValueFor("impact_radius")
end

function item_meteor_hammer_lua:GetChannelAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function item_meteor_hammer_lua:OnSpellStart()
	self.caster = self:GetCaster()
	
	self.burn_dps_buildings			=	self:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self:GetSpecialValueFor("burn_interval")
	self.land_time					=	self:GetSpecialValueFor("land_time")
	self.impact_radius				=	self:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self:GetSpecialValueFor("impact_damage_units")

	if not IsServer() then return end

	local position	= self:GetCursorPosition()
	
	self.caster:EmitSound("DOTA_Item.MeteorHammer.Channel")
	
	AddFOWViewer(self.caster:GetTeam(), position, self.impact_radius, 3.8, false)

	self.particle = ParticleManager:CreateParticleForTeam("particles/items4_fx/meteor_hammer_aoe.vpcf", PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeam())
	ParticleManager:SetParticleControl(self.particle, 0, position)
	ParticleManager:SetParticleControl(self.particle, 1, Vector(self.impact_radius, 1, 1))
	
	self.particle2 = ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
end

function item_meteor_hammer_lua:OnChannelFinish(bInterrupted)
	if not IsServer() then return end

	self.position = self:GetCursorPosition()

	if bInterrupted then
		self.caster:StopSound("DOTA_Item.MeteorHammer.Channel")
	
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:DestroyParticle(self.particle2, true)
	else
		self.caster:EmitSound("DOTA_Item.MeteorHammer.Cast")
	
		self.particle3	= ParticleManager:CreateParticle("particles/items4_fx/meteor_hammer_spell.vpcf", PATTACH_WORLDORIGIN, self.caster)
		ParticleManager:SetParticleControl(self.particle3, 0, self.position + Vector(0, 0, 1000))
		ParticleManager:SetParticleControl(self.particle3, 1, self.position)
		ParticleManager:SetParticleControl(self.particle3, 2, Vector(self.land_time, 0, 0))
		ParticleManager:ReleaseParticleIndex(self.particle3)
		
		Timers:CreateTimer(self.land_time, function()
			if not self:IsNull() then
				GridNav:DestroyTreesAroundPoint(self.position, self.impact_radius, true)
			
				EmitSoundOnLocationWithCaster(self.position, "DOTA_Item.MeteorHammer.Impact", self.caster)
			
				local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.position, nil, self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				
				for _, enemy in pairs(enemies) do
					enemy:EmitSound("DOTA_Item.MeteorHammer.Damage")
				
					enemy:AddNewModifier(self.caster, self, "modifier_stunned", {duration = self.stun_duration * (1 - enemy:GetStatusResistance())})
					enemy:AddNewModifier(self.caster, self, "modifier_item_meteor_hammer_lua_burn", {duration = self.burn_duration})
					
					local impactDamage = self.impact_damage_units
					
					if enemy:IsBuilding() then
						impactDamage = self.impact_damage_buildings
					end
					
					local damageTable = {
						victim 			= enemy,
						damage 			= impactDamage,
						damage_type		= DAMAGE_TYPE_MAGICAL,
						damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
						attacker 		= self.caster,
						ability 		= self
					}
									
					ApplyDamage(damageTable)
				end
			end
		end)
	end
	
	ParticleManager:ReleaseParticleIndex(self.particle)
	ParticleManager:ReleaseParticleIndex(self.particle2)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_lua_burn = class({})

function modifier_item_meteor_hammer_lua_burn:GetEffectName()
	return "particles/items4_fx/meteor_hammer_spell_debuff.vpcf"
end

function modifier_item_meteor_hammer_lua_burn:IgnoreTenacity()
	return true
end

function modifier_item_meteor_hammer_lua_burn:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_meteor_hammer_lua_burn:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	if self.ability == nil then return end
	
	self.burn_dps_buildings			=	self.ability:GetSpecialValueFor("burn_dps_buildings")
	self.burn_dps_units				=	self.ability:GetSpecialValueFor("burn_dps_units")
	self.burn_duration				=	self.ability:GetSpecialValueFor("burn_duration")
	self.stun_duration				=	self.ability:GetSpecialValueFor("stun_duration")
	self.burn_interval				=	self.ability:GetSpecialValueFor("burn_interval")
	self.land_time					=	self.ability:GetSpecialValueFor("land_time")
	self.impact_radius				=	self.ability:GetSpecialValueFor("impact_radius")
	self.max_duration				=	self.ability:GetSpecialValueFor("max_duration")
	self.impact_damage_buildings	=	self.ability:GetSpecialValueFor("impact_damage_buildings")
	self.impact_damage_units		=	self.ability:GetSpecialValueFor("impact_damage_units")
	self.spell_reduction_pct		=	self.ability:GetSpecialValueFor("spell_reduction_pct")
	
	self.affectedUnits				= {}
	
	table.insert(self.affectedUnits, self.parent)
	
	self.burn_dps					= self.burn_dps_units
	
	if self.parent:IsBuilding() then
		self.burn_dps	= self.burn_dps_buildings
	end
	
	self.damageTable				= {
										victim 			= self.parent,
										damage 			= self.burn_dps,
										damage_type		= DAMAGE_TYPE_MAGICAL,
										damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
										attacker 		= self.caster,
										ability 		= self.ability
									}
	
	if not IsServer() then return end

	self:StartIntervalThink(self.burn_interval)
end

function modifier_item_meteor_hammer_lua_burn:OnIntervalThink()		
	ApplyDamage(self.damageTable)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self.parent, self.burn_dps, nil)
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_item_meteor_hammer_lua = class({})

function modifier_item_meteor_hammer_lua:IsHidden()			return true end
function modifier_item_meteor_hammer_lua:IsPurgable()		return false end
function modifier_item_meteor_hammer_lua:RemoveOnDeath()	return false end
function modifier_item_meteor_hammer_lua:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_meteor_hammer_lua:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_strength				=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_intellect			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_agility			=	self.ability:GetSpecialValueFor("bonus_all_stats")
	self.bonus_health_regen			=	self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen			=	self.ability:GetSpecialValueFor("bonus_mana_regen")
	if not IsServer() then
		return
	end
	self.value = self:GetAbility():GetSpecialValueFor("bonus_gem")
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value})
	end
end

function modifier_item_meteor_hammer_lua:OnDestroy()
	if not IsServer() then
		return
	end
	if self.value then
		local n = string.sub(self:GetAbility():GetAbilityName(),-1)
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_gem" .. n, {value = self.value * -1})
	end
end

function modifier_item_meteor_hammer_lua:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return decFuncs
end

function modifier_item_meteor_hammer_lua:GetModifierBonusStats_Strength()
	return self.bonus_strength	
end

function modifier_item_meteor_hammer_lua:GetModifierBonusStats_Intellect()
	return self.bonus_intellect
end

function modifier_item_meteor_hammer_lua:GetModifierBonusStats_Agility()
	return self.bonus_agility
end

function modifier_item_meteor_hammer_lua:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end

function modifier_item_meteor_hammer_lua:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end