LinkLuaModifier( "modifier_book_mage_damage", "items/other/book_mage_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_book_mage_damage_cd", "items/other/book_mage_damage", LUA_MODIFIER_MOTION_NONE )

modifier_item_book_mage_damage_cd = class({})
function modifier_item_book_mage_damage_cd:IsHidden() return true end
function modifier_item_book_mage_damage_cd:IsDebuff() return false end
function modifier_item_book_mage_damage_cd:IsPurgable() return false end

item_book_mage_damage = class({})

function item_book_mage_damage:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.caster:AddNewModifier(self.caster, self, "modifier_item_book_mage_damage_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		    Hero:AddNewModifier( self.caster, self, "modifier_book_mage_damage", {duration = self.duration})
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
modifier_book_mage_damage = class({})

function modifier_book_mage_damage:IsHidden()
	return false
end

function modifier_book_mage_damage:GetTexture()
	return "scroll_7"
end

function modifier_book_mage_damage:IsDebuff()
	return false
end

function modifier_book_mage_damage:IsPurgable()
	return false
end

function modifier_book_mage_damage:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_book_mage_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		}
	return funcs
end

function modifier_book_mage_damage:GetModifierPercentageExpRateBoost()
	return 20 
end
