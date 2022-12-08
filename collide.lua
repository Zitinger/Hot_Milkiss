
local collision = {}

function collision.isCollidingWall(hero, wall, game)
	local wx1 = wall.x - wall.width/2 - _W/2 + game.size_of_map/2;
	local wy1 = wall.y - wall.height/2 - _H/2 + game.size_of_map/2;
	local wx2 = wx1 + wall.width;
	local wy2 = wy1 + wall.height;
	local hx1 = game.size_of_map/2 - game.x - hero.W/2;
	local hy1 = game.size_of_map/2 - game.y - hero.H/2;
	local hx2 = hx1 + hero.W;
	local hy2 = hy1 + hero.H;
	
	if(math.min(wx1, wx2)>math.max(hx1, hx2) or math.max(wx1, wx2)<math.min(hx1, hx2) or math.max(wy1,wy2) < math.min(hy1,hy2) or math.min(wy1,wy2) > math.max(hy1,hy2))then
        return false;
	end
	return true;
end

function collision.isCollidingUnit(unit1, unit2, game)
	

end

return collision
