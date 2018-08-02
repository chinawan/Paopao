local player = require("app.scenes.player")
local MainScene = class("MainScene", function()
    return display.newPhysicsScene("MainScene")
end)
BULLET_SPEED_UP = 0.2
ZUAN_SPEED_UP = 2

function MainScene:ctor()
	
	self.world = self:getPhysicsWorld()
    self.world:setGravity(cc.p(0, 0))
    -- self.world:setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
	math.newrandomseed()
	self.backgroundLayer = display.newColorLayer(cc.c4f(0, 0, 0, 180))
	self.backgroundLayer:addTo(self, 2)
	self.backgroundLayer:setTouchEnabled(true)

	self.player = player:new():addTo(self)
	self:newCollision()
	self.btn_start = cc.ui.UIPushButton.new({normal = "start_hot.png",pressed = "start_nor.png",disabled = "start_hot.png"})
	self.btn_start:pos(display.cx,display.cy):addTo(self,3)
	self.btn_start:onButtonClicked(function()
		self:RunSence()
		self:startGame()
		self.btn_start:setVisible(false)
		self.backgroundLayer:setVisible(false)
	end)
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点触摸
    -- 是否启用触摸
   	self:setTouchEnabled(true)
    self:setTouchSwallowEnabled(false)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
		if event.name == "began" then
			self.player:up()
		end
		return true
	end)
	self.highest_scoreNum = cc.UserDefault:getInstance():getIntegerForKey("HighestScore")
	self.Score1 = cc.ui.UILabel.new({UILabelType = 2, text = "Highest Score", size = 42,color = cc.c3b(255,255,255)}):setAnchorPoint(cc.p(0.5,0.5)):pos(0,200):addTo(self.btn_start)
	self.ScoreLabel1 = cc.ui.UILabel.new({UILabelType = 2, text = self.highest_scoreNum, size = 62,color = cc.c3b(255,255,255)}):setAnchorPoint(cc.p(0.5,0.5)):pos(0,100):addTo(self.btn_start)
end

function MainScene:RunSence()
    self:scheduleUpdate()
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
	    self.player:down(dt)
	    -- self.bullet:update(dt)
	    self:checkIsDie()
    end)
end

function MainScene:startGame()
	for k,v in pairs(self.player.BullteList) do
		v:removeSelf()
		v = nil 
	end
	for k,v in pairs(self.player.ZuanList) do
		v:removeSelf()
		v = nil 
	end
	self.player.spNode:setPosition(display.cx-400,display.cy)
	self.player.ZuanList = {}
	self.player.BullteList = {}
	self.player.scoreNum = 0
	self.player.score:setScore(self.player.scoreNum)
end


function MainScene:checkIsDie()
	if self.player.spNode:getPositionY() < 0 then
		self:wanjiaDie(display.cx-400,display.cy)
	end
end

function MainScene:wanjiaDie(x,y)
	self.backgroundLayer:setVisible(true)
	self.player.spNode:setPosition(x,y)
	self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
	for k,v in pairs(self.player.ZuanList) do
		v:stopAllActions()
	end
	ZUAN_SPEED_UP = 2
	self.btn_start:setVisible(true)
	if self.player.scoreNum > self.highest_scoreNum then
		self.highest_scoreNum = self.player.scoreNum
		cc.UserDefault:getInstance():setIntegerForKey("HighestScore", self.highest_scoreNum)
	end
	self.ScoreLabel1:setString(self.highest_scoreNum)
end

function MainScene:newCollision()
    local conListener=cc.EventListenerPhysicsContact:create()
    conListener:registerScriptHandler(function(contact)  
        local node1=contact:getShapeA():getBody():getNode()  
        local node2=contact:getShapeB():getBody():getNode()
        if not node1 or not node2 then return end 
        --print("node1:getName()",node1:getName())
        --print("node2:getName()",node2:getName())
        if node1:getName() =="Bullet" and  node2:getName() == "player" then
        elseif node1:getName() =="player" and  node2:getName() == "Bullet" then
        else
	        if node1:getName() ~= node2:getName() then
	            local vA = nil
	            local vB = nil
	            if node1:getName() == "Bullet" then
	                vB = node1:getParent()
	                vA = node2:getParent()
	                self.player:DelBullet(vB)
	            	self.player:reSetLabel(vA)
	            elseif node1:getName() == "player" then
	                self:wanjiaDie(node1:getPositionX(),node1:getPositionY())
	            elseif node1:getName() == "zuan" and node2:getName() == "Bullet" then
	                vB = node2:getParent()
	                vA = node1:getParent()
	                self.player:DelBullet(vB)
	            	self.player:reSetLabel(vA)
	            elseif node1:getName() == "zuan" and node2:getName() == "player" then
	                self:wanjiaDie(node2:getPositionX(),node2:getPositionY())
	            end
	        end
	        return true  
	    end
    end,cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)  
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithSceneGraphPriority(conListener,self)
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
