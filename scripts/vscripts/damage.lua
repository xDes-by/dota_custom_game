if damage == nil then
	damage = class({})
end

function damage:Init()
	local m = GameRules:GetGameModeEntity()
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(damage, 'OnEntityHurt'), self)
	ListenToGameEvent('entity_hurt', Dynamic_Wrap(self, 'OnEntityHurt'), self)
	damage.dmgtable = {}
	m:SetThink( "OnThink", self, "dmgTableEssentialTick", 0.1 )
end

function damage:OnThink()
	local list = HeroList:GetAllHeroes()
	for k,v in pairs(list) do 
		if not v:IsClone() and v:IsRealHero() and v:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			damage.dmgtable[v:entindex()] = damage.dmgtable[v:entindex()] or {}
			damage.dmgtable[v:entindex()]['heal'] = PlayerResource:GetHealing(v:GetPlayerID())
		end
	end
	CustomGameEventManager:Send_ServerToTeam(2, "dmgtable", damage.dmgtable)
	return 0.1
end

function damage:OnEntityHurt(t)
	local attacker_index = t.entindex_attacker_const
	local victim_index = t.entindex_victim_const
	if attacker_index and victim_index then
		local attacker = EntIndexToHScript(attacker_index)
		local victim = EntIndexToHScript(victim_index)
		if attacker and victim then
			if attacker.GetPlayerOwnerID then
				local attackerPlayerId = attacker:GetPlayerOwnerID()		
					if attackerPlayerId and attackerPlayerId >= 0 then
                        local hp = victim:GetHealth()
                        local dmg
						if attacker:IsAlive() then
							if not attacker:IsRealHero() and attacker:IsControllableByAnyPlayer() then
								t.entindex_attacker = PlayerResource:GetSelectedHeroEntity(attacker:GetMainControllingPlayer()):entindex()
							else
								t.entindex_attacker = PlayerResource:GetSelectedHeroEntity(attacker:GetPlayerID()):entindex()
							end
							 if t.damagetype_const == 2 then	
								damage.dmgtable[t.entindex_attacker] = damage.dmgtable[t.entindex_attacker] or {}
								dmg = t.damage - victim:GetBaseMagicalResistanceValue() * t.damage
								if dmg > hp then
									dmg = hp	
								end
								damage.dmgtable[t.entindex_attacker]['mag'] = damage.dmgtable[t.entindex_attacker]['mag'] or 0
								damage.dmgtable[t.entindex_attacker]['mag'] = damage.dmgtable[t.entindex_attacker]['mag'] + dmg
								if victim:GetUnitName() == "npc_invoker_boss" then
									damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] or 0
									damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] + dmg
								end			
							elseif t.damagetype_const == 1 then
								damage.dmgtable[t.entindex_attacker] = damage.dmgtable[t.entindex_attacker] or {}
								if victim:IsBuilding() then
									dmg = t.damage
									if dmg > hp then
										dmg = hp
									end
									damage.dmgtable[t.entindex_attacker]['dmg'] = damage.dmgtable[t.entindex_attacker]['dmg'] or 0
									damage.dmgtable[t.entindex_attacker]['dmg'] = damage.dmgtable[t.entindex_attacker]['dmg'] + dmg
								else
									local armor = victim:GetPhysicalArmorValue(false)
									local factor = 1 - ((0.06 * armor) / (1 + 0.06 * math.abs(armor)))
									dmg = t.damage * factor
									if dmg > hp then
										dmg = hp
									end
									damage.dmgtable[t.entindex_attacker]['dmg'] = damage.dmgtable[t.entindex_attacker]['dmg'] or 0
									damage.dmgtable[t.entindex_attacker]['dmg'] = damage.dmgtable[t.entindex_attacker]['dmg'] + dmg								
									if victim:GetUnitName() == "npc_invoker_boss" then
										damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] or 0
										damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] + dmg
									end
								end
						   elseif t.damagetype_const == 4 then
								damage.dmgtable[t.entindex_attacker] = damage.dmgtable[t.entindex_attacker] or {}
								dmg = t.damage
								if dmg > hp then
									dmg = hp
								end
								damage.dmgtable[t.entindex_attacker]['pure'] = damage.dmgtable[t.entindex_attacker]['pure'] or 0
								damage.dmgtable[t.entindex_attacker]['pure'] = damage.dmgtable[t.entindex_attacker]['pure'] + dmg
								if victim:GetUnitName() == "npc_invoker_boss" then
									damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] or 0
									damage.dmgtable[t.entindex_attacker]['invo'] = damage.dmgtable[t.entindex_attacker]['invo'] + dmg
								end
							end
						end
					end	
				if victim and not victim:IsNull() and victim:IsRealHero() and victim:IsControllableByAnyPlayer() then
					local hp = victim:GetHealth()
					local dmg
					t.entindex_killed = PlayerResource:GetSelectedHeroEntity(victim:GetPlayerID()):entindex()
						if t.damagetype_const == 2 then	
							damage.dmgtable[t.entindex_killed] = damage.dmgtable[t.entindex_killed] or {}
                            dmg = t.damage - victim:GetBaseMagicalResistanceValue() * t.damage
                            if dmg > hp then
                                dmg = hp	
                            end
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] or 0
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] + dmg
                        elseif t.damagetype_const == 1 then
							damage.dmgtable[t.entindex_killed] = damage.dmgtable[t.entindex_killed] or {}
                            local armor = victim:GetPhysicalArmorValue(false)
                            local factor = 1 - ((0.06 * armor) / (1 + 0.06 * math.abs(armor)))
                            dmg = t.damage * factor
                            if dmg > hp then
                                dmg = hp
                            end
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] or 0
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] + dmg
                       elseif t.damagetype_const == 4 then
							damage.dmgtable[t.entindex_killed] = damage.dmgtable[t.entindex_killed] or {}
                            dmg = t.damage
                            if dmg > hp then
                                dmg = hp
                            end
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] or 0
							damage.dmgtable[t.entindex_killed]['tank'] = damage.dmgtable[t.entindex_killed]['tank'] + dmg
                        end	
					end
				end
			end
		end
	return true
end