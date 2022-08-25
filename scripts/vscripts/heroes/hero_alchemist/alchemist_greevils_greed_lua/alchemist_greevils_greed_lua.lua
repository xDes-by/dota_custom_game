alchemist_greevils_greed_lua = class({})
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_greevils_greed_lua_debuff", "heroes/hero_alchemist/alchemist_greevils_greed_lua/alchemist_greevils_greed_lua", LUA_MODIFIER_MOTION_NONE )

function alchemist_greevils_greed_lua:GetIntrinsicModifierName()
	return "modifier_alchemist_greevils_greed_lua"
end

function alchemist_greevils_greed_lua:GetManaCost(iLevel)
	return self:GetCaster():GetIntellect()/2
end

function alchemist_greevils_greed_lua:OnSpellStart()
	local front = self:GetCaster():GetForwardVector():Normalized()
	local target_pos = self:GetCaster():GetOrigin() + front * 200
	EmitSoundOn("SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster())
	CreateRune(target_pos, RandomInt(0,5))
end

-----------------------------------------------------------------------------------

modifier_alchemist_greevils_greed_lua = class({})

function modifier_alchemist_greevils_greed_lua:IsHidden()
	return true
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

function modifier_alchemist_greevils_greed_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_alchemist_greevils_greed_lua:OnDeath( params )
if self:GetParent():PassivesDisabled() then return end
	self.hero_bonus = self:GetAbility():GetSpecialValueFor( "bonus_gold" )
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_alchemist_int9")	
	if abil ~= nil then 
		self.hero_bonus = self.hero_bonus * 1.5
	end
	if params.attacker == self:GetParent() then
		PlayerResource:ModifyGold( params.attacker:GetPlayerOwnerID(), self.hero_bonus, false, DOTA_ModifyGold_Unspecified )	
		self:PlayEffects1(params.attacker)
		self:PlayEffects2(params.attacker, self.hero_bonus )	
	end
	local abil = self:GetParent():FindAbilityByName("npc_dota_hero_alchemist_int_last")	
	if abil ~= nil then 
		if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() and params.attacker:IsRealHero() and params.attacker ~= self:GetParent() then
			PlayerResource:ModifyGold( params.attacker:GetPlayerOwnerID(), self.hero_bonus/2, false, DOTA_ModifyGold_Unspecified )	
			self:PlayEffects1(params.attacker)
			self:PlayEffects2(params.attacker, (self.hero_bonus/2) )	
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