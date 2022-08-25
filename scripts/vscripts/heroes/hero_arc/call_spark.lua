function call_spark(keys)
local caster = keys.caster
local ability = caster:FindAbilityByName( "ark_spark_lua")
	if ability~=nil and ability:GetLevel()>=1 then
		ability:OnSpellStart()
	end
end
