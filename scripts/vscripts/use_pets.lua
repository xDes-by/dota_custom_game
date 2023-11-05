use_pets = use_pets or {players = {}}

function use_pets:RegisterHudListener( event_name, function_name )
	CustomGameEventManager:RegisterListener( event_name, function( _, kv ) 
		self[ function_name ]( self, kv )
	end )
end

function use_pets:InitGameMode()
	self:RegisterHudListener( "UsePet", "UsePet" )	
end

function use_pets:UsePet(t)
	print('UsePetLua')
	local player = PlayerResource:GetPlayer(t.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	if hero:IsAlive() and not hero:IsSilenced() then
		local tab = CustomNetTables:GetTableValue("player_pets", tostring(t.PlayerID))
		if tab then
			if tab.pet ~= nil then
				local ability = hero:FindAbilityByName(tab.pet)
				ability:OnSpellStart()
				DailyQuests:UpdateCounter(t.PlayerID, 35)
			end
		end
	end
end