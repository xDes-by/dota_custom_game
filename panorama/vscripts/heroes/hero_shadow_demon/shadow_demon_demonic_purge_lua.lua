shadow_demon_demonic_purge_lua = class({})
LinkLuaModifier("modifier_demonic_purge_lua", "heroes/hero_shadow_demon/modifier_demonic_purge_lua", LUA_MODIFIER_MOTION_NONE)

function shadow_demon_demonic_purge_lua:Spawn()
	if IsClient() then return end

	EventDriver:Listen("Hero:shard_received", shadow_demon_demonic_purge_lua.OnShardRecieved, self)

	Timers:CreateTimer(0.01, function()
		local caster = self:GetCaster()
		if caster:HasShard() then
			self:OnShardRecieved({hero = caster})
		end
	end)
end

function shadow_demon_demonic_purge_lua:OnUpgrade()
	if IsClient() then return end
	
	if IsValidEntity(self.shard_ability) then
		self.shard_ability:SetLevel(self:GetLevel())
	end
end

-- It's done in that way, because AbilityDraftUltShardAbility always level up shard ability
function shadow_demon_demonic_purge_lua:OnShardRecieved(event)
	if self:IsNull() then return end

	local caster = self:GetCaster()

	if event.hero == caster then

		-- To fix spell reflect can give Cleanse ability
		if not table.contains(caster.abilities, self:GetAbilityName()) then return end

		self.shard_ability_name = "shadow_demon_demonic_cleanse_lua"
		local demonic_cleanse = caster:FindAbilityByName(self.shard_ability_name) 

		if demonic_cleanse then return end

		demonic_cleanse = caster:AddAbility(self.shard_ability_name)
		demonic_cleanse:SetHidden(false)
		demonic_cleanse:SetLevel(self:GetLevel())

		EventDriver:Dispatch("HeroBuilder:ability_added", {
			hero = caster,
			ability = demonic_cleanse,
			ability_name = self.shard_ability_name,
			player_id = caster:GetPlayerOwnerID(),
		})

		self.shard_ability = demonic_cleanse

		Timers:CreateTimer(0.15, function()
			if not IsValidEntity(caster) or not IsValidEntity(demonic_cleanse) then return end

			HeroBuilder:SetAbilityToSlot(caster, demonic_cleanse)
			HeroBuilder:RefreshAbilityOrder(caster:GetPlayerOwnerID())
		end)
	end
end

function shadow_demon_demonic_purge_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_shadow_demon_9")
end

function shadow_demon_demonic_purge_lua:GetChargeCooldown()
	return self:GetCooldown(-1)
end

function shadow_demon_demonic_purge_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()
	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, caster:GetTeamNumber())
end

function shadow_demon_demonic_purge_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	if not IsValidEntity(caster) or not IsValidEntity(target) then return end

	local duration = target:ApplyStatusResistance(self:GetDuration())
	caster:EmitSound("Hero_ShadowDemon.DemonicPurge.Cast")

	if target:TriggerSpellAbsorb(self) then return end

	-- Ends previous purge to purge again
	if target:HasModifier("modifier_demonic_purge_lua") then
		target:FindModifierByName("modifier_demonic_purge_lua"):Destroy()
	end

	target:AddNewModifier(caster, self, "modifier_demonic_purge_lua", { duration = duration })
	target:EmitSound("Hero_ShadowDemon.DemonicPurge.Impact")
end
