use_pets = use_pets or {players = {}}

function use_pets:RegisterHudListener( event_name, function_name )
	CustomGameEventManager:RegisterListener( event_name, function( _, kv ) 
		self[ function_name ]( self, kv )
	end )
end

function use_pets:InitGameMode()
	self:RegisterHudListener( "UsePet", "UsePet" )	
	self.player = {}
end

function use_pets:UsePet(t)
	local player = PlayerResource:GetPlayer(t.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	if hero:IsAlive() then
		local tab = CustomNetTables:GetTableValue("player_pets", tostring(t.PlayerID))
		print("i try use pet")
		if tab then
			if tab.pet ~= nil then
				print(tab.pet)
				local ability = hero:FindAbilityByName(tab.pet)
				ability:OnSpellStart()
			end
		end
	end
end