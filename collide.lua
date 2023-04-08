
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
	
	local function draw_pt(x, y) -- 0, 0 - left bottom (if 0, 0 left top -> y = game.size_of_map - Y)
		local pt1 = display.newCircle(game, _W/2 + game.size_of_map/2 - (game.size_of_map - x), _H/2 + game.size_of_map/2 - y, 5)
		pt1:setFillColor(1,0,0)
	end
	-- draw_pt(x_lv, y_lv)
	
	local k_n, b_n = line_eq(x_ln, y_ln, x_pn, y_pn)[1], line_eq(x_ln, y_ln, x_pn, y_pn)[2]
	local k_l, b_l = line_eq(x_ln, y_ln, x_lv, y_lv)[1], line_eq(x_ln, y_ln, x_lv, y_lv)[2]
	local k_v, b_v = line_eq(x_pv, y_pv, x_lv, y_lv)[1], line_eq(x_pv, y_pv, x_lv, y_lv)[2]
	local k_p, b_p = line_eq(x_pv, y_pv, x_pn, y_pn)[1], line_eq(x_pv, y_pv, x_pn, y_pn)[2]
	
	local sin45 = math.sin(math.pi/4)
	local points = {
		{ux + game.unitR/3, uy},
		{ux - game.unitR/3, uy},
		{ux, uy + game.unitR/3},
		{ux, uy - game.unitR/3},
		{ux + game.unitR/3 * sin45, uy + game.unitR/3 * sin45},
		{ux - game.unitR/3 * sin45, uy - game.unitR/3 * sin45},
		{ux - game.unitR/3 * sin45, uy + game.unitR/3 * sin45},
		{ux + game.unitR/3 * sin45, uy - game.unitR/3 * sin45}
	}
	
	local function draw_collision_points_on_units()
		for i=1,#points do
			draw_pt(points[i][1], points[i][2])
		end
	end
	-- draw_collision_points_on_units()
	
	local function draw_line_by_equasion(k, b)
		for i=3500,4500,10 do
			draw_pt(i, k*i+b)
		end
		print('y = '..k..'x + '..b)
	end
	-- draw_line_by_equasion(k_n, b_n)
	-- draw_line_by_equasion(k_l, b_l)
	-- draw_line_by_equasion(k_p, b_p)
	-- draw_line_by_equasion(k_v, b_v)
	
	local function draw_checkin_line()
		for i=3200,4800,15 do
			for j=3200,4800,15 do
				local xp, yp = i, j
				if yp < k_n * xp + b_n and yp < k_l * xp + b_l and yp > k_p * xp + b_p and yp > k_v * xp + b_v then
					draw_pt(xp,yp)
				end
			end
		end
	end
	-- draw_checkin_line()
	
	
	for i=1,#points do
		px, py = points[i][1], points[i][2]
		-- draw_pt(px, py)
		
		local c1, c2, c3, c4;
		
		if k_l < 0 then
			if b_l > b_p then
				--2
				c1 = py < k_n * px + b_n
				c2 = py < k_l * px + b_l
				c3 = py > k_p * px + b_p
				c4 = py > k_v * px + b_v
			else
				--4
				c1 = py > k_n * px + b_n
				c2 = py > k_l * px + b_l
				c3 = py < k_p * px + b_p
				c4 = py < k_v * px + b_v
			end
		else
			if b_l > b_p then
				--1
				c1 = py > k_n * px + b_n
				c2 = py < k_l * px + b_l
				c3 = py > k_p * px + b_p
				c4 = py < k_v * px + b_v
			else
				--3
				c1 = py < k_n * px + b_n
				c2 = py > k_l * px + b_l
				c3 = py < k_p * px + b_p
				c4 = py > k_v * px + b_v
			end
		end
		
		
		if k_n == 0 and b_n == 0 then
			c1 = px > math.min(x_lv, x_ln)
			c2 = px < math.max(x_lv, x_ln)
			c3 = py > math.min(y_pv, y_lv)
			c4 = py < math.max(y_pv, y_lv)
		end
		if k_l == 0 and b_l == 0 then
			c1 = px > math.min(x_lv, x_pv)
			c2 = px < math.max(x_lv, x_pv)
			c3 = py > math.min(y_lv, y_ln)
			c4 = py < math.max(y_lv, y_ln)
		end
		
		if c1 and c2 and c3 and c4 then
			return true
		end
	end
	
	return false --(c1 and c2 and c3 and c4)
	
end

return collision
