LinkLuaModifier( "modifier_riki_tricks_of_the_trade_can_move", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_can_move", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_lua", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
LinkLuaModifier( "modifier_riki_tricks_of_the_trade_intrinsic_lua", "heroes/hero_riki/riki_tricks_of_the_trade_lua/modifier_riki_tricks_of_the_trade_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )		-- Hides the caster and damages all enemies in the AoE
riki_tricks_of_the_trade_lua = class({})

function riki_tricks_of_the_trade_lua:GetAbilityTextureName()
	return "riki_tricks_of_the_trade"
end
function riki_tricks_of_the_trade_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function riki_tricks_of_the_trade_lua:GetIntrinsicModifierName()
	return "modifier_riki_tricks_of_the_trade_intrinsic_lua"
end
function riki_tricks_of_the_trade_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int9") then
		return 0.1
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int6") then
		return self.BaseClass.GetCooldown(self, level) / 2
	end
	return self.BaseClass.GetCooldown(self, level)
end

function riki_tricks_of_the_trade_lua:GetBehavior()
	if self:GetCaster():FindModifierByName("npc_dota_hero_riki_str12") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function riki_tricks_of_the_trade_lua:GetChannelTime()
	return self:GetSpecialValueFor("channel_duration")
end

function riki_tricks_of_the_trade_lua:GetAOERadius()
	return self:GetSpecialValueFor("area_of_effect") 
end

function riki_tricks_of_the_trade_lua:OnAbilityPhaseStart()
	if self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
        self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
        self:GetCaster():SetCursorCastTarget(nil)
        self:GetCaster():CastAbilityOnPosition(self:GetCaster():GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
    end
	return true
end

function riki_tricks_of_the_trade_lua:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetCursorTarget() then
		self:GetCaster():SetAbsOrigin(self:GetCursorTarget():GetAbsOrigin())
	end
	local origin = caster:GetAbsOrigin()
	local aoe = self:GetSpecialValueFor("area_of_effect")

	
	self:GetCaster():EmitSound("Hero_Riki.TricksOfTheTrade.Cast")
	self:GetCaster():EmitSound("Hero_Riki.TricksOfTheTrade")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str12") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_riki_tricks_of_the_trade_can_move", {})
	else
		local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
		local tricks_particle = "particles/units/heroes/hero_riki/riki_tricks.vpcf"
		caster:AddNewModifier(caster, self, "modifier_riki_tricks_of_the_trade_lua", {})
		local cast_particle = ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(cast_particle, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(cast_particle)
		self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(self.TricksParticle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.TricksParticle, 1, Vector(aoe, 0, aoe))
		ParticleManager:SetParticleControl(self.TricksParticle, 2, Vector(aoe, 0, aoe))
		caster:AddNoDraw()
	end
end

function riki_tricks_of_the_trade_lua:OnChannelFinish()
	if IsServer() then
		local caster = self:GetCaster()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)

		caster:RemoveModifierByName("modifier_riki_tricks_of_the_trade_lua")
		StopSoundEvent("Hero_Riki.TricksOfTheTrade", caster)
		
		ParticleManager:DestroyParticle(self.TricksParticle, false)
		ParticleManager:ReleaseParticleIndex(self.TricksParticle)
		self.TricksParticle = nil

		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)

		self.target = nil
	end
end






-- function riki_tricks_of_the_trade_custom:GetManaCost(level)
--     return self.BaseClass.GetManaCost(self, level)
-- end

-- function riki_tricks_of_the_trade_custom:GetAOERadius()
--     return self:GetSpecialValueFor("radius")
-- end

-- function riki_tricks_of_the_trade_custom:OnAbilityPhaseStart()
--     if self:GetCursorTarget() and self:GetCursorTarget() == self:GetCaster() then
--         self:GetCaster():SetCursorPosition(self:GetCaster():GetAbsOrigin())
--         self:GetCaster():SetCursorCastTarget(nil)
--         self:GetCaster():CastAbilityOnPosition(self:GetCaster():GetAbsOrigin(), self, self:GetCaster():GetPlayerID())
--     end
--     return true
-- end

-- function riki_tricks_of_the_trade_custom:OnSpellStart()
--     if not IsServer() then return end
--     local point = self:GetCursorPosition()
--     local target = self:GetCursorTarget()
--     local target_scepter = false
--     if target == nil then
--         target = self:GetCaster()
--     end
--     if target and target ~= self:GetCaster() then
--         target_scepter = true
--     end
--     if self:GetCaster():HasTalent("special_bonus_unique_riki_5") then
--         self:GetCaster():Purge(false, true, false, false, false)
--     end
--     self:GetCaster():SetAbsOrigin(point)
--     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_riki_tricks_of_the_trade_custom", {target = target:entindex(), target_scepter = target_scepter})
-- end

-- function riki_tricks_of_the_trade_custom:OnChannelFinish()
--     if not IsServer() then return end
--     local modifier = self:GetCaster():FindModifierByName("modifier_riki_tricks_of_the_trade_custom")
--     if modifier and not modifier:IsNull() then
--         modifier:Destroy()
--     end
-- end