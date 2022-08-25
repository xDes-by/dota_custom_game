summon_buff = class({})

function summon_buff:Spawn()
	if IsServer() then self:SetLevel(1) end
end

function summon_buff:GetIntrinsicModifierName() return "modifier_summon_buff" end

LinkLuaModifier("modifier_summon_buff", "heroes/hero_shaman/shaman_wards/summon_buff", LUA_MODIFIER_MOTION_NONE)

modifier_summon_buff = class({})

function modifier_summon_buff:IsHidden() return true end
function modifier_summon_buff:IsDebuff() return false end
function modifier_summon_buff:IsPurgable() return false end
function modifier_summon_buff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_summon_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 	-- GetModifierDamageOutgoing_Percentage
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 	-- GetModifierAttackSpeedBonus_Constant
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
	}
end

function modifier_summon_buff:OnCreated()
	self:SetHasCustomTransmitterData(true)
	if IsClient() then return end
	
	
	

	if (not self:GetParent()) or (not self:GetAbility()) or self:GetParent():IsNull() or self:GetAbility():IsNull() then self:Destroy() return end

	self.owner = self:GetParent():GetOwner()
	self.exception_power = 1
	local player_owner = self:GetParent():GetPlayerOwner()

	if (not self.owner) or (not player_owner) or self.owner:IsNull() or player_owner:IsNull() then self:Destroy() return end

	self.hero = (player_owner.GetAssignedHero and player_owner:GetAssignedHero()) or nil

	if (not self.hero) or self.hero:IsNull() then self:Destroy() return end


	Timers:CreateTimer(0.01, function()
		self:OnIntervalThink()
		if self:GetParent() and (not self:GetParent():IsNull()) then self:GetParent():SetHealth(self:GetParent():GetMaxHealth()) end
	end)

	self:StartIntervalThink(1.0)
end

function modifier_summon_buff:OnRefresh()
	if IsClient() then return end
	if not self:GetParent() or self:GetParent():IsNull() or not self.hero or self.hero:IsNull() or not self:GetAbility() or self:GetAbility():IsNull() then return end
	
	self:SetValues()
	
	local agi = self.hero:GetAgility() or 0
	local int = self.hero:GetIntellect() or 0

	self.bonus_dmg = math.floor(self.dmg_per_int * int)
	self.bonus_as = math.floor(self.as_per_agi * agi)	

	self:SendBuffRefreshToClients()
end

function modifier_summon_buff:OnIntervalThink()
	self:OnRefresh()
end

function modifier_summon_buff:SetValues()
	local abil_hero = self.hero:FindAbilityByName("shaman_wards_custom")
	
	self.as_per_agi = abil_hero:GetSpecialValueFor("as_per_agi")
	self.dmg_per_int = abil_hero:GetSpecialValueFor("dmg_per_int")

local abil = self.hero:FindAbilityByName("npc_dota_hero_shadow_shaman_agi9")             
	if abil ~= nil then 
	self.dmg_per_int = abil_hero:GetSpecialValueFor("dmg_per_int")*2
end

local abil = self.hero:FindAbilityByName("npc_dota_hero_shadow_shaman_agi11")             
	if abil ~= nil then 
	self.as_per_agi = abil_hero:GetSpecialValueFor("as_per_agi")*2
end
end

function modifier_summon_buff:GetModifierAttackSpeedBonus_Constant() return self.bonus_as end
function modifier_summon_buff:GetModifierPreAttack_BonusDamage() return self.bonus_dmg end


function modifier_summon_buff:AddCustomTransmitterData()
	return {
		bonus_as = self.bonus_as,
		bonus_dmg = self.bonus_dmg,
	}
end

function modifier_summon_buff:HandleCustomTransmitterData(data)
	self.bonus_as = tonumber(data.bonus_as)
	self.bonus_dmg = tonumber(data.bonus_dmg)
end

----------------------------------------------------------------------------------------------

function modifier_summon_buff:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if self:GetCaster():GetOwner():FindAbilityByName("npc_dota_hero_shadow_shaman_agi_last") ~= nil then
			if RandomInt(0, 100) < 15 then
				self.record = params.record
				return 325
			end
		end
	end
end

function modifier_summon_buff:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		if self.record and self.record == params.record then
			self.record = nil

			-- Play effects
			local sound_cast = "Hero_Juggernaut.BladeDance"
			EmitSoundOn( sound_cast, params.target )
		end
	end
end