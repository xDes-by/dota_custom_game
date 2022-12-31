modifier_chc_mastery_numb = class({})

function modifier_chc_mastery_numb:IsHidden() return true end
function modifier_chc_mastery_numb:IsDebuff() return false end
function modifier_chc_mastery_numb:IsPurgable() return false end
function modifier_chc_mastery_numb:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_numb:GetTexture() return "masteries/numb" end

function modifier_chc_mastery_numb:OnIntervalThink()
	if IsClient() then return end

	local parent = self:GetParent()
	local damage_stacks = parent:FindAllModifiersByName("modifier_chc_mastery_numb_stack")
	local damage_tick = 0

	for _, stack in pairs(damage_stacks) do
		damage_tick = damage_tick + (stack.damage_tick or 0)
	end

	if damage_tick > 0 then
		ApplyDamage({
			victim = parent, 
			attacker = parent, 
			damage = damage_tick, 
			damage_type = DAMAGE_TYPE_PURE, 
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_MASTERY_NUMB
		})
	end
end

function modifier_chc_mastery_numb:OnDestroy()
	if IsClient() then return end

	self:GetParent().stagger_amount = nil
	self:GetParent().stagger_duration = nil
end

function modifier_chc_mastery_numb:OnRoundEndForTeam(keys)
	if IsClient() then return end

	local parent = self:GetParent()

	while parent:HasModifier("modifier_chc_mastery_numb_stack") do
		parent:RemoveModifierByName("modifier_chc_mastery_numb_stack")
	end
end



modifier_chc_mastery_numb_1 = class(modifier_chc_mastery_numb)
modifier_chc_mastery_numb_2 = class(modifier_chc_mastery_numb)
modifier_chc_mastery_numb_3 = class(modifier_chc_mastery_numb)

function modifier_chc_mastery_numb_1:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().stagger_amount = 0.2
	self:GetParent().stagger_duration = 7

	self:StartIntervalThink(0.25)
end

function modifier_chc_mastery_numb_2:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().stagger_amount = 0.35
	self:GetParent().stagger_duration = 7

	self:StartIntervalThink(0.25)
end

function modifier_chc_mastery_numb_3:OnCreated(keys)
	if IsClient() then return end

	self:GetParent().stagger_amount = 0.5
	self:GetParent().stagger_duration = 7

	self:StartIntervalThink(0.25)
end



modifier_chc_mastery_numb_stack = class({})

function modifier_chc_mastery_numb_stack:IsHidden() return true end
function modifier_chc_mastery_numb_stack:IsDebuff() return false end
function modifier_chc_mastery_numb_stack:IsPurgable() return false end
function modifier_chc_mastery_numb_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_chc_mastery_numb_stack:OnCreated(keys)
	if IsClient() then return end

	self.damage_tick = 0.25 * (keys.damage or 0) / keys.duration

	if self.damage_tick < 1 then self:Destroy()	end
end
