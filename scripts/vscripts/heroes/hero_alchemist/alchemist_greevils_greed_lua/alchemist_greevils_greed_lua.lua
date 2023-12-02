alchemist_greevils_greed_lua = class({})
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua_debuff", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_chemical_rage_lua", "heroes/hero_alchemist/alchemist_chemical_rage_lua/alchemist_chemical_rage_lua", LUA_MODIFIER_MOTION_NONE )

function alchemist_greevils_greed_lua:GetIntrinsicModifierName()
	return "modifier_alchemist_greevils_greed_lua"
end

function alchemist_greevils_greed_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_alchemist_str50") ~= nil then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function alchemist_greevils_greed_lua:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function alchemist_greevils_greed_lua:OnSpellStart()
	if self:GetCursorTarget() then
		local info = {
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/units/heroes/hero_alchemist/alchemist_berserk_potion_projectile.vpcf",
			iMoveSpeed = 500,
		}
		ProjectileManager:CreateTrackingProjectile(info)
	else
		local front = self:GetCaster():GetForwardVector():Normalized()
		local target_pos = self:GetCaster():GetOrigin() + front * 200
		EmitSoundOn("SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster())
		local r = {0,1,3,4,6}
		CreateRune(target_pos, r[RandomInt(1, #r)])
	end
end

function alchemist_greevils_greed_lua:OnProjectileHit( target, location )
	if not target then return end
	target:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_chemical_rage_lua", {duration = 20})
end
-----------------------------------------------------------------------------------

modifier_alchemist_greevils_greed_lua = class({})

function modifier_alchemist_greevils_greed_lua:IsHidden()
	if self:GetStackCount() == 0 then
		return true
	end
	return false
end

function modifier_alchemist_greevils_greed_lua:IsPurgable()
	return false
end

function modifier_alchemist_greevils_greed_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_alchemist_greevils_greed_lua:RemoveOnDeath()
	return false
end

function modifier_alchemist_greevils_greed_lua:DestroyOnExpire()
	return false
end

function modifier_alchemist_greevils_greed_lua:OnCreated()
	if not IsServer() then
		return
	end
	self:SetStackCount(0)
	self.table = {}
	for iPlayerID = 1,PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(iPlayerID) then
			hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if hHero and hHero ~= self:GetCaster() then
				self.table[iPlayerID] = hHero
			end
		end
	end
end

function modifier_alchemist_greevils_greed_lua:OnRefresh()
	if not IsServer() then
		return
	end
	self.table = {}
	for iPlayerID = 1,PlayerResource:GetPlayerCount() - 1 do
		if PlayerResource:IsValidPlayer(iPlayerID) then
			hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
			if hHero and hHero ~= self:GetCaster() then
				self.table[iPlayerID] = hHero
			end
		end
	end
end

function modifier_alchemist_greevils_greed_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_alchemist_greevils_greed_lua:OnDeath( params )
if self:GetParent():PassivesDisabled() then return end
	if self:GetParent():FindAbilityByName("special_bonus_unique_npc_dota_hero_alchemist_str50")	then
		self:IncrementStackCount()
	end
	self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_alchemist_int9")	
	if abil ~= nil then 
		self.hero_bonus = self.hero_bonus * 1.5
	end
	if params.attacker == self:GetParent() then
		self:GetCaster():ModifyGoldFiltered(self.hero_bonus, false, DOTA_ModifyGold_Unspecified )	
		self:PlayEffects1(params.attacker)
		self:PlayEffects2(params.attacker, self.hero_bonus )	
	end
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_alchemist_int_last")	
	if abil ~= nil then 
		if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() and params.attacker:IsRealHero() and params.attacker ~= self:GetParent() then
			for _,hero in pairs(self.table) do
				hero:ModifyGoldFiltered(self.hero_bonus/2, false, DOTA_ModifyGold_Unspecified )	
				self:PlayEffects1(params.attacker)
				self:PlayEffects2(params.attacker, (self.hero_bonus/2) )
			end
		end
	end
end

function modifier_alchemist_greevils_greed_lua:PlayEffects1(hero)	
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf"
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hero, hero:GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, hero:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_alchemist_greevils_greed_lua:PlayEffects2(hero, bonus)
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf"	
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, hero, hero:GetPlayerOwner() )
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(0, bonus, 0))
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(2, string.len(bonus) + 1, 0))
	ParticleManager:SetParticleControl(effect_cast, 3, Vector(255, 200, 33) )-- Gold
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_alchemist_greevils_greed_lua:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

function modifier_alchemist_greevils_greed_lua:GetModifierBonusStats_Intellect()
	return self:GetStackCount()
end

function modifier_alchemist_greevils_greed_lua:GetModifierBonusStats_Agility()
	return self:GetStackCount()
end