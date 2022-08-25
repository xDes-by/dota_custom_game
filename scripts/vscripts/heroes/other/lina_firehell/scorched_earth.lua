
function ScorchedEarthCheck( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	if target:GetOwner() == caster or target == caster then
		ability:ApplyDataDrivenModifier(caster, target, modifier, {})
	end

end

-- Stops the sound from playing
function StopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end