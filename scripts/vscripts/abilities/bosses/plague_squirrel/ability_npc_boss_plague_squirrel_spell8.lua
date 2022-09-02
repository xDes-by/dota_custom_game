LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell8", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_plague_squirrel_spell8_effect", "abilities/bosses/plague_squirrel/ability_npc_boss_plague_squirrel_spell8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "heroes/generic/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE )

ability_npc_boss_plague_squirrel_spell8 = class({})

function ability_npc_boss_plague_squirrel_spell8:OnSpellStart()
	local carges = self:GetSpecialValueFor("carges")
	local radius = self:GetSpecialValueFor("radius")
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * radius
	local rotation_rate = 360 / carges
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_ability_npc_boss_plague_squirrel_spell8_effect",{duration = 0.5 * carges} )
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



function ability_npc_boss_plague_squirrel_spell8:Move()	
	move_point = self.points[RandomInt(1,#self.points)]
		if move_point ~= nil then
			Timers:CreateTimer(0.1, function()
				if not self:GetCaster():HasModifier("modifier_ability_npc_boss_plague_squirrel_spell8_effect") then return nil end
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
		self:GetCaster():RemoveModifierByName("modifier_ability_npc_boss_plague_squirrel_spell8_effect")
	end
end

-----------------------------------------------------------------------------------------------------------------

modifier_ability_npc_boss_plague_squirrel_spell8_effect = class({})

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:IsHidden()	
	return false
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:IsPurgable()
	return false
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:CheckState()
	return {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	-- [MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetDisableAutoAttack()
	return 1
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetModifierMoveSpeedBonus_Constant()
	return self:GetAbility():GetSpecialValueFor("speed")
end

-- function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetOverrideAnimation()
	-- return ACT_DOTA_TAUNT
-- end

-- function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetEffectName()
	-- return "particles/units/heroes/hero_spirit_breaker/spirit_breaker_charge.vpcf"
-- end

-- function modifier_ability_npc_boss_plague_squirrel_spell8_effect:GetStatusEffectName()
	-- return "particles/status_fx/status_effect_charge_of_darkness.vpcf"
-- end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:OnCreated()
if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor("damage") * 0.01
	self:StartIntervalThink(0.1)	
end

function modifier_ability_npc_boss_plague_squirrel_spell8_effect:OnIntervalThink()
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