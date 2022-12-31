-- system to change attack types based on abilities and modifiers hero has
AttackCapabilityChanger = AttackCapabilityChanger or class({})


function AttackCapabilityChanger:Init()
	self.attack_capability_list = {}
end


function AttackCapabilityChanger:ProcessAttackCapabilityChangers()
	for entindex, hero in pairs(self.attack_capability_list) do
		if hero and not hero:IsNull() and not self:HasAttackCapabilityModifiers(hero) and hero.original_attack_capability then
			hero:SetAttackCapability(hero.original_attack_capability)
		end
	end
end


function AttackCapabilityChanger:RegisterAttackCapabilityChanger(hero)
	if not hero or not hero:IsMainHero() then return end
	self.attack_capability_list[hero:GetEntityIndex()] = hero
end


function AttackCapabilityChanger:HasAttackCapabilityModifiers(hero)
	if not hero or hero:IsNull() then return end
	for index, mod in ipairs(hero:FindAllModifiers()) do
		if ATTACK_TYPE_MODIFIERS[mod:GetName()] then
			return true
		end
	end
	return false
end 


AttackCapabilityChanger:Init()
