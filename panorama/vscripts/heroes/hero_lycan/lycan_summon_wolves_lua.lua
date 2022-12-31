lycan_summon_wolves_lua = class({})

-------------------------

function lycan_summon_wolves_lua:KillWolves()
	local targets = self.wolves or {}
	for _, unit in pairs(targets) do
		if unit and IsValidEntity(unit) and unit:IsAlive() then
			unit:ForceKill(false)
		end
	end
end

function lycan_summon_wolves_lua:OnSpellStart()
	local caster = self:GetCaster()

	-- Gets the number of wolves to summon
	local wolfCount = self:GetSpecialValueFor("wolf_count")

	-- Positioning the wolf spawn
	local wolfDurationBuff = self:GetSpecialValueFor("wolf_duration")
	
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local frontPosition = origin + fv * 200
	local wolf_index = self:GetSpecialValueFor("wolf_index")

	--Wolf position calculation
	local offset = Vector(100, 0, 0)            --distance between wolves at local origin
	local angle = VectorToAngles(fv)            --calculate absolute angle
	local angle_offset = angle.y - 90           --normal of given angle
 
	--Y angle is yaw, don't ask me why
	local vector_rotate = RotatePosition(Vector(0, 0, 0), QAngle(0, angle_offset, 0), offset)

	--Calculate the position of the left-most wolf
	if wolfCount % 2 == 0 then 
		--Offset by half wolf distance between them and then calculate the left most wolf
		frontPosition = frontPosition - 0.5 * vector_rotate + (vector_rotate * (wolfCount / 2))
	else
		-- 1 wolf is center at frontPosition, calculate left most wolf
		frontPosition = frontPosition + (vector_rotate * math.floor(wolfCount/2))
	end 

	-- Kill previous wolves and initialize
	self:KillWolves()
	self.wolves = {}
	
	-- Create wolves
	for i=1, wolfCount do 
		local hWolf = CreateUnitByName("npc_dota_lycan_wolf" .. wolf_index, frontPosition, true, caster, caster, caster:GetTeamNumber())
		if hWolf ~= nil then
			hWolf:SetControllableByPlayer(caster:GetPlayerID(), false)
			hWolf:SetForwardVector(fv)
			table.insert(self.wolves, hWolf)

			hWolf:SetBaseMaxHealth(hWolf:GetBaseMaxHealth() + self:GetSpecialValueFor("bonus_health"))
			hWolf:SetBaseDamageMin(hWolf:GetBaseDamageMin() + self:GetSpecialValueFor("bonus_damage"))
			hWolf:SetBaseDamageMax(hWolf:GetBaseDamageMax() + self:GetSpecialValueFor("bonus_damage"))

			hWolf:AddNewModifier(caster, self, "modifier_kill", {duration = wolfDurationBuff})

			hWolf:AddAbility("summon_buff")

			-- Particles
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_cast.vpcf", PATTACH_CUSTOMORIGIN, caster )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			ParticleManager:ReleaseParticleIndex(  ParticleManager:CreateParticle( "particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hWolf ) )
		end
		--Put wolves 1 offset right of each other
		frontPosition = frontPosition - vector_rotate   
	end

	--not heard on heroes which are not lycan
	EmitSoundOnLocationWithCaster(origin, "Hero_Lycan.SummonWolves", caster)

end


