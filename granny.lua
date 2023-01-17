local Unit = {}

function Unit:new(x, y, game, class)

	local obj = {}
		obj.x = x
		obj.y = y
		obj.img = img
		obj.class = class
		obj.phase = 0
		
	function obj:spawn()
		obj.unit = display.newGroup()
		obj.unit.body = display.newCircle(0, 0, 35)
		obj.unit.body.alpha = 0.3
		obj.unit.face = display.newImage('img/'..obj.phase..'_'..obj.class..'.png')
		game:insert(obj.unit)
	end
	
	function obj:changePhase(phase)
		obj.phase = phase
		obj.unit.face:swapImage('img/'..obj.phase..'_'..obj.class..'.png')
	end
	
	
	setmetatable(obj, self)
    self.__index = self; return obj

end
