--
-- Author: wj
-- Date: 2018-08-01 23:28:26
--
local Zuan = class("zuan", function()
    return display.newNode()
end)

function Zuan:ctor()
end

function Zuan:newZuan(x,y,num)
	self.zuanNode = display.newNode():setAnchorPoint(0.5,0.5):addTo(self):pos(x,y)
	self.zuanSp = display.newSprite("zuan.png"):addTo(self.zuanNode)
	self.zuanLabel = cc.ui.UILabel.new({UILabelType = 2, text = num, size = 22,color = cc.c3b(0,0,0)}):setAnchorPoint(cc.p(0.5,0.5)):addTo(self.zuanNode)
	local box = cc.PhysicsBody:createBox(cc.size(80,80), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
	box:setDynamic(true)  
	box:setCategoryBitmask(0x0101)
    box:setContactTestBitmask(0x0101)
    box:setCollisionBitmask(0x1000) 
	self.zuanNode:setPhysicsBody(box)
	self.zuanNode:setName("zuan")
end

function Zuan:updateZuan(dt)
	local x = self.zuanNode:getPositionX()
	self.zuanNode:setPositionX(x - dt*400)
end


return Zuan