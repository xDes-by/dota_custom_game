modifier_health_mega = class({})

function modifier_health_mega:IsHidden()
	return false
end

function modifier_health_mega:GetTexture()
	return "item_aegis"
end

function modifier_health_mega:IsPermanent()
	return true
end

function modifier_health_mega:IsPurgable()
	return false
end


function modifier_health_mega:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_health_mega:OnCreated()
	if IsServer() then
       self.reincarnate_time = 0.1
    end
end

function modifier_health_mega:ReincarnateTime()
		local nPlayerID
    if self:GetParent().GetPlayerOwnerID then
       nPlayerID = self:GetParent():GetPlayerOwnerID()
    end

    if  nPlayerID  and PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_ABANDONED then
        return nil
    end
end

function modifier_health_mega:OnDeath(keys)
	if IsServer() then
	   if keys.unit == self:GetParent() then
          	  local hCaster = self:GetParent()
          	  local hAbility = self:GetAbility()
          	  local flReincarnateTime = self.reincarnate_time
		      Timers:CreateTimer({ endTime = flReincarnateTime, 
				    callback = function()
				    local nParticle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
					ParticleManager:SetParticleControl(nParticle, 1, Vector(0, 0, 0))
					ParticleManager:SetParticleControl(nParticle, 3, hCaster:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(nParticle)
					local point = keys.unit:GetAbsOrigin()
					keys.unit:SetAbsOrigin( point )
					FindClearSpaceForUnit(keys.unit, point, false)
					keys.unit:Stop()
					keys.unit:RespawnUnit()
				end})
			local nStackCount = self:GetStackCount()
			if nStackCount>=2 then
				self:SetStackCount(nStackCount-1)
				else
				self:Destroy()
			end
		end
	end
end