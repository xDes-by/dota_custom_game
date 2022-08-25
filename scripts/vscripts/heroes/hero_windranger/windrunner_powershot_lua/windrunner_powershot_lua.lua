local THIS_LUA = "heroes/hero_windranger/windrunner_powershot_lua/windrunner_powershot_lua.lua"
LinkLuaModifier("modifier_debuff", "heroes/hero_windranger/windrunner_powershot_lua/windrunner_powershot_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_debuff_resist", "heroes/hero_windranger/modifier_debuff_resist", LUA_MODIFIER_MOTION_NONE)

windrunner_powershot_lua = class({})
local ability_class = windrunner_powershot_lua

function ability_class:GetChannelAnimation()
	return ACT_DOTA_CAST_ABILITY_2
end

function ability_class:GetChannelTime()
	return self:GetSpecialValueFor("channel_time")
end

function ability_class:OnChannelThink(flInterval)
	if IsServer() then
		local ability = self
		local caster = self:GetCaster()
		local attack_damage = GetTalentSpecialValueFor(ability, "attack_damage")
		--local total_damage = caster:GetAverageTrueAttackDamage(caster) * (attack_damage / 100)
		-- self.damage = self.damage + total_damage / self:GetChannelTime() * flInterval
	
		self.damage = attack_damage
	end
end

function ability_class:OnChannelFinish(bInterrupted)
	if IsServer() then
		local caster = self:GetCaster()

		StopSoundOn("Ability.PowershotPull", caster)
		EmitSoundOn("Ability.Powershot", caster)

		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)

		local distance = self:GetSpecialValueFor("arrow_range") + caster:GetCastRangeBonus()
		local p_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
		self:FireLinearProjectile(p_name, 
		caster:GetForwardVector() * self:GetSpecialValueFor("arrow_speed"), distance, self:GetSpecialValueFor("arrow_width"), 
		{ExtraData={ damage = self.damage }}, false, true, self:GetSpecialValueFor("vision_radius"))

		local talent = caster:FindAbilityByName("npc_dota_hero_windrunner_int11")
		if talent ~= nil then
	
			local direction_1 = RotatePosition(Vector(0,0,0), QAngle(0,30,0), caster:GetForwardVector())
	
			local direction_11 = RotatePosition(Vector(0,0,0), QAngle(0,360 - 30,0), caster:GetForwardVector())
			self:FireLinearProjectile(p_name, 
			direction_1 * self:GetSpecialValueFor("arrow_speed"), distance, self:GetSpecialValueFor("arrow_width"), 
			{ExtraData={ damage = self.damage }}, false, true, self:GetSpecialValueFor("vision_radius"))
			self:FireLinearProjectile(p_name, 
			direction_11 * self:GetSpecialValueFor("arrow_speed"), distance, self:GetSpecialValueFor("arrow_width"), 
			{ExtraData={ damage = self.damage }}, false, true, self:GetSpecialValueFor("vision_radius"))
		end
	end
end

function ability_class:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int7")             
	if abil ~= nil then 
		local ability = self:GetCaster():FindAbilityByName("windrunner_passive_lua")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mp_loss") * 0.01
				 return self:GetCaster():GetIntellect()/2 - (self:GetCaster():GetIntellect() * mp_loss)
			end	
			return self:GetCaster():GetIntellect()/2
	end
		local ability = self:GetCaster():FindAbilityByName("windrunner_passive_lua")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mp_loss") * 0.01
				 return self:GetCaster():GetIntellect() - (self:GetCaster():GetIntellect() * 2 * mp_loss)
			end	
			return self:GetCaster():GetIntellect()
end


