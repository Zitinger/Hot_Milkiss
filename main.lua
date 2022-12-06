
_W = display.contentWidth;
_H = display.contentHeight;

local bgbg = display.newRect(_W/2, _H/2, _W, _H);
bgbg:setFillColor(0.5)

local game = display.newGroup();
game.vx, game.vy = 0, 0; 

local bg = display.newImage(game, 'img/first.png', _W/2, _H/2);

local hero = display.newGroup();
hero.x, hero.y = _W/2, _H/2;
local body = display.newCircle(hero, 0, 0, 20);

local walls = display.newGroup()
game:insert(walls)

-- Path for the file to read
local path = system.pathForFile( "img/first.txt")
 
-- Open the file handle
local file, errorString = io.open( path, "r" )
 
if not file then
    -- Error occurred; output the cause
    print( "File error: " .. errorString )
else
    -- Read data from file
	local n = file:read( "*n" )
	for i=1, n do
		x1, y1, x2, y2 = file:read( "*n" ), file:read( "*n" ), file:read( "*n" ), file:read( "*n" )
		
		local wall = display.newRect(walls, x1+_W/2, y1, x2-x1 , y2-y1);
		
		print(x1, y1, x2, y2)
		-- table.insert(walls, {x1, y1, x2, y2})
    end
    io.close( file )
end

file = nil

-- for i=0,#walls do
	-- print(walls[i])
	-- print(walls[i][0], walls[i][1], walls[i][2], walls[i][3])
-- end

local function onKeyEvent(event)
	
	if (event.keyName == 'd' and event.phase == 'down'  ) then
		game.vx = -2;
	end
	if (event.keyName == 'd' and event.phase == 'up'  ) then
		game.vx = 0;
	end
	if (event.keyName == 'w' and event.phase == 'down'  ) then
		game.vy = 2;
	end
	if (event.keyName == 'w' and event.phase == 'up'  ) then
		game.vy = 0;
	end
	if (event.keyName == 's' and event.phase == 'down'  ) then
		game.vy = -2;
	end
	if (event.keyName == 's' and event.phase == 'up'  ) then
		game.vy = 0;
	end
	if (event.keyName == 'a' and event.phase == 'down'  ) then
		game.vx = 2;
	end
	if (event.keyName == 'a' and event.phase == 'up'  ) then
		game.vx = 0;
	end
	
    return false
end

Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener('enterFrame', function()
	-- if game.x >= 700 or game.x <= 0 then
		-- game.x = 
	-- end
	game.x = game.x + game.vx
	game.y = game.y + game.vy
	-- print(hero.x, hero.y)
end)

