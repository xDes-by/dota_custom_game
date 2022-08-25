LinkLuaModifier("modifier_npc_dota_hero_shadow_shaman_str10", "heroes/hero_shaman/chek", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_s_armor", "heroes/hero_shaman/chek", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_shadow_shaman_str10 = class({})

function npc_dota_hero_shadow_shaman_str10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_shadow_shaman_str10"
end

------------------------------------------------------------------------------------

modifier_npc_dota_hero_shadow_shaman_str10 = class({})


function modifier_npc_dota_hero_shadow_shaman_str10:IsHidden()
	return true
end

function modifier_npc_dota_hero_shadow_shaman_str10:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_shadow_shaman_str10:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_shadow_shaman_str10:OnRefresh( da )
end


function modifier_npc_dota_hero_shadow_shaman_str10:OnCreated(kv)
self:StartIntervalThink(0.2)
end

function modifier_npc_dota_hero_shadow_shaman_str10:OnIntervalThink()
	if IsServer() then
	armor = 0 
		local allies = FindUnitsInRadius(
				self:GetCaster():GetTeamNumber(),	-- int, your team number
				self:GetCaster():GetAbsOrigin(),	-- point, center point
				nil,	-- handle, cacheUnit. (not known)
				700,	-- float, radius. or use FIND_UNITS_EVERYWHERE
				DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
				DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
				0,	-- int, order filter
				false	-- bool, can grow cache
			)
			for i = 1, #allies do		
			if allies[i]:GetUnitName() == "shadow_shaman_ward" then	
				self:GetCaster():AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_s_armor", -- modifier name
				{ duration = 0.3 } -- kv
			):SetStackCount(i)
			end
		end
	end
end

modifier_s_armor = class({})


function modifier_s_armor:IsHidden()
	return true
end

function modifier_s_armor:IsPurgable()
    return false
end
 
function modifier_s_armor:RemoveOnDeath()
    return false
end

function modifier_s_armor:OnRefresh()
end

function modifier_s_armor:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_s_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount() * 5 
end