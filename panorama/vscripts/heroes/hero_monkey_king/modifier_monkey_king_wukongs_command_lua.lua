modifier_monkey_king_wukongs_command_lua = class({})

function modifier_monkey_king_wukongs_command_lua:IsHidden() return true end
function modifier_monkey_king_wukongs_command_lua:IsPurgable() return false end


function modifier_monkey_king_wukongs_command_lua:OnCreated()
	if not IsServer() then return end

	local parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self.ability:GetCaster()

	if self.caster:IsIllusion() then return end
	Timers:CreateTimer(0.1, function()
		if self and not self:IsNull() then
			self:MakeClone()
		end
	end)

	self.scepter_gained_listener = EventDriver:Listen("Hero:scepter_received", function(event)
		if event.hero ~= self.caster then return end
		self.caster.mk_clone:RemoveModifierByName("modifier_monkey_king_wukongs_command_hidden_lua")

		self.ability:MakeRingParticleAt()
	end)

	self.scepter_lost_listener = EventDriver:Listen("Hero:scepter_lost", function(event)
		if event.hero ~= self.caster then return end
		self.caster.mk_clone:AddNewModifier(self.caster.mk_clone, self:GetAbility(), "modifier_monkey_king_wukongs_command_hidden_lua", {})
	
		self.ability:RemoveParticle()
	end)
end


function modifier_monkey_king_wukongs_command_lua:OnDestroy()
	if not IsServer() then return end

	local parent = self:GetParent()
	if parent and not parent:IsNull() and parent.mk_clone and not parent.mk_clone:IsNull() then
		if self.ability and not self.ability:IsNull() then
			self.ability:RemoveParticle()
		elseif parent.mk_clone.ring_particle then
			ParticleManager:DestroyParticle(parent.mk_clone.ring_particle, true)
			ParticleManager:ReleaseParticleIndex(parent.mk_clone.ring_particle)
			parent.mk_clone.ring_particle = nil
		end
		parent.mk_clone:RemoveSelf()
		parent.mk_clone = nil
		parent:StopSound("Hero_MonkeyKing.FurArmy")
		parent:EmitSound("Hero_MonkeyKing.FurArmy.End")
	end

	EventDriver:CancelListener("Hero:scepter_received", self.scepter_gained_listener)
	EventDriver:CancelListener("Hero:scepter_lost", self.scepter_lost_listener)
end


function modifier_monkey_king_wukongs_command_lua:MakeClone()
	local parent = self:GetParent()
	-- create clone if there's none
	if parent.mk_clone and not parent.mk_clone:IsNull() then return end
	local unit = CreateUnitByName(
		"npc_chc_wukongs_command_creep", 
		parent:GetAbsOrigin() + RandomVector(200), 
		true, 
		parent, 
		parent:GetPlayerOwner(), 
		parent:GetTeamNumber()
	)
	self:CompleteClone(unit)
end


function modifier_monkey_king_wukongs_command_lua:CompleteClone(clone)
	if not clone or clone:IsNull() then return end
	if not self or self:IsNull() then clone:RemoveSelf() return end

	local ability = self:GetAbility()
	if not ability or ability:IsNull() then clone:RemoveSelf() return end

	clone.IsRealHero = function() return false end
	clone:AddNewModifier(clone, ability, "modifier_monkey_king_wukongs_command_clone_lua", {})

	FindClearSpaceForUnit(clone, clone:GetAbsOrigin(), false)
	self.caster.mk_clone = clone

	if not self.caster:HasScepter() then
		clone:AddNewModifier(clone, ability, "modifier_monkey_king_wukongs_command_hidden_lua", {})
	else
		self.ability:MakeRingParticleAt()
	end
end
