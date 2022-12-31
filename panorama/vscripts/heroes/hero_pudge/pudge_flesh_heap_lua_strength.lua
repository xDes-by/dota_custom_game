pudge_flesh_heap_lua_strength = class({})
modifier_pudge_flesh_heap_lua_strength = class({})

LinkLuaModifier("modifier_pudge_flesh_heap_lua_strength", "heroes/hero_pudge/pudge_flesh_heap_lua_strength.lua" ,LUA_MODIFIER_MOTION_NONE)

function pudge_flesh_heap_lua_strength:GetIntrinsicModifierName()
	return "modifier_pudge_flesh_heap_lua_strength"
end

--Yoinked from LOD REDUX modified for CHC by Australia is my City

--Taken from the spelllibrary, credits go to valve

function pudge_flesh_heap_lua_strength:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_pudge_flesh_heap_block", { duration = self:GetSpecialValueFor("duration")})
end

--------------------------------------------------------------------------------
-- Refresh modifier on hero level up

function pudge_flesh_heap_lua_strength:OnHeroLevelUp()
	if self:GetLevel() == 0 or (not IsServer()) then return end

	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_pudge_flesh_heap_lua_strength")

	if not modifier or modifier:IsNull() then return end

	modifier:ForceRefresh()

	-- +1 particle
	-- Copied from https://moddota.com/forums/discussion/1156/modifying-silencers-int-steal
	-- CP1.y = value
	-- CP2.x = linger time
	-- CP2.y = 2 (for a plus sign)
	-- CP3 = color (r, g, b)
	Timers:CreateTimer(modifier.delay, function()
		local numParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(numParticle, 1, Vector(10, 1, 0))
		ParticleManager:SetParticleControl(numParticle, 2, Vector(1, 2, 0))
		ParticleManager:SetParticleControl(numParticle, 3, Vector(255, 100, 100))
		ParticleManager:ReleaseParticleIndex(numParticle)
	end)
end

--------------------------------------------------------------------------------
-- Flesh heap modifier properties
-- Is hidden if not skilled, else is shown
-- Is not removed on death
-- Is a passive
-- Is not Purgable

function modifier_pudge_flesh_heap_lua_strength:IsHidden()
	local ability = self:GetAbility()
	if ability and ability:GetLevel() == 0 then
		return true
	end
	return false
end

function modifier_pudge_flesh_heap_lua_strength:RemoveOnDeath() return false end
function modifier_pudge_flesh_heap_lua_strength:IsPurgable() return false end
function modifier_pudge_flesh_heap_lua_strength:IsDebuff() return false end

--------------------------------------------------------------------------------
-- On created

function modifier_pudge_flesh_heap_lua_strength:OnCreated(kv)
	self:SetHasCustomTransmitterData(true)
	if not IsServer() then return end

	self.delay = 2

	self.listener = ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(modifier_pudge_flesh_heap_lua_strength, "OnPlayerLearnedAbility"), self)

	local ability = self:GetAbility() or nil
	local caster = self:GetCaster() or nil
	if not ability then
		caster:RemoveModifierByName("modifier_pudge_flesh_heap_lua_strength")
		caster:CalculateStatBonus(false)
		if self.listener then
			StopListeningToGameEvent(self.listener)
		end
		return
	end

	self.fleshHeapRange = ability:GetSpecialValueFor("aura_radius") or 0
	self.flesh_heap_buff_amount_kill = ability:GetSpecialValueFor("strength_per_kill") or 0
	self.flesh_heap_buff_amount_level = ability:GetSpecialValueFor("strength_per_level") or 0
	self.magic_resist = ability:GetSpecialValueFor("magic_resistance") or 0

	self.nKills = caster:GetKills() + caster:GetAssists() or 0 -- Not sure if or 0 is necessary but ill have it just in case
	self:SetStackCount(self.nKills + caster:GetLevel())

	self.strength_bonus_total = self.nKills * self.flesh_heap_buff_amount_kill + caster:GetLevel() * self.flesh_heap_buff_amount_level

	caster:CalculateStatBonus(false)
end

--------------------------------------------------------------------------------
-- Refresh ability

