function catch(event)
	local caster = event.caster
	local target = event.target
	local item = event.ability 
	local hero = caster:GetOwner()
	local playerID = hero:GetPlayerID()			
	local target_name = target:GetUnitName()		
		if target_name == "belka" then
			target:SetModelScale(0.01)
			target:ForceKill(false)
			UTIL_Remove(item)
			caster:EmitSound("tutorial_gate_open_metal")
			caster:AddItemByName("item_kletka_off")				
	end	
end
