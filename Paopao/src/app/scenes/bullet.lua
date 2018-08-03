--
-- Author: wj
-- Date: 2018-08-01 22:21:02
--
local Bullet = class("bullet", function()
    return display.newNode()
end)

function Bullet:ctor()

end


function Bullet:fire(batter)
	self.Batter = batter
	self.bulletNode = display.newNode():addTo(self):pos(20+self.Batter:getPositionX(),self.Batter:getPositionY())
    self.bulletBk  = display.newSprite("bullet.png"):addTo(self.bulletNode,1):setAnchorPoint(0,0.5)
    local box = cc.PhysicsBody:createBox(cc.size(43,30), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
    box:setDynamic(true)  
    box:setCategoryBitmask(0x0100)
    box:setContactTestBitmask(0x0100)
    box:setCollisionBitmask(0x1000) 
    self.bulletNode:setPhysicsBody(box)
    self.bulletNode:setName("Bullet")
end

function Bullet:update(dt)
	local x = self.bulletNode:getPositionX()
	self.bulletNode:setPositionX(x + dt*400)
end

return Bullet