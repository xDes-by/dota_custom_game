ability_npc_boss_plague_squirrel_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell3", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell3_effect", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell3", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_plague_squirrel_spell3:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_boss_plague_squirrel_spell3", {duration = self:GetSpecialValueFor("duration")})
	
	local carges = self:GetSpecialValueFor("carges")
	local radius = self:GetSpecialValueFor("radius")
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * radius
	local rotation_rate = 360 / carges
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ability_npc_boss_plague_squirrel_spell3_effect",{duration = 0.5 * carges} )
	self.points = {}
				
	for i = 1, carges do
		local rand = RandomInt(0,50)
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, rand), line_pos)
		local dummy = CreateUnitByName("npc_dummy_unit", line_pos, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		dummy:AddNewModifier(self:GetCaster(),self,"modifier_dummy",{} )
		dummy:AddNewModifier(self:GetCaster(),self,"modifier_kill",{duration = 1} )
		local position = dummy:GetAbsOrigin()
		table.insert(self.points, position)
	end	
		
	Timers:CreateTimer(0.1, function()
		self:Move(self:GetCaster())
	end)	
end


function ability_npc_boss_plague_squirrel_spell3:Move()	
	move_point = self.points[RandomInt(1,#self.points)]
		if move_point ~= nil then
			Timers:CreateTimer(0.1, function()
				if not self:GetCaster():HasModifier("modifier_ability_npc_boss_plague_squirrel_spell3_effect") then return nil end
				local flDist = (self:GetCaster():GetAbsOrigin() - move_point):Length2D()
					if flDist > 150 then 
						self:GetCaster():MoveToPosition(move_point)
					else
						for i, point in ipairs( self.points ) do
							if move_point == point then
								table.remove( self.points, i )
								self:Move(self:GetCaster())
								return nil
							end
						end
					end
				return 0.1
			end)
		end
	if #self.points == 0 then
		self:GetCaster():RemoveModifierByName("modifier_ability_npc_boss_plague_squirrel_spell3_effect")
	end
end

-------------------------------------------------------------------


modifier_ability_npc_boss_plague_squirrel_spell3_effect = class({})

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:IsHidden()	
	return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:IsPurgable()
	return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:CheckState()
	return {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:GetDisableAutoAttack()
	return 1
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:OnCreated()
if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor("damage") * 0.01
	self:StartIntervalThink(0.1)	
end

function modifier_ability_npc_boss_plague_squirrel_spell3_effect:OnIntervalThink()
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 200, true )
	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(),
		}
		
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 195, DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false)
	if #enemies > 0 then
		for _,enemy in pairs(enemies) do
			if enemy and not enemy:HasModifier("modifier_knockback") then
				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_knockback", {
					center_x			= self:GetParent():GetAbsOrigin()[1] + 1,
					center_y			= self:GetParent():GetAbsOrigin()[2] + 1,
					center_z			= self:GetParent():GetAbsOrigin()[3],
					duration			= 0.5 * (1 - enemy:GetStatusResistance()),
					knockback_duration	= 0.1 * (1 - enemy:GetStatusResistance()),
					knockback_distance	= 50,
					knockback_height	= 0,
					should_stun			= 0
				})
			
				damageTable.victim = enemy
				damageTable.damage = enemy:GetMaxHealth() * self.damage
				ApplyDamage( damageTable )
				enemy:AddNewModifier(self:GetParent(),self,"modifier_stunned",{ duration = self.stun_duration}	)
				

				enemy:EmitSound("Hero_Spirit_Breaker.Charge.Impact")
			end
		end
	end
end

-------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell3 = class({})

function modifier_ability_npc_boss_plague_squirrel_spell3:IsHidden()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:IsDebuff()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:IsPurgable()
    return false
end

function modifier_ability_npc_boss_plague_squirrel_spell3:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell3:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnCreated()
	self.effect_cast = ParticleManager:CreateParticle( "particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_passive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    EmitSoundOn("Hero_Hoodwink.Scurry.Cast", self:GetCaster())
    if IsClient() then
        return
    end
    self.startPos = self:GetParent():GetAbsOrigin()
    self.startPos.z = 0
    self.range = 0
    self.move_range = self:GetAbility():GetSpecialValueFor("move_range")
    self.persent_from_target_healt = self:GetAbility():GetSpecialValueFor("persent_from_target_healt") * 0.01
    self.damage_range = self:GetAbility():GetSpecialValueFor("damage_range")
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.dt = DAMAGE_TYPE_MAGICAL
    self:StartIntervalThink(0.03)
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnDestroy()
    if IsClient() then
        return
    end
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
    EmitSoundOn("Hero_Hoodwink.Scurry.End", self:GetCaster())
end

function modifier_ability_npc_boss_plague_squirrel_spell3:OnIntervalThink()
    self.endPos = self:GetParent():GetAbsOrigin()
    self.endPos.z = 0
    local curRange = (self.startPos - self.endPos):Length2D() + self.range
    if curRange > self.move_range then
        self.startPos = self.endPos
        local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
        for _,enemy in pairs(enemies) do
	        ApplyDamage({victim = enemy, 
            attacker = self:GetParent(), 
            damage = self.persent_from_target_healt * enemy:GetHealth(), 
            damage_type = self.dt,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
            
	        ApplyDamage({victim = enemy, 
            attacker = self:GetParent(), 
            damage = self.damage, 
            damage_type = self.dt,
            damage_flags = DOTA_DAMAGE_FLAG_NONE})
        end
        self.range = 0
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
        ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.damage_range, 0, 0 ) )
        ParticleManager:ReleaseParticleIndex( effect_cast )
        EmitSoundOn( "Hero_PrimalBeast.Trample", self:GetParent() )
    else
        self.range = curRange + self.range
    end
end

function modifier_ability_npc_boss_plague_squirrel_spell3:GetEffectName()
	return "particles/econ/items/hoodwink/hood_2021_blossom/hood_2021_blossom_scurry_aura.vpcf"
end

function modifier_ability_npc_boss_plague_squirrel_spell3:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ability_npc_boss_plague_squirrel_spell3:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}
end