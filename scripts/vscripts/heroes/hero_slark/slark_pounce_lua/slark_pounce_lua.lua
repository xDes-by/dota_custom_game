slark_pounce_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


function slark_pounce_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int6") ~= nil	then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end


function slark_pounce_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local position = target:GetOrigin()
	local origin = caster:GetOrigin()
	local radius = self:GetSpecialValueFor("pounce_radius")
	local duration = self:GetSpecialValueFor( "duration" )
	local damage = self:GetSpecialValueFor( "damage" )
	
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int9")	
			if abil ~= nil then 
				local ability = self:GetCaster():FindAbilityByName( "slark_dark_pact_lua" )
				if ability~=nil and ability:GetLevel()>=1 then
					ability:OnSpellStart()
				end
			end
	
		local bubbles_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_bubbles.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeam())
		ParticleManager:SetParticleControl(bubbles_pfx, 0, position)
		ParticleManager:SetParticleControl(bubbles_pfx, 1, Vector(radius,0,0))
		local bubbles_sec_pfc
	
		Timers:CreateTimer((duration/2), function()
		
			ParticleManager:DestroyParticle(bubbles_pfx, false)
			ParticleManager:ReleaseParticleIndex(bubbles_pfx)
			
				local bubbles_pfx = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash_group_b.vpcf", PATTACH_ABSORIGIN, caster, caster:GetTeam())
				ParticleManager:SetParticleControl(bubbles_pfx, 0, position)
				ParticleManager:SetParticleControl(bubbles_pfx, 1, Vector(radius,0,0))
				local bubbles_sec_pfc
			
			local blinkDistance = 50
			local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
			local blinkPosition = target:GetOrigin() + blinkDirection

			caster:SetOrigin( blinkPosition )
			FindClearSpaceForUnit( caster, blinkPosition, true )
			local sound_cast = "Hero_Slark.Pounce.Impact"
			EmitSoundOn( sound_cast, target )
		--	self:PlayEffects( origin )
			
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
            for _,enemy in pairs(enemies) do
			
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int8")	
			if abil ~= nil then 
			damage = caster:GetIntellect()
			end
			
			
			local damageTable = {victim = enemy,
				attacker = caster, 
				damage = damage,
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability =ability
                }
                ApplyDamage(damageTable)
				
				local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_slark_str7")	
				if abil ~= nil then 
				duration = 4
				end
		
				enemy:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_generic_stunned_lua", -- modifier name
				{ duration = duration })
		
            end		
		end)
end

--------------------------------------------------------------------------------
modifier_slark_pounce_lua = class({})
--------------------------------------------------------------------------------
function modifier_slark_pounce_lua:GetEffectName()
	return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf"
end

function modifier_slark_pounce_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slark_pounce_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end