local FONT = [=[Fonts\FRIZQT__.TTF]=]
local TEXTURE = [=[Interface\ChatFrame\ChatFrameBackground]=]

local function Update(self)
	local r, g, b = self.Health:GetStatusBarColor()
	self.Health:SetStatusBarColor(r * 2/3, g * 2/3, b * 2/3)
	self.Health:SetSize(100, 6)
	self.Health:ClearAllPoints()
	self.Health:SetPoint('CENTER', self)

	self.Name:SetText(self.title:GetText())
	self.Highlight:SetAllPoints(self.Health)
end

local function UpdateCastbar(self)
	self:SetSize(100, 6)
	self:ClearAllPoints()
	self:SetPoint('TOP', self:GetParent().Health, 'BOTTOM', 0, -4)

	if(self.shield:IsShown()) then
		self:SetStatusBarColor(1, 1/4, 1/5)
	else
		self:SetStatusBarColor(3/4, 3/4, 3/4)
	end
end

local function Initialize(self)
	local Health, Castbar = self:GetChildren()

	local offset = UIParent:GetScale() / Health:GetEffectiveScale()
	local Backdrop = Health:CreateTexture(nil, 'BACKGROUND')
	Backdrop:SetPoint('BOTTOMLEFT', -offset, -offset)
	Backdrop:SetPoint('TOPRIGHT', offset, offset)
	Backdrop:SetTexture(0, 0, 0)
	Health.Backdrop = Backdrop

	local Background = Health:CreateTexture(nil, 'BORDER')
	Background:SetAllPoints()
	Background:SetTexture(1/3, 1/3, 1/3)

	Health:SetStatusBarTexture(TEXTURE)
	self.Health = Health

	local offset = UIParent:GetScale() / Castbar:GetEffectiveScale()
	local Backdrop = Castbar:CreateTexture(nil, 'BACKGROUND')
	Backdrop:SetPoint('BOTTOMLEFT', -offset, -offset)
	Backdrop:SetPoint('TOPRIGHT', offset, offset)
	Backdrop:SetTexture(0, 0, 0)

	local Background = Castbar:CreateTexture(nil, 'BORDER')
	Background:SetAllPoints()
	Background:SetTexture(1/3, 1/3, 1/3)

	Castbar:HookScript('OnShow', UpdateCastbar)
	Castbar:HookScript('OnSizeChanged', UpdateCastbar)
	Castbar:SetStatusBarTexture(TEXTURE)

	local Name = Health:CreateFontString(nil, 'OVERLAY')
	Name:SetPoint('BOTTOMLEFT', Health, 'TOPLEFT', 0, 2)
	Name:SetPoint('BOTTOMRIGHT', Health, 'TOPRIGHT', 0, 2)
	Name:SetFont(FONT, 8, 'OUTLINE')
	self.Name = Name

	local threat, overlay, Highlight, title, level, boss, RaidIcon, state = self:GetRegions()
	local _, border, shield, icon = Castbar:GetRegions()

	Highlight:SetTexture(TEXTURE)
	Highlight:SetVertexColor(1, 1, 1, 1/4)
	self.Highlight = Highlight

	RaidIcon:ClearAllPoints()
	RaidIcon:SetPoint('LEFT', Health, 'RIGHT', 2, 0)
	RaidIcon:SetSize(12, 12)

	self.title = title
	Castbar.shield = shield

	threat:SetTexture(nil)
	overlay:SetTexture(nil)
	boss:SetTexture(nil)
	state:SetTexture(nil)
	border:SetTexture(nil)
	shield:SetTexture(nil)
	icon:SetWidth(0.01)
	title:SetWidth(0.01)
	level:SetWidth(0.01)

	self:SetScript('OnShow', Update)

	Update(self)
end

do
	local frame
	local select = select

	local function Process(last, current)
		for index = last + 1, current do
			frame = select(index, WorldFrame:GetChildren())

			local name = frame:GetName()
			if(name and name:find('NamePlate%d')) then
				Initialize(frame)
			end
		end
	end

	local currentNum
	local numChildren = 0

	CreateFrame('Frame'):SetScript('OnUpdate', function()
		currentNum = WorldFrame:GetNumChildren()

		if(currentNum ~= numChildren) then
			Process(numChildren, currentNum)
			numChildren = currentNum
		end
	end)
end
