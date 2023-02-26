
collision = require('collide')

_W = display.contentWidth;
_H = display.contentHeight;

-- TODO: game over src (unit collision); laser collision; unit phase 1 movement

local Unit = {}
function Unit:new(x, y, game, velocity, units_table, class)

	local obj = {}
		obj.x = x
		obj.y = y
		obj.spawn_x = game.size_of_map/2 - (_W/2) + x
		obj.spawn_y = game.size_of_map/2 - (_H/2) + y
		obj.xx = 0
		obj.yy = 0
		obj.img = img
		obj.class = class
		obj.velocity = velocity
		obj.phase = 0
		obj.game = game
		obj.tb = units_table
		obj.ang = 360
		
	function obj:spawn()
		obj.unit = display.newGroup()
		obj.unit.x = obj.x
		obj.unit.y = obj.y
		obj.unit.body = display.newCircle(obj.unit, 0, 0, 35)
		obj.unit.body.alpha = 0.3
		obj.unit.face = display.newImage(obj.unit, 'img/'..obj.phase..'_'..obj.class..'.png')
		game:insert(obj.unit)
	end
	
	function obj:kill()
		
	end
	
	function obj:changePhase(phase)
		obj.phase = phase
		print('img/'..obj.phase..'_'..obj.class..'.png')
		obj.unit.face = display.newImage(obj.unit, 'img/'..obj.phase..'_'..obj.class..'.png')
	end
	
	function obj:move()

		ux = obj.spawn_x + obj.xx
		uy = obj.spawn_y + obj.yy
		if obj.phase == 0 then
			tx = obj.game.size_of_map/2 - game.x
			ty = obj.game.size_of_map/2 - game.y
		end
		if obj.phase == 1 then
			tx = obj.spawn_x
			ty = obj.spawn_y
		end
		
		
		local dx = -ux + tx
		local dy = uy - ty
		
		local angle = math.atan2(dx, dy) * 180 / math.pi;
		obj.unit:rotate(360 - obj.ang);
		obj.ang = angle;
		obj.unit:rotate(obj.ang);
		
		dx, dy = tx - ux, ty - uy
		local vx, vy
		
		if dx*dx >= dy*dy then
			vx = obj.velocity * (dx / math.abs(dx))
			vy = obj.velocity * (dy / math.abs(dy)) * (math.abs(dy) / math.abs(dx))
		else
			vy = obj.velocity * (dy / math.abs(dy))
			vx = obj.velocity * (dx / math.abs(dx)) * (math.abs(dx) / math.abs(dy))
		end
		
		if dx == 0 then
			vx = 0
		end
		if dy == 0 then
			vy = 0
		end
		
		-- print(vx, vy)
		
		obj.unit.x = obj.unit.x + vx
		obj.unit.y = obj.unit.y + vy
		obj.xx = obj.xx + vx
		obj.yy = obj.yy + vy
		
		
	end
	
	setmetatable(obj, self)
    self.__index = self; return obj

end

local bgbg = display.newRect(_W/2, _H/2, _W, _H);
bgbg:setFillColor(0.5)

local game = display.newGroup();
game.vx, game.vy = 0, 0; 

local bg = display.newImage(game, 'img/mainmap.png', _W/2, _H/2);
game.size_of_map = 8000

local hero = display.newGroup();
hero.x, hero.y = _W/2, _H/2;
hero.ang = 360;

-----------------------------------------------------------
hero.W = 97.5
hero.H = 86.25
-----------------------------------------------------------

local body = display.newCircle(hero, 0, 0, 30);
body.alpha = 0;
local laser = display.newLine(hero, 0, 0, 0, -200)
laser.strokeWidth = 60
laser.alpha = 0
local face = display.newImage(hero, 'img/mainch.png', 0, 0)
-- face:scale(3.75,3.75)
game.hero_velocity = 5

local walls = display.newGroup()
game:insert(walls)
local walls_tb = {}


game.grannys_tb = {}

local gr1 = Unit:new(_W/2, _H/2 + 100, game, math.random(1, 3), game.grannys_tb, 'granny')
gr1.spawn()
local gr2 = Unit:new(_W/2, _H/2 - 100, game, math.random(1, 3), game.grannys_tb, 'granny')
gr2.spawn()


-- gr1:changePhase(1)



local path = system.pathForFile( "img/first.txt")
local file, errorString = io.open( path, "r" )
 
