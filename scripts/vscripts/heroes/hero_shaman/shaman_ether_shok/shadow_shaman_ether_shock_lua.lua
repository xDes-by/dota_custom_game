LinkLuaModifier("modifier_shadow_shaman_ether_shock_lua_handler",  "heroes/hero_shaman/shaman_ether_shok/shadow_shaman_ether_shock_lua", LUA_MODIFIER_MOTION_NONE)

shadow_shaman_ether_shock_lua = class({})

function shadow_shaman_ether_shock_lua:GetManaCost(iLevel)          
	if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int7")  ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function shadow_shaman_ether_shock_lua:OnSpellStart()
	local target = self:GetCursorTarget()
	count = self:GetSpecialValueFor("targets")
	damage = self:GetSpecialValueFor("damage")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int8")
	if abil ~= nil then 
	count = count + 7
	end
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int6")
	if abil ~= nil then 
	damage = damage + self:GetCaster():GetIntellect()
	end
	
	if target:TriggerSpellAbsorb(self) then return end

	self:GetCaster():EmitSound("Hero_ShadowShaman.EtherShock")
	
	if self:GetCaster():GetName() == "npc_dota_hero_shadow_shaman" and RollPercentage(75) then
		self:GetCaster():EmitSound("shadowshaman_shad_ability_ether_0"..RandomInt(1, 4))
	end

	-- Helper function in vscripts\internal\util.lua
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		500,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false
	)
	
	local enemies_hit = 0
	local attachment
	
	-- IMBAfication: Dramatic Entrance
	local dramatic_passive_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_shadow_shaman_ether_shock_lua_handler", self:GetCaster())
	
	for _, enemy in pairs(enemies) do
		if enemies_hit < count then
			enemy:EmitSound("Hero_ShadowShaman.EtherShock.Target")
			
			local ether_shock_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
			
			if enemies_hit % 2 == 1 then
				attachment = "attach_attack1"
			else
				attachment = "attach_attack2"
			end
			
			ParticleManager:SetParticleControlEnt(ether_shock_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, attachment, self:GetCaster():GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(ether_shock_particle, 1, enemy:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(ether_shock_particle)
			
			local damageTable = {
				victim 			= enemy,
				damage 			= damage,
				damage_type		= self:GetAbilityDamageType(),
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			}

			ApplyDamage(damageTable)
		
			enemies_hit = enemies_hit + 1
		end
	end
end

