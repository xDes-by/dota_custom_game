item_tree_plant = class({})
--------------------------------------------------------------------------------
function item_tree_plant:OnSpellStart()
		self.caster = self:GetCaster()
		self.duration = 10
		vTargetPosition = self:GetCursorPosition()
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )		
		CreateTempTree( vTargetPosition + Vector( 1, 1, 0.0 ), self.duration )
		EmitSoundOnLocationWithCaster( vTargetPosition, "Hero_Furion.Sprout", self:GetCaster() )
			self:SpendCharge()
			local new_charges = self:GetCurrentCharges()
			if new_charges <= 0 then
			self.caster:RemoveItem(self)
			end

end