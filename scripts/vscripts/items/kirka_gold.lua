item_kirka_gold = class({})
--------------------------------------------------------------------------------
function item_kirka_gold:OnSpellStart()
		self.caster = self:GetCaster()
		self.duration = 10
		vTargetPosition = self:GetCursorPosition()
		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/events/ti9/shovel_dig.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, vTargetPosition )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
		EmitSoundOnLocationWithCaster( vTargetPosition, "SeasonalConsumable.TI9.Shovel.Dig", self:GetCaster() )
		
		Timers:CreateTimer({
		endTime = 2, 
		callback = function()
		ParticleManager:DestroyParticle(nFXIndex, true)
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		end
		})
		
		local R = RandomInt(1,100)
		if R <= 25 then 
		self.caster:AddItemByName("item_gold_brus")
		self.caster:EmitSound("Item.DropGemWorld")
		end
end