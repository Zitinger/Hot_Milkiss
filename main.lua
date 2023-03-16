
collision = require('collide')

_W = display.contentWidth;
_H = display.contentHeight;

-- TODO: laser collision

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
		-- print(obj.velocity)
		obj.unit = display.newGroup()
		obj.unit.x = obj.x
		obj.unit.y = obj.y
		obj.unit.body = display.newCircle(obj.unit, 0, 0, 35)
		obj.unit.body.alpha = 0.3
		obj.unit.face = display.newImage(obj.unit, 'img/'..obj.phase..'_'..obj.class..'.png')
		game:insert(obj.unit)
	end
	
	function obj:kill()
		game:remove_from_tb_by_item(obj.tb, obj)
		obj.unit:removeSelf()
	end
	
	function obj:changePhase(phase)
		obj.phase = phase
		print('img/'..obj.phase..'_'..obj.class..'.png')
		obj.unit.face = display.newImage(obj.unit, 'img/'..obj.phase..'_'..obj.class..'.png')
	end
	
	function obj:getCurrentX()
		return obj.spawn_x + obj.xx
	end
	function obj:getCurrentY()
		return obj.spawn_y + obj.yy
	end
	function obj:getPhase()
		return obj.phase
	end
	
	function obj:move()
		if not game.is_paused then
			local ux = obj.spawn_x + obj.xx
			local uy = obj.spawn_y + obj.yy
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
			
			
			if obj.phase == 1 and math.abs(tx - ux) < 3 and math.abs(ty - uy) < 3 then
				obj:kill()
			end
			if obj.phase == 0 and math.sqrt(dx*dx + dy*dy) <= game.unitR then 
				print('game over')
				obj.game:gameOver()
			end
			
			
		end		
	end
	
	function obj:show_task()
		game:pause()
		local task = display.newGroup()
		
		local TEMP_TASK_BG = display.newRoundedRect(task, _W/2, _H/2, 500, 200, 30)
		local dtxt = display.newText(task, 'Win', _W/2, _H/2, nil, 70)
		dtxt:setTextColor(0)
		
		local function win()
			task:removeSelf()
			obj:changePhase(1)
			game:resume()
		end
		
		TEMP_TASK_BG:addEventListener('tap', win)
		
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
hero.W, game.unitW = 97.5, 97.5
hero.H, game.unitH = 86.25, 86.25
game.unitR = 90
-----------------------------------------------------------

local body = display.newCircle(hero, 0, 0, 30);
body.alpha = 0;
local laser = display.newRect(hero, 0, 0, 70, 300)
laser.y = -laser.height/2

laser.alpha = 0
local face = display.newImage(hero, 'img/mainch.png', 0, 0)
-- face:scale(3.75, 3.75)
face.alpha=0
game.hero_velocity = 5

local walls = display.newGroup()
game:insert(walls)
local walls_tb = {}


game.grannys_tb = {}
function game:test_spawn()
	local gr1 = Unit:new(_W/2, _H/2 + 300, game, math.random(1, 3), game.grannys_tb, 'granny')
	gr1.spawn()
	local gr2 = Unit:new(_W/2, _H/2 - 300, game, math.random(1, 3), game.grannys_tb, 'granny')
	gr2.spawn()

	table.insert(game.grannys_tb, gr1)
	table.insert(game.grannys_tb, gr2)
end
-- game:test_spawn()

local path = system.pathForFile("img/first.txt")
local file, errorString = io.open( path, "r" )
 
if file then
    -- Error occurred; output the cause
    print( "File error: ")
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
    end
    io.close( file )
end
file = nil


local d_down, w_down, s_down, a_down = false, false, false, false
game.is_paused = false

function game:pause()
	game.vx, game.vy = 0, 0;
	laser.alpha = 0
	game.hero_velocity = 0
	game.is_paused = true
	d_down, w_down, s_down, a_down = false, false, false, false
end

function game:resume()
	game.hero_velocity = 5
	game.is_paused = false
end

function game:gameOver()
	game:pause()
	local gameover = display.newGroup()
	local bg = display.newRect(gameover, _W/2, _H/2, _W*2, _H*2)
	bg:setFillColor(0)
	bg.alpha = 0.2
	local tab = display.newImage(gameover, 'img/bg.png', _W/2, _H/2)
	bg:addEventListener('tap', function()
		gameover:removeSelf()
		game:resume()
		game:restart()
	end)
