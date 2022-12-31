modifier_aegis = class({})

function modifier_aegis:IsHidden()
	return false
end

function modifier_aegis:GetTexture()
	return "item_aegis"
end

function modifier_aegis:IsPermanent()
	return true
end

function modifier_aegis:IsPurgable()
	return false
end

function modifier_aegis:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_aegis:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_RESPAWN,
	}

	return funcs
end

function modifier_aegis:OnCreated()
	if IsServer() then
       self.reincarnate_time = 5.0
       self.reincarnate_buff_time = 14.0
    end
end


function modifier_aegis:ReincarnateTime()
	local nPlayerID
	if self:GetParent().GetPlayerOwnerID then
		nPlayerID = self:GetParent():GetPlayerOwnerID()
	end

	if nPlayerID and GameMode:HasPlayerAbandoned(nPlayerID) then
		return nil
	end

	if nPlayerID and (not GameMode:IsPlayerDueling(nPlayerID)) then
		return self.reincarnate_time
	else
		return nil
	end
end


function modifier_aegis:OnStackCountChanged(old_stack_count)
	if not IsServer() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	local new_stack_count = self:GetStackCount()
	if parent:HasModifier("modifier_chc_mastery_revenge_2") and new_stack_count < old_stack_count then
		parent:FindModifierByName("modifier_chc_mastery_revenge_2"):IncrementStackCount()
	end
end

function modifier_aegis:OnDeath(keys)
	if not IsServer() then return end
	if keys.unit ~= self:GetParent() then return end

	local parent = self:GetParent()
	if not parent or parent:IsNull() then return end

	local player_id = parent:GetPlayerOwnerID()
	if Util:IsReincarnationWork(parent) or GameMode:IsPlayerDueling(player_id) then return end

	Util:RefreshAbilityAndItem(parent, {
		skeleton_king_reincarnation = true,
		item_refresher = true,
	})

	HeroBuilder:RegisterHeroDeath(player_id)

	-- Second Chance innate effect
	if parent:HasModifier("modifier_innate_second_chance") then
		parent:FindAbilityByName("innate_revenge"):SetActivated(false)
		parent:RemoveModifierByName("modifier_innate_second_chance")
		return nil
	end

	local current_stacks = self:GetStackCount()
	self:SetStackCount(current_stacks - 1)
	CustomGameEventManager:Send_ServerToAllClients("player_lose_aegis", { playerId = player_id, aegisCount = current_stacks - 1})
	
	self.aegis_respawn = true
end

function modifier_aegis:OnRespawn(event)
	local parent = self:GetParent()
	if not parent or parent:IsNull() or parent ~= event.unit then return end
	
	if not self.aegis_respawn then return end
	self.aegis_respawn = nil

	local respawn_timer_pfx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(respawn_timer_pfx, 1, Vector(0, 0, 0))
	ParticleManager:SetParticleControl(respawn_timer_pfx, 3, parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(respawn_timer_pfx)

	if parent:HasModifier("modifier_innate_revenge") then
		parent:FindModifierByName("modifier_innate_revenge"):Revengesplosion()
	end

	if parent:HasModifier("modifier_chc_mastery_revenge_1") then
		parent:FindModifierByName("modifier_chc_mastery_revenge_1"):Revengesplosion()
	end

	parent:AddNewModifier(parent, nil, "modifier_aegis_buff", {duration = self.reincarnate_buff_time})
	parent:Purge(false, true, false, true, true)

	local player_id = parent:GetPlayerOwnerID()
	if GameMode:IsPlayerInFountain(player_id) then
		parent:AddNewModifier(parent, nil, "modifier_hero_fighting_pve", {})
		parent:AddNewModifier(parent, nil, "modifier_hero_refreshing", {})
	end

	local origin = parent:GetAbsOrigin()
	local radius = 300

	local knockback_table = {
		should_stun = 1,
		knockback_duration = 0.5,
		duration = 1,
		knockback_distance = radius,
		knockback_height = 50,
		center_x = origin.x,
		center_y = origin.y,
		center_z = origin.z
	}

	local targets = FindUnitsInRadius(
		parent:GetTeam(), 
		origin, 
		nil, 
		radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	for _,unit in pairs(targets) do
		unit:AddNewModifier(parent, nil, "modifier_knockback", knockback_table)
	end

	local particle_name = "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_aoe.vpcf"
	local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, parent)
	ParticleManager:SetParticleControl(pfx, 0, origin)
	ParticleManager:SetParticleControl(pfx, 1, origin)
	ParticleManager:SetParticleControl(pfx, 2, Vector(700,0,0))
	ParticleManager:ReleaseParticleIndex(pfx)

	if self:GetStackCount() <= 0 then
		self:Destroy()
	end
end
