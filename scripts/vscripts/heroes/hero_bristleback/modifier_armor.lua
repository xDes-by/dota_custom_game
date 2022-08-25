modifier_armor = class({})

--------------------------------------------------------------------------------
function modifier_armor:IsHidden()
	return false
end

function modifier_armor:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_armor:OnCreated( kv )
	if IsServer() then
		self:SetStackCount( 1 )
	end
end

function modifier_armor:OnRefresh( kv )
	if IsServer() then

		self:IncrementStackCount()
	end
end

function modifier_armor:OnDestroy( kv )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_armor:RemoveStack( kv )
	self:DecrementStackCount()
	if self:GetStackCount()<1 then
		self:Destroy()
	end
end

function modifier_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_armor:GetModifierPhysicalArmorBonus()
if self ~= nil then
	return self:GetStackCount() * 10
	end
	return 0
end
