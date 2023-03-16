
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

function collision.isCollidingLaser(unit, game, hero, laser)
	local ux, uy, hx, hy = unit:getCurrentX(), game.size_of_map - unit:getCurrentY(), game.size_of_map/2 - game.x, game.size_of_map - (game.size_of_map/2 - game.y);
	local rad_angle = hero.ang * math.pi / 180
	
	local function line_eq(x1, y1, x2, y2)
		if x1 == x2 then
			return {0, 0}
		end
		-- print(y1, y2)
		local kb = {}
		local k = (y1 - y2) / (x1 - x2)
		local b = y2 - k*x2
		table.insert(kb, k)
		table.insert(kb, b)
		return kb
	end
	local dx1, dy1 = laser.width/2 * math.cos(rad_angle), laser.width/2 * math.sin(rad_angle)
	local x_ln, y_ln = hx - dx1, hy + dy1
	local x_pn, y_pn = hx + dx1, hy - dy1
	local dx2, dy2 = laser.height * math.sin(rad_angle), laser.height * math.cos(rad_angle)
	local x_pv, y_pv = x_pn + dx2, y_pn + dy2
	local x_lv, y_lv = x_ln + dx2, y_ln + dy2
	
	local function draw_pt(x, y)
		local pt1 = display.newCircle(game, _W/2 + game.size_of_map/2 - (game.size_of_map - x), _H/2 + game.size_of_map/2 - y, 10)
		pt1:setFillColor(1,0,0)
	end
	draw_pt(x_lv, y_lv)
	
	local k_n, b_n = line_eq(x_ln, y_ln, x_pn, y_pn)[1], line_eq(x_ln, y_ln, x_pn, y_pn)[2]
	local k_l, b_l = line_eq(x_ln, y_ln, x_lv, y_lv)[1], line_eq(x_ln, y_ln, x_lv, y_lv)[2]
	local k_p, b_p = line_eq(x_pv, y_pv, x_lv, y_lv)[1], line_eq(x_pv, y_pv, x_lv, y_lv)[2]
	local k_v, b_v = line_eq(x_pv, y_pv, x_pn, y_pn)[1], line_eq(x_pv, y_pv, x_pn, y_pn)[2]
	
	--TODO: проверка ->
	
	
end

return collision
