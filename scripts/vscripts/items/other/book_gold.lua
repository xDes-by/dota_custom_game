LinkLuaModifier( "modifier_book_gold", "items/other/book_gold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_book_gold_cd", "items/other/book_gold", LUA_MODIFIER_MOTION_NONE )

modifier_item_book_gold_cd = class({})
function modifier_item_book_gold_cd:IsHidden() return true end
function modifier_item_book_gold_cd:IsDebuff() return false end
function modifier_item_book_gold_cd:IsPurgable() return false end

item_book_gold = class({})

function item_book_gold:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.caster:AddNewModifier(self.caster, self, "modifier_item_book_gold_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		    Hero:AddNewModifier( self.caster, self, "modifier_book_gold", {duration = self.duration})
		end
        self.caster:EmitSound("Item.TomeOfKnowledge")
        self:SpendCharge()
        local new_charges = self:GetCurrentCharges()
        if new_charges <= 0 then
			self.caster:RemoveItem(self)
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_book_gold = class({})

function modifier_book_gold:IsHidden()
	return false
end

function modifier_book_gold:GetTexture()
	return "scroll_9"
end

function modifier_book_gold:IsDebuff()
	return false
end

function modifier_book_gold:IsPurgable()
	return false
end

function modifier_book_gold:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_book_gold:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_GOLD_RATE_BOOST,
		}
	return funcs
end

function modifier_book_gold:GetModifierDamageOutgoing_Percentage()
	return 20 
end
