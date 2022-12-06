
_W = display.contentWidth;
_H = display.contentHeight;

local bgbg = display.newRect(_W/2, _H/2, _W, _H);
bgbg:setFillColor(0.5)

local game = display.newGroup();
game.vx, game.vy = 0, 0; 

local bg = display.newImage(game, 'img/first.png', _W/2, _H/2);

bg.xScale, bg.yScale = 0.3, 0.3;


local hero = display.newGroup();
hero.x, hero.y = _W/2, _H/2;
local body = display.newCircle(hero, 0, 0, 10);

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
	game.x = game.x + game.vx
	game.y = game.y + game.vy
	-- print(hero.x, hero.y)
end)

