LinkLuaModifier( "modifier_book_phys_damage", "items/other/book_phys_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_book_phys_damage_cd", "items/other/book_phys_damage", LUA_MODIFIER_MOTION_NONE )

modifier_item_book_phys_damage_cd = class({})
function modifier_item_book_phys_damage_cd:IsHidden() return true end
function modifier_item_book_phys_damage_cd:IsDebuff() return false end
function modifier_item_book_phys_damage_cd:IsPurgable() return false end

item_book_phys_damage = class({})

function item_book_phys_damage:OnSpellStart()
	if IsServer() then
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		self.caster:AddNewModifier(self.caster, self, "modifier_item_book_phys_damage_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		    Hero:AddNewModifier( self.caster, self, "modifier_book_phys_damage", {duration = self.duration})
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
modifier_book_phys_damage = class({})

function modifier_book_phys_damage:IsHidden()
	return false
end

function modifier_book_phys_damage:GetTexture()
	return "scroll_8"
end

function modifier_book_phys_damage:IsDebuff()
	return false
end

function modifier_book_phys_damage:IsPurgable()
	return false
end

function modifier_book_phys_damage:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
		
	end
end

function modifier_book_phys_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		}
	return funcs
end

function modifier_book_phys_damage:GetModifierDamageOutgoing_Percentage()
	return 20 
end
