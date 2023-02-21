if diff_wave == nil then
	_G.diff_wave = class({})
end

function diff_wave:InitGameMode()
	if GetMapName() == "turbo" then
	self.wavedef = "Easy"
	self.rating_scale = 0
	self.respawn = 60
	end
	
	if GetMapName() == "normal" then
	self.wavedef = "Normal"
	self.rating_scale = 1
	self.respawn = 120
	end
	
	if GetMapName() == "hard" then
	self.wavedef = "Hard"
	self.rating_scale = 2
	self.respawn = 120
	end
	
	if GetMapName() == "ultra" then
	self.wavedef = "Ultra"
	self.rating_scale = 3
	self.respawn = 120
	end
	
	if GetMapName() == "insane" then
	self.wavedef = "Insane"
	self.rating_scale = 4
	self.respawn = 120
	end
end 