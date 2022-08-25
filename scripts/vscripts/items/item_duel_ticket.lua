LinkLuaModifier("modifier_duel", 'items/item_duel_ticket.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_other", 'modifiers/modifier_other.lua', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zaebal", 'items/item_duel_ticket.lua', LUA_MODIFIER_MOTION_NONE)--если таргет откажется от дуэли, то его нельзя будет задуэлить еще 5 минут

item_duel_ticket = class({})
_G.remaining_duel = 0
--------------------------------------------------------------------------------
function item_duel_ticket:OnSpellStart()
	_G.remaining_duel = _G.time or 0	
	
	local connection = PlayerResource:GetConnectionState(self:GetCursorTarget():GetPlayerID())
		if connection ~= PlayerConection[self:GetCursorTarget():GetPlayerID()] then
			PlayerConection[self:GetCursorTarget():GetPlayerID()] = connection
			if connection == DOTA_CONNECTION_STATE_ABANDONED then return end
		end
	
	if self:GetCaster() ~= self:GetCursorTarget() and self:GetCursorTarget():IsAlive() and _G.remaining_duel <= 0 and not self:GetCursorTarget():HasModifier("modifier_zaebal") and self:GetCursorTarget():IsRealHero() then

	_G.remaining_duel = 60
	_G.time = _G.remaining_duel
	_G.caster = self:GetCaster()
	_G.target = self:GetCursorTarget()
	_G.point_caster = _G.caster:GetAbsOrigin()
	_G.point_target = _G.target:GetAbsOrigin()
		
		_G.caster:RemoveItem(self)
		_G.caster:AddNewModifier( _G.caster, nil, "modifier_other", {duration = 6} )
		
		_G.target:AddNewModifier( _G.target, nil, "modifier_other", {duration = 6} )

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(_G.target:GetPlayerID()),"ivint23", {time = 140})
	elseif self:GetCursorTarget():HasModifier("modifier_zaebal") then
		Notifications:Top(_G.caster:GetPlayerID(), {text = "#zaebal", duration=5, style={color="red",["font-size"]="50px"}, class="NotificationMessage"})	
	elseif _G.remaining_duel == 60 and self:GetCaster() ~= self:GetCursorTarget() then
		Notifications:TopToTeam(DOTA_TEAM_GOODGUYS, {text = "#duel_arena_lock", duration=5, style={color="red",["font-size"]="50px"}, class="NotificationMessage"})
	elseif not self:GetCursorTarget():HasModifier("modifier_zaebal") and self:GetCaster() ~= self:GetCursorTarget() then
		Notifications:TopToTeam(DOTA_TEAM_GOODGUYS, {text = "Timeout ".. _G.remaining_duel .. " second", duration=5, style={color="red",["font-size"]="50px"}, class="NotificationMessage"})
		else return
	end
end

function item_duel_ticket:net()
	_G.caster:RemoveModifierByName( "modifier_other")	
	_G.target:RemoveModifierByName( "modifier_other")
	_G.target:AddNewModifier( _G.target, nil, "modifier_zaebal", {duration = 300} )	
	_G.remaining_duel = 0
	_G.time = 0
end


function item_duel_ticket:yes()
	_G.caster:RemoveModifierByName( "modifier_other")
	_G.caster:AddNewModifier( _G.caster, nil, "modifier_other", {} )
	
	local part = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2.vpcf", PATTACH_ABSORIGIN, _G.caster) 
    _G.caster:EmitSound("Portal.Loop_Appear")
	StartAnimation(_G.caster, {duration = 2.5, activity = ACT_DOTA_TELEPORT})

	Timers:CreateTimer({
    endTime = 2.5,
    callback = function()
	    ParticleManager:DestroyParticle( part, false )
        ParticleManager:ReleaseParticleIndex( part )
		_G.caster:StopSound("Portal.Loop_Appear")
     	local wws= "duel_1"
		local ent = Entities:FindByName( nil, wws) 
		local point = ent:GetAbsOrigin() 
		_G.caster:SetAbsOrigin( point )
		FindClearSpaceForUnit(_G.caster, point, false)
		_G.caster:Stop()
				_G.caster:AddNewModifier( _G.caster, nil, "modifier_duel", {} )
				GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
				PlayerResource:GetSelectedHeroEntity(_G.caster:GetPlayerID()):SetTeam(DOTA_TEAM_CUSTOM_1)
				PlayerResource:SetCustomTeamAssignment(_G.caster:GetPlayerID(),DOTA_TEAM_CUSTOM_1)
				start_duel(_G.caster,_G.target)

	local playerID1 = _G.caster:GetPlayerOwnerID()	
	PlayerResource:SetCameraTarget(playerID1, _G.caster)

	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(playerID1, nil)
	end)

	end})

