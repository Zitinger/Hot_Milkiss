
_W = display.contentWidth;
_H = display.contentHeight;

collision = require('collide')
emath = require('eliteMath')

local bgbg = display.newRect(_W/2, _H/2, _W, _H);
bgbg:setFillColor(0.5)

local game = display.newGroup();
game.vx, game.vy = 0, 0; 

local bg = display.newImage(game, 'img/first.png', _W/2, _H/2);

local hero = display.newGroup();
hero.x, hero.y = _W/2, _H/2;
hero.ang = 360;
local body = display.newCircle(hero, 0, 0, 30);
local face = display.newImage(hero, 'img/main.png', 0, 0)
face:scale(2.5, 2.5)

local walls = display.newGroup()
game:insert(walls)
local walls_tb = {}

local vel = 5

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
		
		local wall = display.newRect(walls, x1+_W/2-350, y1+_H/2-350, x2-x1 , y2-y1);
		wall.x = wall.x + wall.width/2
		wall.y = wall.y + wall.height/2
		wall.alpha = 0.7;
		table.insert(walls_tb, wall);
		
		print(x1, y1, x2, y2)
		-- table.insert(walls, {x1, y1, x2, y2})
    end
	-- local c = display.newCircle(_W/2-350, _H/2-350)
    io.close( file )
end
file = nil

local function onKeyEvent(event)
	
	if (event.keyName == 'd' and event.phase == 'down'  ) then
		game.vx = game.vx - vel;
	end
	if (event.keyName == 'd' and event.phase == 'up'  ) then
		game.vx = game.vx + vel;
	end
	if (event.keyName == 'w' and event.phase == 'down'  ) then
		game.vy = game.vy + vel;
	end
	if (event.keyName == 'w' and event.phase == 'up'  ) then
		game.vy = game.vy - vel;
	end
	if (event.keyName == 's' and event.phase == 'down'  ) then
		game.vy = game.vy - vel;
	end
	if (event.keyName == 's' and event.phase == 'up'  ) then
		game.vy = game.vy + vel;
	end
	if (event.keyName == 'a' and event.phase == 'down'  ) then
		game.vx = game.vx + vel;
	end
	if (event.keyName == 'a' and event.phase == 'up'  ) then
		game.vx = game.vx - vel;
	end
	
    return false
end


print()
print()
print()

Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener('enterFrame', function()
	local is_collide_x = false;
	local is_collide_y = false;
	
	-- game.x = game.x + game.vx;
	-- for i=1,#walls_tb do
		-- if(collision.isColliding(hero, walls_tb[i], game))then
			-- is_collide_x = true
		-- end
	-- end
	-- game.x = game.x - game.vx;
	
	-- game.y = game.y + game.vy;
	-- for i=1,#walls_tb do
		-- if(collision.isColliding(hero, walls_tb[i], game))then
			-- is_collide_y = true
		-- end
	-- end
	-- game.y = game.x - game.vy;
	
	
	-- if(is_collide_x)then
		-- game.x = game.x - game.vx
		-- is_collide_x = false;
	-- end
	-- if(is_collide_y)then
		-- game.x = game.x - game.vx
		-- is_collide_x = false;
	-- end
	-- print(is_collide_x, is_collide_y, game.vx, game.vy)
	game.x = game.x + game.vx
	game.y = game.y + game.vy
end)

local function onMouseEvent( event )
	dx = -hero.x + event.x
	dy = hero.y - event.y
	local angle = math.atan2(dx, dy) * 180 / math.pi
	hero:rotate(360 - hero.ang)
	hero.ang = angle
	hero:rotate(hero.ang)
end
                              
-- Add the mouse event listener.
Runtime:addEventListener( "mouse", onMouseEvent )