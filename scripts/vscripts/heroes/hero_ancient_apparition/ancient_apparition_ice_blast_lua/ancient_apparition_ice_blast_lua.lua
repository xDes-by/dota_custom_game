LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ancient_apparition_ice_blast_lua_slow", "heroes/hero_ancient_apparition/ancient_apparition_ice_blast_lua/ancient_apparition_ice_blast_lua.lua", LUA_MODIFIER_MOTION_NONE )

ancient_apparition_ice_blast_lua = class({})

function ancient_apparition_ice_blast_lua:GetIntrinsicModifierName()
	return "modifier_ancient_apparition_ice_blast_lua"
end

-------------------------------------------------------------------------------

modifier_ancient_apparition_ice_blast_lua = class({})

function modifier_ancient_apparition_ice_blast_lua:IsHidden()
	return true
end

function modifier_ancient_apparition_ice_blast_lua:IsPurgable()
	return false
end

function modifier_ancient_apparition_ice_blast_lua:OnCreated()

end

function modifier_ancient_apparition_ice_blast_lua:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_ancient_apparition_ice_blast_lua:OnAttackLanded( params )
	local target = params.target
	if params.attacker ~= self:GetParent() then return end
	
	self.hp = self:GetAbility():GetSpecialValueFor( "hp" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int_last") ~= nil then 
		self.hp = self.hp * 2
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int9") ~= nil then
		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,enemy in pairs(enemies) do
			self:AddDebuff(enemy)
		end
	else
		self:AddDebuff(target)
	end
end

function modifier_ancient_apparition_ice_blast_lua:AddDebuff(target)
	local caster = self:GetCaster()
	target:AddNewModifier(caster, self:GetAbility(), "modifier_ancient_apparition_ice_blast_lua_slow", {duration = self:GetAbility():GetSpecialValueFor( "duration" )})
	if not target:IsHero() and target:GetHealthPercent() <= self.hp and ancient(caster, target) then		
		
		if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_agi6") ~= nil then 
			local hp = target:GetHealth()
			params.attacker:Heal(hp, nil)
			SendOverheadEventMessage( params.attacker:GetPlayerOwner(), OVERHEAD_ALERT_HEAL , params.attacker, hp, nil )
		end

		target:Kill(nil, caster)
		
		-- self:GetParent():EmitSound("Hero_Ancient_Apparition.IceBlast.Target")
		local ice_blast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:ReleaseParticleIndex(ice_blast_particle)
	end
end

function ancient(caster, target)
	if caster:FindAbilityByName("npc_dota_hero_ancient_apparition_int10") ~= nil then
		return true
	end
	if target:IsAncient() then
		return false
	end
	return true
end

-----------------------------------------------------------------------------------
modifier_ancient_apparition_ice_blast_lua_slow = class({})

function modifier_ancient_apparition_ice_blast_lua_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnCreated()
	self.move_speed_slow = self:GetAbility():GetSpecialValueFor("slow") * (-1)
	self:StartIntervalThink(0.5)
	self:OnIntervalThink()
end

function modifier_ancient_apparition_ice_blast_lua_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end

function modifier_ancient_apparition_ice_blast_lua_slow:OnIntervalThink()
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_ancient_apparition_int6") ~= nil then 	
		ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetCaster():GetIntellect()/2, damage_type = DAMAGE_TYPE_MAGICAL})
	end
	self.deal_dmg = self:GetParent():GetHealth()
end

function modifier_ancient_apparition_ice_blast_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow
end