if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Read data from file
	local n = file:read( "*n" )
	for i=1, n do
		x1, y1, x2, y2 = file:read( "*n" ), file:read( "*n" ), file:read( "*n" ), file:read( "*n" )
		
		local wall = display.newRect(walls, x1+_W/2-game.size_of_map/2, y1+_H/2-game.size_of_map/2, x2-x1 , y2-y1);
		wall.x = wall.x + wall.width/2
		wall.y = wall.y + wall.height/2
		wall.alpha = 0.3;
		table.insert(walls_tb, wall);
		
		print(x1, y1, x2, y2)
		-- table.insert(walls, {x1, y1, x2, y2})
    end
	-- local c = display.newCircle(_W/2-350, _H/2-350)
    io.close( file )
end
file = nil

game.is_paused = false
function game:pause()
	game.vx, game.vy = 0, 0;
	game.hero_velocity = 0
	game.is_paused = true
end

function game:resume()
	game.hero_velocity = 5
	game.is_paused = false
end



local function onKeyEvent(event)
	
	if (event.keyName == 'd' and event.phase == 'down'  ) then
		game.vx = game.vx - game.hero_velocity;
	end
	if (event.keyName == 'd' and event.phase == 'up'  ) then
		game.vx = game.vx + game.hero_velocity;
	end
	if (event.keyName == 'w' and event.phase == 'down'  ) then
		game.vy = game.vy + game.hero_velocity;
	end
	if (event.keyName == 'w' and event.phase == 'up'  ) then
		game.vy = game.vy - game.hero_velocity;
	end
	if (event.keyName == 's' and event.phase == 'down'  ) then
		game.vy = game.vy - game.hero_velocity;
	end
	if (event.keyName == 's' and event.phase == 'up'  ) then
		game.vy = game.vy + game.hero_velocity;
	end
	if (event.keyName == 'a' and event.phase == 'down'  ) then
		game.vx = game.vx + game.hero_velocity;
	end
	if (event.keyName == 'a' and event.phase == 'up'  ) then
		game.vx = game.vx - game.hero_velocity;
	end
	
	if (event.keyName == 'p' and event.phase == 'down'  ) then
		gr1:changePhase(1)
		-- game:pause()
	end
	if (event.keyName == 'r' and event.phase == 'down'  ) then
		gr1:changePhase(0)
		-- game:resume()
	end
	
	
    return false
end

function hero:move()
	local is_collide_x = false;
	local is_collide_y = false;
	game.x = game.x + game.vx;
	for i=1,#walls_tb do
		if(collision.isCollidingWall(hero, walls_tb[i], game))then
			is_collide_x = true
		end
	end
	game.x = game.x - game.vx;
	
	game.y = game.y + game.vy;
	for i=1,#walls_tb do
		if(collision.isCollidingWall(hero, walls_tb[i], game))then
			is_collide_y = true
		end
	end
	game.y = game.y - game.vy;
	
	
	if(is_collide_x)then
		game.x = game.x - game.vx
		is_collide_x = false;
	end
	
	if(is_collide_y)then
		game.y = game.y - game.vy
		is_collide_y = false;
	end
	
	game.x = game.x + game.vx
	game.y = game.y + game.vy
end

Runtime:addEventListener("key", onKeyEvent )
Runtime:addEventListener('enterFrame', function()
	
	hero:move()
	gr1:move()
	gr2:move()
	-- gr1:move(hero.x, hero.y)
	
end)

local function onMouseEvent( event )
	if not game.is_paused then
		dx = -hero.x + event.x;
		dy = hero.y - event.y;
		local angle = math.atan2(dx, dy) * 180 / math.pi;
		hero:rotate(360 - hero.ang);
		hero.ang = angle;
		hero:rotate(hero.ang);
	
		local vx = game.vx
		local vy = game.vy
		if event.type == 'down' then
			if vx == 5 then game.vx = 2 elseif vx == -5 then game.vx = -2 else game.vx = 0 end
			if vy == 5 then game.vy = 2 elseif vy == -5 then game.vy = -2 else game.vy = 0 end
			game.hero_velocity = 2
			laser.alpha = 1
		end
		if event.type == 'up' then
			if vx == 2 then game.vx = 5 elseif vx == -2 then game.vx = -5 else game.vx = 0 end
			if vy == 2 then game.vy = 5 elseif vy == -2 then game.vy = -5 else game.vy = 0 end
			game.hero_velocity = 5
			laser.alpha = 0
		end
	end
end
Runtime:addEventListener("mouse", onMouseEvent)
