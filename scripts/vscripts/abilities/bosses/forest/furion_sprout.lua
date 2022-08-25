furion_sprout_lua = class({})

function furion_sprout_lua:OnSpellStart()
	self.duration = self:GetSpecialValueFor( "duration" )
	self.radius = self:GetSpecialValueFor( "radius" )
	self.vision_range = self:GetSpecialValueFor( "vision_range" )

	local hTarget = self:GetCursorTarget()
	if hTarget == nil or ( hTarget ~= nil and ( not hTarget:TriggerSpellAbsorb( self ) ) ) then
		local vTargetPosition = nil
		if hTarget ~= nil then 
			vTargetPosition = hTarget:GetOrigin()
		else
			vTargetPosition = self:GetCursorPosition()
		end

		local r = self.radius 
		local c = math.sqrt( 2 ) * 0.5 * r 
		local x_offset = { -r, -c, 0.0, c, r, c, 0.0, -c }
		local y_offset = { 0.0, c, r, c, 0.0, -c, -r, -c }

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		for i = 1,8 do
			CreateTempTree( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), self.duration )
		end

		for i = 1,8 do
			ResolveNPCPositions( vTargetPosition + Vector( x_offset[i], y_offset[i], 0.0 ), 64.0 ) --Tree Radius
		end

		AddFOWViewer( self:GetCaster():GetTeamNumber(), vTargetPosition, self.vision_range, self.duration, false )
		EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.Sprout", self:GetCaster() )

	
		if IsServer() then 
			Timers:CreateTimer(self.duration, function()
				for i =1, 3 do
					local creep = CreateUnitByName( "npc_forest_boss_minion", vTargetPosition + RandomVector(RandomInt(150, 350)), true, nil, nil, DOTA_TEAM_BADGUYS )
					creep:AddNewModifier(creep, nil, "modifier_kill", {duration = 10})
					add_modifier(creep)
				end	
			end)
		end	
	end
end

LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function add_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end	
end	