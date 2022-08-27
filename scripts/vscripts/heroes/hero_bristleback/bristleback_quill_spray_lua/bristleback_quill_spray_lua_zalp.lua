npc_dota_hero_bristleback_int9 = class({})

function npc_dota_hero_bristleback_int9:OnUpgrade()
 	self:GetCaster():FindAbilityByName( "npc_dota_hero_bristleback_zalp" ):SetActivated(true)
 	self:GetCaster():FindAbilityByName( "npc_dota_hero_bristleback_zalp" ):SetHidden(false)
 	self:GetCaster():FindAbilityByName( "npc_dota_hero_bristleback_zalp" ):SetLevel(1)
end

npc_dota_hero_bristleback_zalp = class({})

function npc_dota_hero_bristleback_zalp:GetManaCost(iLevel)
    local caster = self:GetCaster()
    if caster then
        return math.min(65000, caster:GetIntellect()*3)
    end
end

function npc_dota_hero_bristleback_zalp:OnSpellStart()
	caster = self:GetCaster()
	
		local ability = self:GetCaster():FindAbilityByName( "bristleback_quill_spray_lua" )
		if ability~=nil  and ability:GetLevel()>=1 then
		
		for i =1, 10 do
			ability:OnSpellStart()
		end
	end
end




