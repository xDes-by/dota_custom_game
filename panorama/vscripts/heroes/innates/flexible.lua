innate_flexible = class({})


function innate_flexible:OnUpgrade()
	if IsClient() then return end

	if self.books_granted then return end

	local book = self:GetCaster():AddItemByName("item_book_of_rekindling")
	book:SetPurchaseTime(0)

	self.books_granted = true
end
