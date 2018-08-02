--
-- Author: wj
-- Date: 2018-08-02 21:29:28
--
local Score = class("score", function()
	return display.newNode()
end)

function Score:ctor()
	local Score = cc.ui.UILabel.new({UILabelType = 2, text = "Score", size = 32,color = cc.c3b(255,255,255)}):pos(display.cx-550,display.cy+300):addTo(self)
	self.ScoreLabel = cc.ui.UILabel.new({UILabelType = 2, text = "0", size = 32,color = cc.c3b(255,255,255)}):pos(display.cx-450,display.cy+300):setAnchorPoint(cc.p(0,0.5)):addTo(self)
end

function Score:setScore(num)
	self.ScoreLabel:setString(num)
end

return Score