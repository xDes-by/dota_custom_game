LinkLuaModifier( "modifier_item_expiriance_aura", "items/other/book_exp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_expiriance_aura_cd", "items/other/book_exp", LUA_MODIFIER_MOTION_NONE )

modifier_item_expiriance_aura_cd = class({})
function modifier_item_expiriance_aura_cd:IsHidden() return true end
function modifier_item_expiriance_aura_cd:IsDebuff() return false end
function modifier_item_expiriance_aura_cd:IsPurgable() return false end

item_expiriance_aura = class({})

function item_expiriance_aura:OnSpellStart()
	if IsServer() then
		print('on spell start')
		self.caster = self:GetCaster()	
		self.radius = self:GetSpecialValueFor( "radius" )
		self.duration = self:GetSpecialValueFor( "duration" )
		print('modifier_item_expiriance_aura_cd')
		self.caster:AddNewModifier(self.caster, self, "modifier_item_expiriance_aura_cd", {duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()})
		local Heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), self:GetCaster(), self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, 0, false )
		for _,Hero in pairs( Heroes ) do
		
		Hero:AddNewModifier(
		self.caster,
		self,
		"modifier_item_expiriance_aura", 
		{duration = self.duration})
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
modifier_item_expiriance_aura = class({})

function modifier_item_expiriance_aura:IsHidden()
	return false
end

function modifier_item_expiriance_aura:GetTexture()
	return "scroll_2"
end

function modifier_item_expiriance_aura:IsDebuff()
	return false
end

function modifier_item_expiriance_aura:IsPurgable()
	return false
end

function modifier_item_expiriance_aura:OnCreated( kv )
	if IsServer() then 
		self.caster = self:GetCaster()
	end
end

function modifier_item_expiriance_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
		}
	return funcs
end

function modifier_item_expiriance_aura:GetModifierPercentageExpRateBoost()
	return 10 
end