end

function game:restart()
	for i=#game.grannys_tb, 1, -1 do
		game.grannys_tb[i]:kill()
	end
	game.x, game.y, game.vx, game.vy = 0, 0, 0, 0
	game:test_spawn()
end

function game:remove_from_tb_by_item(tb, item)
	for i=#tb, 1, -1 do
		if tb[i] == item then
			print(item, tb[i])
			table.remove(tb, i)
		end
	end
end


local function onKeyEvent(event)
	if not game.is_paused then 
		if (event.keyName == 'd' and event.phase == 'down' and not d_down ) then
			game.vx = game.vx - game.hero_velocity;
			d_down = true;
		end
		if (event.keyName == 'd' and event.phase == 'up' and d_down ) then
			game.vx = game.vx + game.hero_velocity;
			d_down = false;
		end
		if (event.keyName == 'w' and event.phase == 'down' and not w_down ) then
			game.vy = game.vy + game.hero_velocity;
			w_down = true;
		end
		if (event.keyName == 'w' and event.phase == 'up' and w_down ) then
			game.vy = game.vy - game.hero_velocity;
			w_down = false;
		end
		if (event.keyName == 's' and event.phase == 'down' and not s_down ) then
			game.vy = game.vy - game.hero_velocity;
			s_down = true;
		end
		if (event.keyName == 's' and event.phase == 'up' and s_down ) then
			game.vy = game.vy + game.hero_velocity;
			s_down = false;
		end
		if (event.keyName == 'a' and event.phase == 'down' and not a_down ) then
			game.vx = game.vx + game.hero_velocity;
			a_down = true;
		end
		if (event.keyName == 'a' and event.phase == 'up' and a_down ) then
			game.vx = game.vx - game.hero_velocity;
			a_down = false;
		end
	end
	
	if (event.keyName == 'p' and event.phase == 'down'  ) then
		for i=1,#game.grannys_tb do
			unit = game.grannys_tb[i]
			unit:changePhase(1)
		end
		-- game:pause()
	end
	if (event.keyName == 'r' and event.phase == 'down'  ) then
		for i=1,#game.grannys_tb do
			unit = game.grannys_tb[i]
			unit:changePhase(0)
		end
		-- game:resume()
	end
	
	if (event.keyName == 'n' and event.phase == 'down'  ) then
		if game.is_paused then
			game:resume()
		else
			game:pause()
		end
	end
	if (event.keyName == 'k' and event.phase == 'down'  ) then
		print(#game.grannys_tb)
		if #game.grannys_tb ~= 0 then
			game.grannys_tb[1]:kill()
		end
	end
	if (event.keyName == 'l' and event.phase == 'down'  ) then
		local gr = Unit:new(_W/2 + math.random(-200, 200), _H/2 + math.random(-500, 500), game, math.random() * 2 + 1, game.grannys_tb, 'granny')
		gr.spawn()
		table.insert(game.grannys_tb, gr)
	end
	
	
    return false
end
Runtime:addEventListener("key", onKeyEvent )


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

function game:check_laser_collision()
	local min_gr;
	local min_dist = 99999999;
	collision.isCollidingLaser(Unit:new(_W/2 + math.random(-200, 200), _H/2 + math.random(-500, 500), game, math.random() * 2 + 1, game.grannys_tb, 'granny'), game, hero, laser)
	for i=1,#game.grannys_tb do
		gr = game.grannys_tb[i]
		if collision.isCollidingLaser(gr, game, hero, laser) and gr:getPhase() == 0 then
			local ux, uy, hx, hy = gr:getCurrentX(), gr:getCurrentY(), game.size_of_map/2 - game.x, game.size_of_map/2 - game.y;
			dd = math.sqrt((hx-ux)*(hx-ux) + (hy-uy)*(hy-uy))
			if dd < min_dist then
				min_gr = gr
				min_dist = dd 
			end
		end
	end
	return min_gr
end

Runtime:addEventListener('enterFrame', function()
	if not game.is_paused then
		hero:move()
		for i=#game.grannys_tb, 1, -1 do
			game.grannys_tb[i]:move()
			-- print(collision.isCollidingLaser(game.grannys_tb[i], game, hero, laser))
		end
		
		if laser.alpha ~= 0 then
			laser_gr = game:check_laser_collision()
			if laser_gr ~= nil then
				laser_gr:show_task()
			end
		end
	end
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
