--------------------------------------------------------------------------------
modifier_drow_ranger_marksmanship_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_marksmanship_lua_debuff:IsHidden()
	return false
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsDebuff()
	return true
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsStunDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsPurgable()
	return false
end
----------------------
----------------------
----------------------

----------------------
----------------------
----------------------
function modifier_drow_ranger_marksmanship_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_drow_ranger_marksmanship_lua_debuff:OnCreated( kv )

end

function modifier_drow_ranger_marksmanship_lua_debuff:OnRefresh( kv )
	
end

function modifier_drow_ranger_marksmanship_lua_debuff:OnRemoved()
end

function modifier_drow_ranger_marksmanship_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_marksmanship_lua_debuff:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

