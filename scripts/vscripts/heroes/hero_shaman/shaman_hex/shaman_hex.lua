shaman_hex = class({})
LinkLuaModifier( "modifier_thinker", "heroes/hero_shaman/shaman_hex/shaman_hex", LUA_MODIFIER_MOTION_NONE )

function shaman_hex:GetManaCost(iLevel)        
	if self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int7")    ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
    end
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function shaman_hex:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- self:GetAbility() source
		"modifier_thinker", -- modifier name
		{ duration = duration } -- kv
	)
end
------------------------------------------------------------------------------------------------

modifier_thinker = class({})

function modifier_thinker:IsHidden()
    return true
end

function modifier_thinker:OnCreated()
time_spawn = 0.5

local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int9")
	if abil ~= nil then 
	time_spawn = 0.25
	end
    self:StartIntervalThink(time_spawn)
end

function modifier_thinker:OnIntervalThink()
if not IsServer() then return end
	local point = self:GetCaster():GetAbsOrigin()
		local spawn_hex = CreateUnitByName( "npc_shaman_hex", point + RandomVector( RandomFloat( 150, 150 )), true, nil, nil, DOTA_TEAM_GOODGUYS )
		spawn_hex:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		spawn_hex:SetOwner(self:GetCaster())
		spawn_hex:AddNewModifier(spawn_hex, nil, "modifier_hex_ampl_spirit",  { }) 	
		self:GetCaster():EmitSound("Hero_ShadowShaman.Hex.Target")		
end


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

hex_mine = class({})

function hex_mine:IsHidden()
    return true
end

function hex_mine:GetIntrinsicModifierName()
    return "modifier_hex_mine"
end

-------------------------------------------------------------------------

LinkLuaModifier("modifier_hex_mine", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)

modifier_hex_mine = modifier_hex_mine or class({})

function modifier_hex_mine:OnCreated()
    local particle = "particles/units/heroes/hero_techies/techies_land_mine.vpcf"
    local particle_mine_fx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(particle_mine_fx, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_mine_fx, 3, self:GetCaster():GetAbsOrigin())
    self:AddParticle(particle_mine_fx, false, false, -1, false, false)

    self:StartIntervalThink(0.03)
end

function modifier_hex_mine:OnIntervalThink()
    if IsServer() then
        local sound = "Hero_Techies.LandMine.Detonate"
        local center = self:GetCaster():GetAbsOrigin()

        if not self:GetCaster():IsAlive() then
            self:Destroy()
        end
		
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
        
		local player = self:GetCaster():GetOwner()

		local hex_abil = player:FindAbilityByName("shaman_hex")
		local hex_level = hex_abil:GetLevel()
		local try_damage = self.damage * hex_level
		
		local abil = player:FindAbilityByName("npc_dota_hero_shadow_shaman_agi6")             
		if abil ~= nil then 
		try_damage = try_damage + player:GetAgility()
		end
		
		if player:FindAbilityByName("npc_dota_hero_shadow_shaman_int_last") ~= nil then
			try_damage = try_damage + player:GetIntellect()*0.5
	    end
		if player:FindAbilityByName("special_bonus_unique_npc_dota_hero_shadow_shaman_int50") ~= nil then
			try_damage = try_damage * 2
	    end		
		if player:FindAbilityByName("special_bonus_unique_npc_dota_hero_shadow_shaman_str50") ~= nil then
			try_damage = try_damage + player:GetMaxHealth() * 0.05
	    end	
        local activation_radius = self:GetAbility():GetSpecialValueFor("activation_radius")
        local damage_radius = self:GetAbility():GetSpecialValueFor("damage_radius")

        local nearbyEnemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
                                                self:GetCaster():GetAbsOrigin(),
                                                nil,
                                                activation_radius,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_ALL,
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                                FIND_ANY_ORDER,
                                                false)


        if #nearbyEnemies > 0 then
            EmitSoundOn(sound, player)

            local particle_explosion = "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf"
            local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, self:GetCaster())
            ParticleManager:SetParticleControl(particle_explosion_fx, 0, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 1, self:GetCaster():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(damage_radius, 1, 1))
            ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

            local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),
                                          self:GetCaster():GetAbsOrigin(),
                                          nil,
                                          damage_radius,
                                          DOTA_UNIT_TARGET_TEAM_ENEMY,
                                          DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                                          DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                                          FIND_ANY_ORDER,
                                          false)

            for _,enemy in pairs(enemies) do
                local distance = (self:GetCaster():GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D()
                local damageTable = {victim = enemy,
                                     attacker = self:GetCaster(), 
                                     damage = try_damage,
                                     damage_type = DAMAGE_TYPE_MAGICAL,
                }

                ApplyDamage(damageTable)
	
				local abil = player:FindAbilityByName("npc_dota_hero_shadow_shaman_str7")	
				if abil ~= nil then 
				enemy:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- self:GetAbility() source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = 0.3 } -- kv
				)
				end
            end
            self:GetCaster():ForceKill(false)
            self:Destroy()
        end
    end    
end

function modifier_hex_mine:CheckState()
    local state = {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
    }
    return state
end


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

LinkLuaModifier( "modifier_hex_ampl_spirit", "heroes/hero_shaman/shaman_hex/shaman_hex.lua", LUA_MODIFIER_MOTION_NONE )

modifier_hex_ampl_spirit = class({})

function modifier_hex_ampl_spirit:IsHidden()
	return false
end

function modifier_hex_ampl_spirit:IsPurgable()
	return false
end

function modifier_hex_ampl_spirit:OnCreated()
if IsServer() then
    local player = self:GetCaster():GetOwner()
	spell_amp_hex = player:GetSpellAmplification(false) * 100
	end
end

function modifier_hex_ampl_spirit:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_hex_ampl_spirit:GetModifierSpellAmplify_Percentage()
	return spell_amp_hex
end