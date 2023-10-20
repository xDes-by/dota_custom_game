modifier_dummy_damage = class({})

function modifier_dummy_damage:IsHidden()
    return true
end

function modifier_dummy_damage:IsPurgable()
    return false
end

function modifier_dummy_damage:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_dummy_damage:CheckState()
	return {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	}
end

_G.PlayerDamagePhys = {}
_G.PlayerDamageMag = {}
_G.PlayerDamagePure = {}
_G.PlayerDamageTimer = {}

function modifier_dummy_damage:OnTakeDamage(event)
	attacker = event.attacker
	if event.unit:GetUnitName() == "npc_dota_hero_target_dummy" and (attacker:IsRealHero() or attacker:IsConsideredHero() or attacker:GetOwner() ~= nil) then
		local dummyEventDamage = event.damage
		event.damage = 0

		if attacker:GetOwner() ~= nil and not attacker:GetOwner():IsPlayerController() then
			attacker = attacker:GetOwner()
		end

		local attackerID = attacker:GetPlayerID()

		if _G.PlayerDamagePhys[attackerID] == nil then
			_G.PlayerDamagePhys[attackerID] = 0
		end
		
		if _G.PlayerDamageMag[attackerID] == nil then
			_G.PlayerDamageMag[attackerID] = 0
		end
		
		if _G.PlayerDamagePure[attackerID] == nil then
			_G.PlayerDamagePure[attackerID] = 0
		end
		
		if event.damage_type == 1 then
			_G.PlayerDamagePhys[attackerID] = _G.PlayerDamagePhys[attackerID] + dummyEventDamage
		end
		
		if event.damage_type == 2 then
			_G.PlayerDamageMag[attackerID] = _G.PlayerDamageMag[attackerID] + dummyEventDamage
		end
		
		if event.damage_type == 4 then
			_G.PlayerDamagePure[attackerID] = _G.PlayerDamagePure[attackerID] + dummyEventDamage
		end
		
		if _G.PlayerDamageTimer[attackerID] == nil then
		local name = attacker:GetUnitName()
		name = name:gsub("%npc_dota_hero_", "")
		name = name:gsub("%_", " ")

		GameRules:SendCustomMessage("START DPS for <span color='red'>"..name.."</span>! You have 10 seconds...", attackerID, 0)
		_G.PlayerDamageTimer[attackerID] = Timers:CreateTimer(10, function()
			local total = _G.PlayerDamagePhys[attackerID] + _G.PlayerDamageMag[attackerID] + _G.PlayerDamagePure[attackerID]
	
			GameRules:SendCustomMessage("<span color='gold'>Total Damage (<span color='red'>"..name.."</span>): " .. FormatLongNumber(math.floor(total)) .. "</span>", attackerID, 0)
			GameRules:SendCustomMessage("<span color='green'>Physical (<span color='red'>"..name.."</span>): " .. FormatLongNumber(math.floor(_G.PlayerDamagePhys[attackerID])) .. "</span>", attackerID, 0)
			GameRules:SendCustomMessage("<span color='blue'>Magical (<span color='red'>"..name.."</span>): " .. FormatLongNumber(math.floor(_G.PlayerDamageMag[attackerID])) .. "</span>", attackerID, 0)
			GameRules:SendCustomMessage("<span color='purple'>Pure (<span color='red'>"..name.."</span>): " .. FormatLongNumber(math.floor(_G.PlayerDamagePure[attackerID])) .. "</span>", attackerID, 0)
			
			GameRules:SendCustomMessage("<span color='gold'>DPS (<span color='red'>"..name.."</span>): " .. FormatLongNumber(math.floor(total/10)) .. " in second</span>" , attackerID, 0)

			_G.PlayerDamagePhys[attackerID] = 0
			_G.PlayerDamageMag[attackerID] = 0
			_G.PlayerDamagePure[attackerID] = 0
			
			-- Stop(attacker)

			Timers:CreateTimer(5.0, function()
				Timers:RemoveTimer(_G.PlayerDamageTimer[attackerID])
					_G.PlayerDamageTimer[attackerID] = nil
				end)
			end)
		end

		return false
	end
end

function FormatLongNumber(n)
  if n >= 10^9 then
        return string.format("%.2fb", n / 10^9)
    elseif n >= 10^6 then
        return string.format("%.2fm", n / 10^6)

    elseif n >= 10^3 then
        return string.format("%.2fk", n / 10^3)
    else
        return tostring(n)
    end
end


function Stop(attacker)
	ExecuteOrderFromTable({
		UnitIndex = attacker:entindex(),
		OrderType = DOTA_UNIT_ORDER_STOP,
	})
end