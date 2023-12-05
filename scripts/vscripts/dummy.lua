if Dummy == nil then
	Dummy = class({})
end

function Dummy:init()
    local point = Entities:FindByName(nil,"dummy_point"):GetAbsOrigin()
	self.Entity = CreateUnitByName( "npc_dota_hero_target_dummy", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	self.Entity:AddNewModifier(self.Entity, nil, "modifier_dummy_damage", {})
	
	local angle = self.Entity:GetAngles()
	local new_angle = RotateOrientation(angle, QAngle(0,0,0))
	self.Entity:SetAngles(new_angle[1], new_angle[2], new_angle[3])
	
	self.Entity:SetAbilityPoints( 0 )
	self.Entity:Hold()
	self.Entity:SetIdleAcquire( false )
	self.Entity:SetAcquisitionRange( 0 )
    self.Arrmor = 20
    self.MagicResistance = 25
    self.Entity:SetPhysicalArmorBaseValue(self.Arrmor)
    self.Entity:SetBaseMagicalResistanceValue(self.MagicResistance)

    CustomGameEventManager:Send_ServerToAllClients( "DummyPanoramaInit", { index = self.Entity:entindex() } )
    ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnected'), self)
    CustomGameEventManager:RegisterListener("DummyButtons",function(_, keys)
        self:DummyButtons(keys)
    end)
    if diff_wave.wavedef == "Easy" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_insane", {})
	end
	if diff_wave.wavedef == "Impossible" then
		self.Entity:AddNewModifier(self.Entity, nil, "modifier_impossible", {})
	end	
end

function Dummy:OnPlayerReconnected(t)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "DummyPanoramaInit", { index = self.Entity:entindex() } )
end

function Dummy:DummyButtons(t)
    if t.type == "MagicResistance" and t.value > 0 and self.MagicResistance == 100 then return end
    if t.type == "MagicResistance" and t.value < 0 and self.MagicResistance == 0 then return end
    if t.type == "Arrmor" and t.value < 0 and self.Arrmor == 0 then return end
    if t.type == "Arrmor" then
        self.Arrmor = self.Arrmor + t.value
    end
    if t.type == "MagicResistance" then 
        self.MagicResistance = self.MagicResistance + t.value
    end
    self.Entity:SetPhysicalArmorBaseValue(self.Arrmor)
    self.Entity:SetBaseMagicalResistanceValue(self.MagicResistance)
end