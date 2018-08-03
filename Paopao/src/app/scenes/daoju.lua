--
-- Author: laofuzai
-- Date: 2018-08-03 14:27:50
--
local Daoju = class("daoju", function()
	return display.newNode()
end)

function Daoju:ctor()
end

function Daoju:newDaoju(x,y)
	self.daojuNode = display.newNode():addTo(self):pos(x,y)
    self.daojuBk  = display.newSprite("addBullet.png"):addTo(self.daojuNode,1):setAnchorPoint(0.5,0.5)
    local box = cc.PhysicsBody:createBox(cc.size(50,20), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
    box:setDynamic(true)  
    box:setCategoryBitmask(0x0010)
    box:setContactTestBitmask(0x0010)
    box:setCollisionBitmask(0x1000)
    self.daojuNode:setPhysicsBody(box)
    self.daojuNode:setName("daoju")
end

function Daoju:DaojuUpdate(dt)
	local x = self.daojuNode:getPositionX()
	self.daojuNode:setPositionX(x - dt*300)
end

return Daoju