if IsServer() then
	function ability_class:OnSpellStart( )
		local ability = self
		local caster = self:GetCaster()
		local pos = self:GetCursorPosition()
		local direction = CalculateDirection(pos, caster:GetAbsOrigin())
		self.damage = 0

		EmitSoundOn("Ability.PowershotPull", caster)
		-- self.nfx = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_channel_ti6.vpcf", PATTACH_POINT, caster)
		-- 			ParticleManager:SetParticleControlEnt(self.nfx, 0, caster, PATTACH_POINT_FOLLOW, "bow_mid1", caster:GetAbsOrigin(), true)
		-- 			ParticleManager:SetParticleControl(self.nfx, 1, caster:GetAbsOrigin())
		-- 			ParticleManager:SetParticleControlForward(self.nfx, 1, direction)

	end
end

function ability_class:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()

	if hTarget then 
		EmitSoundOn("Ability.PowershotDamage", hTarget)

		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_agi7")             
			if abil ~= nil then 
			local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
			hTarget:AddNewModifier(caster, ability, "modifier_debuff", {duration = 2})
		end
		
		local damage = GetTalentSpecialValueFor(ability, "attack_damage")
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_str10")             
		if abil ~= nil then 
			if self:GetCaster():GetHealthPercent() <= 30 then
				damage = damage * 3
			end
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int6")             
		if abil ~= nil then 
			hTarget:AddNewModifier(caster, ability, "modifier_debuff_resist", {duration = 2})
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int8")             
		if abil ~= nil then 
		damage = damage + (self:GetCaster():GetIntellect()/2)
		end
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_int_last")             
		if abil ~= nil then 
		damage = damage + (self:GetCaster():GetIntellect()/2)
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_windrunner_str_last") ~= nil then
			caster:Heal(damage, self)
		end
		ApplyDamage({
			victim = hTarget, attacker = caster, 
			ability = ability, damage_type = ability:GetAbilityDamageType(), 
			damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NONE
		})

	--	SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_DAMAGE, hTarget, damage, caster:GetPlayerOwner())
	else
		AddFOWViewer(caster:GetTeam(), vLocation, ability:GetSpecialValueFor("vision_radius"), ability:GetSpecialValueFor("vision_duration"), true)
	end
end

function ability_class:OnProjectileThink(vLocation)
	if not IsServer() then return end
	GridNav:DestroyTreesAroundPoint(vLocation, self:GetSpecialValueFor("arrow_width"), true)
end


function ability_class:FireLinearProjectile(FX, velocity, distance, width, data, bDelete, bVision, vision)
	local internalData = data or {}
	local delete = false
	if bDelete then delete = bDelete end
	local provideVision = true
	if bVision then provideVision = bVision end
	local info = {
		EffectName = FX,
		Ability = self,
		vSpawnOrigin = internalData.origin or self:GetCaster():GetAbsOrigin(), 
		fStartRadius = width,
		fEndRadius = internalData.width_end or width,
		vVelocity = velocity,
		fDistance = distance or 1000,
		Source = internalData.source or self:GetCaster(),
		iUnitTargetTeam = internalData.team or self:GetAbilityTargetTeam(),
		iUnitTargetType = internalData.type or self:GetAbilityTargetType(),
		iUnitTargetFlags = internalData.type or self:GetAbilityTargetFlags(),
		iSourceAttachment = internalData.attach or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDeleteOnHit = delete,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bProvidesVision = provideVision,
		iVisionRadius = vision or 100,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData = internalData.extraData
	}
	local projectile = ProjectileManager:CreateLinearProjectile( info )
	return projectile
end




---------------------------------------------------------------------------------------
modifier_debuff = class({})

function modifier_debuff:IsHidden() return false end
function modifier_debuff:IsPurgable() return true end

function modifier_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	} 
end

function modifier_debuff:GetModifierIncomingDamage_Percentage(  )
	return self:GetAbility():GetSpecialValueFor("debuff_incoming_damage")
end


-----------------------------------------------------------------------------------------

function CalculateDirection(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	direction.z = 0
	return direction
end


function HasTalent(unit, talentName)
    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function GetTalentSpecialValueFor(ability, value)
    local base = ability:GetSpecialValueFor(value)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then 
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
    end
    return base
end

function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end