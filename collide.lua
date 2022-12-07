
local collision = {}

function collision.isColliding(hero, wall, game)
	local wx1 = wall.x - wall.width/2 - _W/2 + 350;
	local wy1 = wall.y - wall.height/2 - _H/2 + 350;
	local wx2 = wx1 + wall.width;
	local wy2 = wy1 + wall.height;
	local hx1 = 350 - game.x - hero.width/2;
	local hy1 = 350 - game.y - hero.height/2;
	local hx2 = hx1 + hero.width;
	local hy2 = hy1 + hero.height;
	
	if(math.min(wx1, wx2)>math.max(hx1, hx2) or math.max(wx1, wx2)<math.min(hx1, hx2) or math.max(wy1,wy2) < math.min(hy1,hy2) or math.min(wy1,wy2) > math.max(hy1,hy2))then
        return false;
	end
	
	
	
	return true;
end

return collision
