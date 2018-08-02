--
-- Author: wj
-- Date: 2018-08-01 21:06:40
--
local score = require("app.scenes.score")
local bullet = require("app.scenes.bullet")
local zuan = require("app.scenes.zuan")
local player = class("player", function ()
	return display.newNode()
end)

function player:ctor()
	self.Bulletdt = 0
	self.Zuandt = 0
	self.hardImp = 0
	self.scoreNum = 0
	self.BullteList = {}
	self.ZuanList = {}
	self.spNode = display.newNode():addTo(self):pos(display.cx-400,display.cy)
    self.spBk  = display.newSprite("player.png"):addTo(self.spNode,1)
    local box = cc.PhysicsBody:createBox(cc.size(25,25), cc.PHYSICSBODY_MATERIAL_DEFAULT, cc.p(0,0))
    box:setDynamic(true)  
    box:setCategoryBitmask(1)    
    box:setContactTestBitmask(1)    
    box:setCollisionBitmask(2)  
    self.spNode:setPhysicsBody(box)
    self.spNode:setName("player")
	self.score = score:new():addTo(self,5)
end

function player:down(dt)
	local y = self.spNode:getPositionY()
	self.spNode:setPositionY(y - dt*120)
	self.Bulletdt = self.Bulletdt + dt
	self.Zuandt = self.Zuandt + dt
	self.hardImp = self.hardImp + dt
	self.updatebullet = true
	if self.Bulletdt > BULLET_SPEED_UP then
		local bullet = bullet:new():addTo(self)
		self:AddBullet(bullet)
		bullet:fire(self.spNode)
		self.Bulletdt = 0
	end
	if self.Zuandt > ZUAN_SPEED_UP then
		self:GroupZuan()
		self.scoreNum = self.scoreNum + 10
        self.score:setScore(self.scoreNum)
		self.Zuandt  = 0
	end
	if self.hardImp > 30 then
		self.hardImp = 0 
		ZUAN_SPEED_UP = ZUAN_SPEED_UP - 0.5
	end
	self:updateBullet(dt)
	-- self:updateLeft(dt)
end

function player:GroupZuan()
	local a = math.random(2,7)
	for i=1,8 do
		if i ~= a then
			local zuan = zuan:new():addTo(self)
			zuan:newZuan(1300 + i *1,display.cy+360 - 80*i,math.random(4,9))
			table.insert(self.ZuanList ,zuan)
			zuan:runAction(transition.sequence({cc.MoveBy:create(5, cc.p(-1300,0)),
				cc.CallFunc:create(function()
					if zuan then
				    	zuan:removeSelf()
				    	self:DelZuan(zuan)
				    end
			end)}))
		end
	end
end

function player:reSetLabel(zuan)
	if not zuan then  return end
    for i = #self.ZuanList, 1, -1 do  
        if self.ZuanList[i] ~= nil  and zuan == self.ZuanList[i]  then  
        	local str = tonumber(self.ZuanList[i].zuanLabel:getString()) - 1
        	if str == 0 then
        		self.scoreNum = self.scoreNum + 5
        		self.score:setScore(self.scoreNum)
        		self.ZuanList[i]:removeSelf()
        		self.ZuanList[i] = nil
            	table.remove(self.ZuanList, i)
        	else
            	self.ZuanList[i].zuanLabel:setString(str)
            end
            return
        end  
    end 
end

function player:DelZuan( _zuan )
    if not _zuan then  return end
    print("zuan num --------------",table.nums(self.ZuanList))
    for i = #self.ZuanList, 1, -1 do  
        if self.ZuanList[i] ~= nil  and _zuan == self.ZuanList[i]  then  
            self.ZuanList[i]:removeSelf()
            self.ZuanList[i] = nil
            table.remove(self.ZuanList, i)
            return
        end  
    end 
end

function player:updateLeft(dt)
	for k,v in pairs(self.ZuanList) do
		if v.zuanNode:getPositionX() < -100 then
			self:DelZuan(v)
			v = nil
		end
		if v ~= nil then
			v:updateZuan(dt)
		end
	end
end

function player:updateBullet(dt)
	for k,v in pairs(self.BullteList) do
		if v.bulletNode:getPositionX() >1100 then
			self:DelBullet(v)
			v = nil
		end
		if v ~= nil then
			v:update(dt)
		end
	end
end



function player:AddBullet( newBullet)
	table.insert(self.BullteList, newBullet)
end

-- function player:DelBullet( newBullet)
-- 	table.remove(self.BullteList,newBullet)
-- end

function player:DelBullet( _Bullet )
    if not _Bullet then  return end
    for i = #self.BullteList, 1, -1 do  
        if self.BullteList[i] ~= nil  and _Bullet == self.BullteList[i]  then  
            self.BullteList[i]:removeSelf()
            table.remove(self.BullteList, i)
            return
        end  
    end 
end


function player:up()
	self.spNode:runAction(cc.MoveBy:create(0.1, cc.p(0,50)))
end

return player