item_kaya_custom_lua1 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua2 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua3 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua4 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua5 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua6 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua7 = item_kaya_custom_lua1 or class({})
item_kaya_custom_lua8 = item_kaya_custom_lua1 or class({})

LinkLuaModifier( "modifier_item_kaya_custom", "items/custom_items/item_kaya_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_gem1", 'items/items_gems/gem1', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem2", 'items/items_gems/gem2', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem3", 'items/items_gems/gem3', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem4", 'items/items_gems/gem4', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gem5", 'items/items_gems/gem5', LUA_MODIFIER_MOTION_NONE)

function item_kaya_custom_lua1:GetIntrinsicModifierName()
	return "modifier_item_kaya_custom"
end

modifier_item_kaya_custom = class({})

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:IsHidden()
	return false
end
function modifier_item_kaya_custom:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom:IsPurgable()
	return false
end
function modifier_item_kaya_custom:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom:OnCreated( kv )
	self.bonus_dmg = self:GetAbility():GetSpecialValueFor( "bonus_dmg" )
	self.bonus_manaregen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
if not IsServer() then return end				
	
		self.bonus_life = self:GetAbility():GetSpecialValueFor( "bonus_life" )
		self.bonus_int = self:GetAbility():GetSpecialValueFor( "bonus_int" )
		
		
		self.particle_name = "particles/items3_fx/octarine_core_lifesteal.vpcf"
		
		for i = 0, 5 do 
		local item = self:GetCaster():GetItemInSlot(i)
			if item ~= nil then
			local itemname = item:GetAbilityName()
			local namecheck = string.sub( itemname, 1, 16 )
				if namecheck == "item_kaya_custom" and item ~= self:GetAbility() then
					self:GetParent():DropItemAtPositionImmediate(item,self:GetParent():GetOrigin())
					--self:Destroy()
				end
			end
		end

	
		-- local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
			-- local gem = string.sub(self:GetAbility():GetName(), -4)

		-- if gem == "gem1" or gem == "gem2" or gem == "gem3" or gem == "gem4" or gem == "gem5" then
			-- local modifierName = "modifier_" .. gem
			-- if self:GetParent():HasModifier(modifierName) then
				-- local stacks = self:GetCaster():GetModifierStackCount(modifierName, self:GetCaster())
				-- self:GetParent():SetModifierStackCount(modifierName, self:GetCaster(), (stacks + bonus))
			-- else
				-- self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), modifierName, nil)
				-- self:GetParent():SetModifierStackCount(modifierName, self:GetCaster(), bonus)	
			-- end
		-- end
end

function modifier_item_kaya_custom:OnDestroy()
-- if not IsServer() then return end
	-- local bonus = self:GetAbility():GetSpecialValueFor("bonus_gem")
	-- local gem = string.sub(self:GetAbility():GetName(), -4)
	-- local modifierName = "modifier_" .. gem

	-- local stacks = self:GetCaster():GetModifierStackCount(modifierName, self:GetCaster())
	-- if stacks> 0 then
		-- self:GetCaster():SetModifierStackCount(modifierName, self:GetCaster(), stacks - bonus)
		-- local stacks = self:GetCaster():GetModifierStackCount(modifierName, self:GetCaster())
		-- if stacks == 0 then
			-- self:GetCaster():RemoveModifierByNameAndCaster(modifierName, self:GetCaster())
		-- end
	-- end
end
--------------------------------------------------------------------------------

function modifier_item_kaya_custom:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_item_kaya_custom:GetModifierSpellAmplify_Percentage( params )

	local intellect = self:GetCaster():GetIntellect()
	local truedmg = intellect * self.bonus_dmg
	return truedmg
end

function modifier_item_kaya_custom:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

function modifier_item_kaya_custom:GetModifierConstantManaRegen( params )
	return self.bonus_manaregen
end

function modifier_item_kaya_custom:OnTakeDamage(keys)
	if keys.attacker == self:GetParent() and not keys.unit:IsBuilding() and not keys.unit:IsOther() then	

		if self:GetParent():FindAllModifiersByName(self:GetName())[1] == self and keys.damage_category == 0 and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) ~= DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
		
		all_cleaves = {"item_bfury_lua1","item_bfury_lua2","item_bfury_lua3","item_bfury_lua4","item_bfury_lua5","item_bfury_lua6","item_bfury_lua7","item_bfury_lua8",
		"item_bfury_lua1_gem1","item_bfury_lua2_gem1","item_bfury_lua3_gem1","item_bfury_lua4_gem1","item_bfury_lua5_gem1","item_bfury_lua6_gem1","item_bfury_lua7_gem1","item_bfury_lua8_gem1",
		"item_bfury_lua1_gem2","item_bfury_lua2_gem2","item_bfury_lua3_gem2","item_bfury_lua4_gem2","item_bfury_lua5_gem2","item_bfury_lua6_gem2","item_bfury_lua7_gem2","item_bfury_lua8_gem2",
		"item_bfury_lua1_gem3","item_bfury_lua2_gem3","item_bfury_lua3_gem3","item_bfury_lua4_gem3","item_bfury_lua5_gem3","item_bfury_lua6_gem3","item_bfury_lua7_gem3","item_bfury_lua8_gem3",
		"item_bfury_lua1_gem4","item_bfury_lua2_gem4","item_bfury_lua3_gem4","item_bfury_lua4_gem4","item_bfury_lua5_gem4","item_bfury_lua6_gem4","item_bfury_lua7_gem4","item_bfury_lua8_gem4",
		"item_bfury_lua1_gem5","item_bfury_lua2_gem5","item_bfury_lua3_gem5","item_bfury_lua4_gem5","item_bfury_lua5_gem5","item_bfury_lua6_gem5","item_bfury_lua7_gem5","item_bfury_lua8_gem5",
		"sven_bringer","sven_great_cleave_lua","item_pet_RDA_cleave","luna_moon_glaive_lua","npc_dota_hero_treant_agi11","npc_dota_hero_centaur_agi11",
		"npc_dota_hero_mars_agi10","npc_dota_hero_phantom_assassin_agi11","npc_dota_hero_slark_agi9","bristleback_warpath_lua","sven_bringer"}

		for _,current_name in pairs(all_cleaves) do
			if current_name == keys.inflictor:GetAbilityName() then
				return end
		end

			self.lifesteal_pfx = ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.attacker)
			ParticleManager:SetParticleControl(self.lifesteal_pfx, 0, keys.attacker:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(self.lifesteal_pfx)
			
			if keys.attacker:GetHealth() <= (keys.original_damage * (self.bonus_life / 100)) and keys.inflictor and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			keys.attacker:ForceKill(true)
			else
			keys.attacker:Heal(keys.original_damage * (self.bonus_life / 100), self)
			end
		end
	end
end