item_quest_necronomicon = class({})

function item_quest_necronomicon:GetIntrinsicModifierName()
	return "modifier_item_quest_necronomicon"
end

function item_quest_necronomicon:OnSpellStart()
	if not IsServer() then return end
	local caster_loc = self:GetCaster():GetAbsOrigin()
	local caster_direction = self:GetCaster():GetForwardVector()
	local golddrop = 10000
	local xp = 2500

	self:GetCaster():EmitSound("DOTA_Item.Necronomicon.Activate")

	local melee_loc = RotatePosition(caster_loc, QAngle(0, 30, 0), caster_loc + caster_direction * 180)
	local ranged_loc = RotatePosition(caster_loc, QAngle(0, -30, 0), caster_loc + caster_direction * 180)
	GridNav:DestroyTreesAroundPoint(caster_loc + caster_direction * 180, 180, false)
		
	local melee_summon = CreateUnitByName("npc_quest_necronomicon_warrior", melee_loc, false, nil, nil, DOTA_TEAM_BADGUYS)
	settings(melee_summon)
	Rules:difficality_modifier(melee_summon)
	melee_summon:SetMinimumGoldBounty(golddrop * _G.necronomicon)
	melee_summon:SetMaximumGoldBounty(golddrop * _G.necronomicon)
	
	local ranged_summon = CreateUnitByName("npc_quest_necronomicon_archer", ranged_loc, false, nil, nil, DOTA_TEAM_BADGUYS)
	settings(ranged_summon)
	Rules:difficality_modifier(ranged_summon)
	ranged_summon:SetDeathXP(xp * _G.necronomicon)
	
	_G.necronomicon = _G.necronomicon + 0.5
	
	self:SpendCharge()
	if self:GetCurrentCharges() <= 0 then
		self:GetCaster():RemoveItem(self)
    end
end


------------------------------------------------------

function settings(unit)
	local necro_damage = 10000
	local necro_health = 100000
	local necro_armor = 100
	local necro_magermor = 10

	necro_damage = necro_damage * _G.necronomicon
	if necro_damage >= 1000000000 then
		necro_damage = 1000000000
	end
	
	necro_health = necro_health * _G.necronomicon
	if necro_health >= 2000000000 then
		necro_health = 2000000000
	end

	necro_magermor =  math.min(necro_magermor * _G.necronomicon, 90)

	unit:SetBaseDamageMin(necro_damage)
	unit:SetBaseDamageMax(necro_damage)
	unit:SetPhysicalArmorBaseValue(necro_armor * _G.necronomicon)
	unit:SetBaseMagicalResistanceValue(necro_magermor)
	unit:SetMaxHealth(necro_health)
	unit:SetBaseMaxHealth(necro_health)
	unit:SetHealth(necro_health)	
end