function modifier_pudge_flesh_heap_lua_strength:OnRefresh()
	if not IsServer() then return end
	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	if (not ability) or (ability:IsNull()) then
		self:GetParent():RemoveModifierByName("modifier_pudge_flesh_heap_lua_strength")
		self:GetParent():CalculateStatBonus(false)
		return
	end

	self.flesh_heap_buff_amount_kill = ability:GetSpecialValueFor("strength_per_kill") or 0
	self.flesh_heap_buff_amount_level = ability:GetSpecialValueFor("strength_per_level") or 0
	self.magic_resistance = ability:GetSpecialValueFor("magic_resistance") or 0

	-- Add extra delay if other flesh heaps are owned by caster, also yoink their stack count
	self.delay = 2

	local agi = caster:FindAbilityByName("pudge_flesh_heap_lua_agility")
	local int = caster:FindAbilityByName("pudge_flesh_heap_lua_intellect")

	if agi and agi:GetLevel() > 0 then
		self.nKills = agi.nKills or self.nKills
	end
	if int and int:GetLevel() > 0 then
		self.nKills = int.nKills or self.nKills
	end

	self:SetStackCount(self.nKills + caster:GetLevel())
	
	self.strength_bonus_total = self.nKills * self.flesh_heap_buff_amount_kill + caster:GetLevel() * self.flesh_heap_buff_amount_level

	caster:CalculateStatBonus(false)

	self:SendBuffRefreshToClients()
end

--------------------------------------------------------------------------------
-- On ability skilled

function modifier_pudge_flesh_heap_lua_strength:OnPlayerLearnedAbility(keys)
	if IsClient() then return end
	if keys.abilityname == "special_bonus_unique_pudge_1" and self and not self:IsNull() then
		self:ForceRefresh()
	end
end

--------------------------------------------------------------------------------
-- Flesh heap gives bonus strength, magic resist and uses an on death event

function modifier_pudge_flesh_heap_lua_strength:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_pudge_flesh_heap_lua_strength:GetModifierBonusStats_Strength() return self.strength_bonus_total end
function modifier_pudge_flesh_heap_lua_strength:GetModifierMagicalResistanceBonus() return self.magic_resist end

--------------------------------------------------------------------------------
-- On death

function modifier_pudge_flesh_heap_lua_strength:OnDeath(keys)
	if not IsServer() or not keys.unit or not keys.attacker or not keys.unit:IsRealHero() or keys.unit:IsReincarnating() then return end

	local hKiller = keys.attacker:GetPlayerOwner()
	local hVictim = keys.unit
	local caster = self:GetCaster()
	local ability = self:GetAbility()

	if not (hVictim and caster and ability) then return end

	if caster:GetTeamNumber() ~= hVictim:GetTeamNumber() and caster:IsAlive() then
		local vToCaster = caster:GetOrigin() - hVictim:GetOrigin()
		local flDistance = vToCaster:Length2D()
		if hKiller == caster:GetPlayerOwner() or self.fleshHeapRange >= flDistance then
			local hBuff = caster:FindModifierByName("modifier_pudge_flesh_heap_lua_strength")
			if not hBuff then
				caster:AddNewModifier(caster, self, "modifier_pudge_flesh_heap_lua_strength", {})
			end

			self.nKills = (self.nKills + 1) or 1

			self:SetStackCount(self.nKills + caster:GetLevel())

			self.strength_bonus_total = self.nKills * self.flesh_heap_buff_amount_kill + caster:GetLevel() * self.flesh_heap_buff_amount_level

			caster:CalculateStatBonus(false)

			Timers:CreateTimer(self.delay, function()
                local numParticle = ParticleManager:CreateParticle("particles/msg_fx/msg_miss.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
                ParticleManager:SetParticleControl(numParticle, 1, Vector(10, 1, 0))
                ParticleManager:SetParticleControl(numParticle, 2, Vector(1, 2, 0))
                ParticleManager:SetParticleControl(numParticle, 3, Vector(255, 100, 100))
                ParticleManager:ReleaseParticleIndex(numParticle)
            end)
		end
	end
end

--------------------------------------------------------------------------------
-- Set transmitter data for strength and magic resist

function modifier_pudge_flesh_heap_lua_strength:AddCustomTransmitterData()
	return
	{
		strength = self.strength_bonus_total,
		magic_resist = self.magic_resist,
	}
end

--------------------------------------------------------------------------------
-- Use transmitter data

function modifier_pudge_flesh_heap_lua_strength:HandleCustomTransmitterData(data)
	self.strength_bonus_total = data.strength
	self.magic_resist = data.magic_resist
end


if not IsServer() then return end

function modifier_pudge_flesh_heap_lua_strength:OnRemoved()
	if self.listener then
		StopListeningToGameEvent(self.listener)
	end
end