--------------------------------------------------------------------------------------------------	
--------------------------------------------------------------------------------------------------	
	
	_G.target:RemoveModifierByName( "modifier_other")
	_G.target:AddNewModifier( _G.target, nil, "modifier_other", {} )
	
	local part = ParticleManager:CreateParticle("particles/econ/events/fall_major_2015/teleport_end_fallmjr_2015_lvl2.vpcf", PATTACH_ABSORIGIN, _G.target) 
   	_G.target:EmitSound("Portal.Loop_Appear")
	StartAnimation(_G.target, {duration = 2.5, activity = ACT_DOTA_TELEPORT})

	Timers:CreateTimer({
    endTime = 2.5,
    callback = function()
	    ParticleManager:DestroyParticle( part, false )
        ParticleManager:ReleaseParticleIndex( part )
		_G.target:StopSound("Portal.Loop_Appear")		
     	local wws= "duel_2"
		local ent = Entities:FindByName( nil, wws) 
		local point = ent:GetAbsOrigin() 
		_G.target:SetAbsOrigin( point )
		FindClearSpaceForUnit(_G.target, point, false)
		_G.target:Stop()

				_G.target:AddNewModifier( _G.target, nil, "modifier_duel", {} )
				GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
				PlayerResource:GetSelectedHeroEntity(_G.target:GetPlayerID()):SetTeam(DOTA_TEAM_CUSTOM_2)
				PlayerResource:SetCustomTeamAssignment(_G.target:GetPlayerID(),DOTA_TEAM_CUSTOM_2)

	local playerID2 = _G.target:GetPlayerOwnerID()	
	PlayerResource:SetCameraTarget(playerID2, _G.target)

	Timers:CreateTimer(0.1, function()
		PlayerResource:SetCameraTarget(playerID2, nil)
	end)
	end})
end
 
function start_duel()
local count = 4 
	_G.caster:EmitSound("Hero_Grimstroke.InkSwell.Target")
	_G.target:EmitSound("Hero_Grimstroke.InkSwell.Target")
	Timers:CreateTimer(0, function()
		count = count - 1
			if count > 0 then 
				Notifications:TopToTeam(DOTA_TEAM_CUSTOM_1, {text = count, duration=1, style={color="red",["font-size"]="300px"}, class="NotificationMessage"})
				Notifications:TopToTeam(DOTA_TEAM_CUSTOM_2, {text = count, duration=1, style={color="red",["font-size"]="300px"}, class="NotificationMessage"})
				EmitSoundOnClient("Hero_Grimstroke.InkSwell.Target", _G.caster:GetPlayerOwner())
				EmitSoundOnClient("Hero_Grimstroke.InkSwell.Target", _G.target:GetPlayerOwner())
			end	
			if count == 0 then
				Notifications:TopToTeam(DOTA_TEAM_CUSTOM_1, {text = "FIGHT", duration=1, style={color="red",["font-size"]="300px"}, class="NotificationMessage"})
				Notifications:TopToTeam(DOTA_TEAM_CUSTOM_2, {text = "FIGHT", duration=1, style={color="red",["font-size"]="300px"}, class="NotificationMessage"})
				_G.caster:RemoveModifierByName( "modifier_other")	
				_G.target:RemoveModifierByName( "modifier_other")	
				EmitSoundOnClient("Hero_LegionCommander.Duel.FP", _G.caster:GetPlayerOwner())
				EmitSoundOnClient("Hero_LegionCommander.Duel.FP", _G.target:GetPlayerOwner())
			end
		return 1.0
	end)
end

--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------

modifier_duel = class({})

function modifier_duel:IsHidden()
    return false
end

function modifier_duel:IsPurgable()
    return false
end

function modifier_duel:RemoveOnDeath()
    return true
end

function modifier_duel:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
	}
	return funcs
end

