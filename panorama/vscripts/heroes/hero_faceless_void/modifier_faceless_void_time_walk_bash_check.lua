modifier_faceless_void_time_walk_bash_check = class({})

function modifier_faceless_void_time_walk_bash_check:OnCreated()
	if IsClient() then return end
	self:StartIntervalThink(0.1)
end

function modifier_faceless_void_time_walk_bash_check:OnIntervalThink()
	local parent = self:GetParent()
	if not parent or parent:IsNull() then self:Destroy() end
	if parent:HasModifier("modifier_faceless_void_time_walk") then return end
	
	local ability = self:GetAbility()
	local bash_ability = parent:FindModifierByName("modifier_faceless_void_time_lock_lua")
	
	if ability and bash_ability then
		local targets = FindUnitsInRadius(parent:GetTeamNumber(), 
			parent:GetAbsOrigin(), 
			nil, 
			ability:GetSpecialValueFor("radius_scepter"), 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_NONE, 
			FIND_ANY_ORDER, 
			false)
		
		for _,enemy in pairs(targets) do
			bash_ability:MakeBash(enemy)
		end
	end
	self:Destroy()
end