function modifier_duel:CheckState()
	return {
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
end

function modifier_duel:GetMinHealth()
	return 1
end

function modifier_duel:OnTakeDamage(keys)
	local damage = keys.damage
	local parent = self:GetParent()
	local health = self:GetParent():GetHealth()
	local attacker = keys.attacker
	local target = keys.unit
	
	if attacker:GetTeamNumber() ~= parent:GetTeamNumber() and parent == target and health <= 1 then
			if parent == _G.target then
				if _G.caster:HasModifier("modifier_duel") then
					_G.caster:RemoveModifierByName( "modifier_duel")
					_G.caster:AddNewModifier( _G.caster, nil, "modifier_invulnerable", {duration = 3} )
						StartAnimation(_G.caster, {duration = 2.5, activity = ACT_DOTA_VICTORY})
						_G.caster:EmitSound("Hero_LegionCommander.Duel.Victory")
						local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, _G.caster)
							Timers:CreateTimer(3, function()
								_G.caster:SetHealth( _G.caster:GetMaxHealth() )
								_G.caster:SetMana( _G.caster:GetMaxMana() )
								_G.caster:SetAbsOrigin( _G.point_caster )
								FindClearSpaceForUnit(_G.caster, _G.point_caster, false)
								_G.caster:Stop()
								local id2 = _G.caster:GetPlayerID()
									PlayerResource:SetCameraTarget( id2 , _G.caster)
									Timers:CreateTimer(0.1, function()
									PlayerResource:SetCameraTarget( id2 , nil)
								end)
								StartAnimation(_G.target, {duration = 2.5, activity = ACT_DOTA_DISABLED})
								_G.target:RemoveModifierByName( "modifier_duel")
								_G.target:SetHealth( _G.target:GetMaxHealth() )
								_G.target:SetMana( _G.target:GetMaxMana() )
								_G.target:SetAbsOrigin( _G.point_target )
								FindClearSpaceForUnit(_G.target, _G.point_target, false)
								local id1 = _G.target:GetPlayerID()
									PlayerResource:SetCameraTarget( id1 , _G.target)
									Timers:CreateTimer(0.1, function()
										PlayerResource:SetCameraTarget( id1 , nil)
									end)
								end)
						end		
					end
		if parent == _G.caster then
		if _G.target:HasModifier("modifier_duel") then
			_G.target:RemoveModifierByName( "modifier_duel")
			_G.target:AddNewModifier( _G.target, nil, "modifier_invulnerable", {duration = 3} )
				StartAnimation(_G.target, {duration = 2.5, activity = ACT_DOTA_VICTORY})
				_G.target:EmitSound("Hero_LegionCommander.Duel.Victory")
				local duel_victory_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_ABSORIGIN_FOLLOW, _G.target)
					Timers:CreateTimer(3, function()	
						_G.target:SetHealth( _G.target:GetMaxHealth() )
						_G.target:SetMana( _G.target:GetMaxMana() )
						_G.target:SetAbsOrigin( _G.point_target )
						FindClearSpaceForUnit(_G.target, _G.point_target, false)
						_G.target:Stop()
						local id2 = _G.target:GetPlayerID()
								PlayerResource:SetCameraTarget(id2, _G.target)
							Timers:CreateTimer(0.1, function()
								PlayerResource:SetCameraTarget(id2, nil)
							end)
						StartAnimation(_G.caster, {duration = 2.5, activity = ACT_DOTA_DISABLED})
						_G.caster:RemoveModifierByName( "modifier_duel")	
						_G.caster:SetHealth( _G.caster:GetMaxHealth() )
						_G.caster:SetMana( _G.caster:GetMaxMana() )
						_G.caster:SetAbsOrigin( _G.point_caster )
						FindClearSpaceForUnit(_G.caster, _G.point_caster, false)
						local id1 = _G.caster:GetPlayerID()
								PlayerResource:SetCameraTarget(id1, _G.caster)
							Timers:CreateTimer(0.1, function()
								PlayerResource:SetCameraTarget(id1, nil)
							end)
					end)
				end
			end

	PlayerResource:GetSelectedHeroEntity(_G.target:GetPlayerID()):SetTeam(DOTA_TEAM_GOODGUYS)
	PlayerResource:SetCustomTeamAssignment(_G.target:GetPlayerID(),DOTA_TEAM_GOODGUYS)

	PlayerResource:GetSelectedHeroEntity(_G.caster:GetPlayerID()):SetTeam(DOTA_TEAM_GOODGUYS)
	PlayerResource:SetCustomTeamAssignment(_G.caster:GetPlayerID(),DOTA_TEAM_GOODGUYS)

    Timers:CreateTimer("remaining_duel", {
        useGameTime = true,
        endTime = 0,
        callback = function()
	_G.time = _G.time - 1
		if _G.time <= 0  then Timers:RemoveTimer("remaining_duel") end
	return 1
	end})
end
end


function modifier_duel:GetModifierIncomingDamage_Percentage()
    return 150
end
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------


modifier_zaebal = class({})

function modifier_zaebal:IsHidden()
    return false
end

function modifier_zaebal:IsPurgable()
    return false
end

function modifier_zaebal:RemoveOnDeath()
    return false
end