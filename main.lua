
collision = require('collide')


_W = display.contentWidth;
_H = display.contentHeight;
local face = display.newGroup()

local ui = display.newGroup()
local pausebtn = display.newImage(ui, 'img/pause_btn.png')
local streakbg = display.newImage(ui, 'img/strik.png')
streakbg:scale(1.5, 1.3)
streakbg.x, streakbg.y = 2*_W - streakbg.width/1.15, streakbg.height
local streaktxt = display.newText(ui, 'Счет: 0', streakbg.x, streakbg.y, 'Comic Sans MS', 50)
streaktxt:setTextColor(0)



local xscale_k, yscale_k = _W/2560, _H/1440
print('SCALES', xscale_k, yscale_k)
-- TODO: schoolman on main menu; random class of unit;

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
		obj.class = class -- OR
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
	function obj:activateRage()
		obj.velocity = 11
	end
	function obj:activateHappy()
		obj.velocity = 6
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
				if obj.game.size_of_map/2 - game.y > uy then
					ty = obj.spawn_y - 4000
				else
					ty = obj.spawn_y + 4000
				end
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
		face:insert(task)
		obj.task = true
		
		local is_helping = false
		
		local task_bg = display.newImage(task, 'img/backgrex.png', _W/2, _H/2)
		-- local task_bg = display.newImage(task, 'img/ebox.png', _W/2, _H/2, 1600, 1000, 30)
		local num_base = 2
		
		local ex = game:generate_exercise(game.difficulty, num_base)
		local code_num, true_res = ex[1], ex[2]
		local numbertxt = display.newText(task, code_num, _W/2, _H/2.5, game.mainFont, 150)
		numbertxt:setTextColor(0)
		local postfix = display.newText(task, num_base, numbertxt.x + numbertxt.width/2+10, numbertxt.y + numbertxt.height/2-20, game.mainFont, 50)
		postfix:setTextColor(0)
		
		local input
		input = native.newTextField(_W/2, _H/2 + 90, 600*xscale_k, 150*yscale_k)
		input.inputType = "number"
		input.align = "center"
		
		local helpbtn = display.newImage(task, 'img/question_btn.png', _W/2-task.width/2+90, _H/2-task.height/2+90)
		helpbtn:addEventListener('tap', function(e)
			game.help_counter = game.help_counter + 1
			print(game.help_counter)
			is_helping = true
			task.alpha = 0
			input:removeSelf()
			help = display.newGroup()
			local bg = display.newRect(help, _W/2, _H/2, _W*2, _H*2)
			bg:setFillColor(0)
			bg.alpha = 0.5
			
			local helpwnd = display.newImage(help, 'img/help.png', _W/2, _H/2)
			helpwnd:scale(0.5, 0.5)
			
			
			bg:addEventListener('tap', function(e)
				input = native.newTextField(_W/2, _H/2 + 90, 600*xscale_k, 150*yscale_k)
				input.inputType = "number"
				input.align = "center"
				is_helping = false
				task.alpha = 1
				help:removeSelf()
			end)
			
		end)
		
		
		local timer = display.newGroup()
		task:insert(timer)
		
		local timer_bg = display.newImage(timer, 'img/timetag.png', _W/2+task.width/2.7, _H/2-task.height/2.7)
		local end_time = system.getTimer() + game.time_to_task
		local time_left = math.ceil((end_time - system.getTimer()) / 1000)
		local timertxt = display.newText(timer, time_left, timer_bg.x, timer_bg.y, game.mainFont, 80)
		timertxt:setTextColor(0)
		
		local donebtn = display.newImage(task, 'img/done_btn.png', _W/2, _H/2 + 400)
		donebtn.xScale, donebtn.yScale = 1.3, 1.3
		
		local function win()
			if game.difficulty == 1 then
				game.streak = game.streak + 0.5 
			elseif game.difficulty == 2 then
				game.streak = game.streak + 1 
			elseif game.difficulty == 3 then
				game.streak = game.streak + 2
			else
				print('ERROR: wrong difficulty')
			end
			game:update_score()
			task:removeSelf()
			input:removeSelf()
			obj:changePhase(1)
			obj:activateHappy()
			obj.task = false
			game:resume()
		end
		local function lose()
			if is_helping then
				task:removeSelf()
				help:removeSelf()
			else
				task:removeSelf()
				input:removeSelf()
			end
			obj.task = false
			
			local wrongtxt = display.newText(face, 'WRONG', _W/2, _H/2, game.mainFont, 300)
			wrongtxt:setTextColor(1, 0, 0)
			wrongtxt.alpha = 0
			transition.to(wrongtxt, {time = 500, alpha=1, transition=easing.inQuad})
			transition.to(wrongtxt, {time = 500, delay = 500, alpha=0, transition=easing.inQuad, onComplete=function()
				obj:activateRage()
				game:resume()
			end})
		end
		
		local function solve()
			solution = input.text
			print(solution, true_res)
			if solution == tostring(true_res) then
				win()
			else
				lose()
			end
		end
		
		input:addEventListener('userInput', function(e)
			if e.phase == "submitted" then
				solve()
			end
		end)
		donebtn:addEventListener('tap', function()
			solve()
		end)
		
		-- local systemFonts = native.getFontNames()
		-- for i, fontName in ipairs( systemFonts ) do
			-- print( "Font Name = " .. tostring( fontName ) )
		-- end
		
		
		Runtime:addEventListener('enterFrame', function()
			if not is_helping or game.help_counter > 3 then
				if obj.task then
					time_left = end_time - system.getTimer()
					local curr_t = math.ceil(time_left / 1000)
					if curr_t <= 0 then
						lose(task)
					end
					timertxt.text = curr_t
				end
			else
				end_time = system.getTimer() + time_left 
			end
		end)
		
		
		
	end
	
	setmetatable(obj, self)
    self.__index = self; return obj

end

local bgbg = display.newRect(_W/2, _H/2, _W, _H);
bgbg:setFillColor(0.5)

local game = display.newGroup();
game.vx, game.vy = 0, 0;

local bg = display.newImage(game, 'img/doublemainlast.png', _W/2, _H/2);
game.size_of_map = 8000

local hero = display.newGroup();
hero.x, hero.y = _W/2, _H/2;
hero.ang = 360;


local global_group = display.newGroup()
global_group:insert(game)
-- game.x, game.y = _W/2, _H/2
global_group:insert(hero)
-- hero.x, hero.y = _W/2, _H/2
global_group:insert(ui)
global_group:insert(face)
-- face.x, face.y = _W/2, _H/2
global_group.x, global_group.y = _W/4, _H/4
global_group:scale(xscale_k, yscale_k)
-- global_group:removeSelf()

local main_src = display.newGroup()
main_src:insert(global_group)

local menu_src = display.newGroup()
local story_src = display.newGroup()

-----------------------------------------------------------
hero.W, game.unitW = 97.5, 97.5
hero.H, game.unitH = 86.25, 86.25
game.unitR = 90
game.help_counter = 0
game.difficulty = 2
game.time_to_task = 20000
game.mainFont = 'Comic Sans MS'
game.streak = 0
game.maxscore = 0
game.maxscoredif = 2
-----------------------------------------------------------

local body = display.newCircle(hero, 0, 0, 30);
body.alpha = 0;
local laser = display.newGroup()
hero:insert(laser)
local laser_body = display.newRect(laser, -3, 0, 70, 300)
laser_body.y = -laser_body.height/2 -- 55
laser_body.alpha = 0
local jet = display.newImage(laser, 'img/jet.png', laser_body.x, laser_body.y )


laser.alpha = 0
local heroico = display.newImage(hero, 'img/mainch4.png', 0, 0)
-- face:scale(3.75, 3.75)
game.hero_velocity = 5

local walls = display.newGroup()
-- walls.x, walls.y = 0, 0
game:insert(walls)

local walls_tb = {}


game.grannys_tb = {}
function game:test_spawn1()
	local gr1 = Unit:new(_W/2, _H/2 + 300, game, math.random() * 2 + 1, game.grannys_tb, 'granny')
	gr1.spawn()
	local gr2 = Unit:new(_W/2, _H/2 - 300, game, math.random() * 2 + 1, game.grannys_tb, 'granny')
	gr2.spawn()

	table.insert(game.grannys_tb, gr1)
	table.insert(game.grannys_tb, gr2)
end
function game:test_spawn2(velocity)
	local v = velocity or 0 
	local gr1 = Unit:new(_W/2 + 210, _H*1.6, game, v, game.grannys_tb, 'granny')
	gr1.spawn()
	table.insert(game.grannys_tb, gr1)
end
-- game:test_spawn1()

local path = system.pathForFile("img/first.txt")
local file, errorString = io.open( path, "r" )
 
if not file then
    -- Error occurred; output the cause
    print( "File error: "..errorString)
else
    -- Read data from file
	local n = file:read( "*n" )
	for i=1, n do
		x1, y1, x2, y2 = file:read( "*n" ), file:read( "*n" ), file:read( "*n" ), file:read( "*n" )
		
		local wall = display.newRect(walls, x1+_W/2-game.size_of_map/2, y1+_H/2-game.size_of_map/2, x2-x1 , y2-y1);
		wall.x = wall.x + wall.width/2
		wall.y = wall.y + wall.height/2
		wall.alpha = 0;
		table.insert(walls_tb, wall);
		
		print(x1, y1, x2, y2)
    end
    io.close( file )
end
file = nil


local d_down, w_down, s_down, a_down = false, false, false, false
game.is_paused = false

local next_spawn = system.getTimer()
local prev_quartal = 1
function game:spawn_enemies()
	local delta = 1400 * (4 - game.difficulty) - 70*game.streak
	local now = system.getTimer()
	if now > next_spawn then
		next_spawn = now + delta
		
		local xk, yk
		if prev_quartal == 1 then
			xk, yk = -1, -1
			prev_quartal = 3
		elseif prev_quartal == 3 then
			xk, yk = -1, 1
			prev_quartal = 2
		elseif prev_quartal == 2 then
			xk, yk = 1, -1
			prev_quartal = 4
		elseif prev_quartal == 4 then
			xk, yk = 1, 1
			prev_quartal = 1
		end
		
		local types = {'schoolman', 'granny'}
		
		local enemy = Unit:new(_W/2 + 210*xk, -game.y + _H/2 + _H*1.15*yk, game, math.random() * 2 + 1, game.grannys_tb, types[math.random(1,2)])
		enemy.spawn()
		table.insert(game.grannys_tb, enemy)
	end
end

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
	game.is_laser_on = false
end

function game:gameOver()
	game:pause()
	
	local gameover = display.newGroup()
	face:insert(gameover)
	local bg = display.newRect(gameover, _W/2, _H/2, _W*2, _H*2)
	bg:setFillColor(0)
	bg.alpha = 0.2
	local tab = display.newImage(gameover, 'img/ru_newgameover2.png', _W/2, _H/2)
	local scoretxt = display.newText(gameover, 'Ваш счет: '..game.streak, _W/2, _H*0.71, game.mainFont, 110*xscale_k)
	scoretxt:setTextColor(0)
	bg:addEventListener('tap', function()
		if game.streak > game.maxscore then
			game.maxscore = game.streak
			game.maxscoredif = game.difficulty
		end
		game.streak = 0
		game:update_score()
		gameover:removeSelf()
		game:restart()
		game:resume()
	end)
end

function game:restart()
	for i=#game.grannys_tb, 1, -1 do
		game.grannys_tb[i]:kill()
	end
	game.x, game.y, game.vx, game.vy = 0, 0, 0, 0
	game.is_laser_on = false
end

function game:update_score()
	transition.to(streaktxt, {time=150, alpha=0, onComplete=function()
		streaktxt:removeSelf()
		streaktxt = display.newText(ui, 'Счет: '..game.streak, streakbg.x, streakbg.y, 'Comic Sans MS', 50)
		streaktxt:setTextColor(0)
		streaktxt.alpha = 0
		transition.to(streaktxt, {time=150, alpha=1})
	end})
end

function game:remove_from_tb_by_item(tb, item)
	for i=#tb, 1, -1 do
		if tb[i] == item then
			print(item, tb[i])
			table.remove(tb, i)
		end
	end
end

function game:generate_exercise(difficulty, base)
	base = base or 2
	
	local function get_borders()
		if difficulty == 1 then -- 2-4 number of characters (знаков в числе)
			min_val = base
			max_val = base ^ 3 + base ^ 2 + base + 1
		elseif difficulty == 2 then -- 3-5 number of characters (знаков в числе)
			min_val = base ^ 2
			max_val = base ^ 4 + base ^ 3 + base ^ 2 + base + 1
		elseif difficulty == 3 then -- 4-6 number of characters (знаков в числе)
			min_val = base ^ 3
			max_val = base ^ 5 + base ^ 4 + base ^ 3 + base ^ 2 + base + 1
		else
			print('error: wrong difficulty')
			return 0
		end
		return {min_val, max_val}
	end
	
	local min_n, max_n = get_borders()[1], get_borders()[2]
	local n = math.round(math.random() * (max_n - min_n) + min_n)
	local code_n = game:ten_to_another(n, base)
	
	return {code_n, n}
end

function game:ten_to_another(num, base)
	base = base or 2
	local old_num = num
	
    digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'}
	
    local result = ''
    while num > 0 do
        result = digits[num % base + 1]..result
        num = math.floor(num / base)
	end
	
    return result
end

function game:another_to_ten(num, base)
	base = base or 2
	num = tonumber(tostring(num), base)
	return num
end

function game:pause_src()
	game:pause()
	local pause = display.newGroup()
	face:insert(pause)
	local pausebg = display.newRect(pause, _W/2, _H/2, _W*2, _H*2)
	pausebg:setFillColor(0)
	pausebg.alpha = 0.5
	
	local src = display.newImage(pause, 'img/pause.png', _W/2, _H/2)
	src:scale(1,1)
	local dtxt = display.newText(pause, 'Пауза', _W/2, _H/2 - 100, game.mainFont, 220*xscale_k)
	dtxt:setTextColor(0)
	local selector = display.newRect(pause, -_W*5, -_H*5, 200, 200)
	selector:setFillColor(0)
	local playbtn = display.newImage(pause, 'img/playbtn.png', _W*3/5, _H*8/13)
	
	local backbtn = display.newImage(pause, 'img/backbtn.png', _W*2/5, _H*8/13)
	
	playbtn:addEventListener('tap', function(e)
		pause:removeSelf()
		game:resume()
	end)
	backbtn:addEventListener('tap', function(e)
		local an = display.newRect(_W/2, _H/2, _W*2, _H*2)
		an:setFillColor(0)
		an.alpha = 0
		transition.to(an, {time=200, alpha=1, onComplete=function()
			if game.streak > game.maxscore then
				game.maxscore = game.streak
			end
			game.streak = 0
			game:update_score()
			
			pause:removeSelf()
			main_src:collapse()
			menu_src:show()
			transition.to(an, {time=200, delay=50, alpha=0})
		end})
	end)
	
	-- pausebg:addEventListener('mouse', function(e)
		-- print(e.x, e.y, playbtn.x-playbtn.width/4, playbtn.x+playbtn.width/4, playbtn.y+playbtn.height/4, playbtn.y-playbtn.height/4)
		-- if e.x >= playbtn.x-playbtn.width/2 and e.x <= playbtn.x+playbtn.width/2 and e.y <= playbtn.y+playbtn.height/2 and e.y >= playbtn.y-playbtn.height/2 then
			-- selector.x, selector.y = playbtn.x, playbtn.y
			-- print('play')
		-- elseif e.x >= backbtn.x- and e.x <= backbtn.x+ and e.y <= backbtn.y+ and e.y >= backbtn.y- then
			-- selector.x, selector.y = backbtn.x, backbtn.y
		-- else
			-- selector.x, selector.y = -_W*5, -_H*5
		-- end
	-- end)
	
end

function laser_on()
	if laser.alpha < 0.5 then
		laser.alpha = laser.alpha + 0.035
	elseif laser.alpha >= 0.5 and laser.alpha < 0.9 then
		laser.alpha = 0.95
	elseif laser.alpha >= 0.94 and laser.alpha < 1 then
		laser.alpha = laser.alpha + 0.01
	end
	-- print(laser.alpha..' on')
end
function laser_off()
	if laser.alpha > 0.9 then
		laser.alpha = laser.alpha - 0.01
	elseif laser.alpha <= 0.9 and laser.alpha > 0.5 then
		laser.alpha = 0.5
	elseif laser.alpha <= 0.5 and laser.alpha > 0 then
		laser.alpha = laser.alpha - 0.05
	end
	-- print(laser.alpha..' off')
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
		if (event.keyName == 'escape' and event.phase == 'down'  ) then
			game:pause_src()
		end
	end
	
	-- if (event.keyName == 'p' and event.phase == 'down'  ) then
		-- for i=1,#game.grannys_tb do
			-- unit = game.grannys_tb[i]
			-- unit:changePhase(1)
		-- end
	-- end
	-- if (event.keyName == 'r' and event.phase == 'down'  ) then
		-- for i=1,#game.grannys_tb do
			-- unit = game.grannys_tb[i]
			-- unit:changePhase(0)
		-- end
	-- end
	
	-- if (event.keyName == 'n' and event.phase == 'down'  ) then
		-- if game.is_paused then
			-- game:resume()
		-- else
			-- game:pause()
		-- end
	-- end
	-- if (event.keyName == 'k' and event.phase == 'down'  ) then
		-- print(#game.grannys_tb)
		-- if #game.grannys_tb ~= 0 then
			-- game.grannys_tb[1]:kill()
		-- end
	-- end
	-- if (event.keyName == 'l' and event.phase == 'down'  ) then
		-- local gr = Unit:new(_W/2 + math.random(-200, 200), _H/2 + math.random(-500, 500), game, math.random() * 2 + 1, game.grannys_tb, 'granny')
		-- gr.spawn()
		-- table.insert(game.grannys_tb, gr)
	-- end
	
	
    return false
end
Runtime:addEventListener("key", onKeyEvent )

function hero:getX()
	return game.size_of_map/2 - game.x
end
function hero:getY()
	return game.size_of_map/2 - game.y
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

function game:check_laser_collision()
	local min_gr;
	local min_dist = 99999999;
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

game.is_laser_on = false
Runtime:addEventListener('enterFrame', function()
	if not game.is_paused then
		hero:move()
		game:spawn_enemies()
		
		for i=#game.grannys_tb, 1, -1 do
			game.grannys_tb[i]:move()
		end
		
		if laser.alpha == 1 then
			laser_gr = game:check_laser_collision()
			if laser_gr ~= nil then
				laser_gr:show_task()
			end
		end
		
		if game.is_laser_on then
			laser_on()
		else
			laser_off()
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
		
		if event.type == 'down' and event.isPrimaryButtonDown and not event.isSecondaryButtonDown then
			-- print('down')
			if vx == 5 then game.vx = 2 elseif vx == -5 then game.vx = -2 else game.vx = 0 end
			if vy == 5 then game.vy = 2 elseif vy == -5 then game.vy = -2 else game.vy = 0 end
			game.hero_velocity = 2
			game.is_laser_on = true
		end
		if event.type == 'up' and game.is_laser_on then 
			-- print('up')
			if vx == 2 then game.vx = 5 elseif vx == -2 then game.vx = -5 else game.vx = 0 end
			if vy == 2 then game.vy = 5 elseif vy == -2 then game.vy = -5 else game.vy = 0 end
			game.hero_velocity = 5
			laser_off()
			game.is_laser_on = false
		end
	end
end
Runtime:addEventListener("mouse", onMouseEvent)


ui.x, ui.y = ui.x - _W/2, ui.y - _H/2
pausebtn.xScale, pausebtn.yScale = 1.3, 1.3
pausebtn.x, pausebtn.y = pausebtn.width, pausebtn.height

pausebtn:addEventListener('tap', function(e)
	if not game.is_paused then
		game:pause_src()
	end
end)

function ui:show_tutorial()
	local tutorial = display.newGroup()
	ui:insert(tutorial)
	game:pause()
	local blackbg = display.newRect(tutorial, _W, _H, _W*5, _H*5)
	blackbg:setFillColor(0)
	blackbg.alpha = 0.5
	
	local tutorialwnd = display.newImage(tutorial, 'img/tutorial.png', _W, _H)
	
	blackbg:addEventListener('tap', function(e)
		tutorial:removeSelf()
		game:resume()
	end)
end


local menu = display.newGroup()
menu_src:insert(menu)

local menubg = display.newImage(menu, 'img/menu169.png', _W/2, _H/2)
menubg:scale(xscale_k*(4/3), yscale_k*(4/3))
local titletxt = display.newText(menu, "Teacher's  hardship", _W/2, _H*5/16, game.mainFont, 200*xscale_k)
titletxt:setTextColor(0)



local buttons = {}
local diff_buttons = {}
local function addBtn(x, y, bg_img, txt, group)
	local btn = display.newGroup()
	btn.x, btn.y = x, y
	menu:insert(btn)
	local selector = display.newRect(btn, 0, 0, 0, 0)
	selector:setFillColor(0, 0, 1)
	selector.isVisible = false
	local bg = display.newImage(btn, bg_img, 0, 0)
	bg:scale(xscale_k, yscale_k)
	local selector_thickness = math.max(bg.width / 33, 10)
	local dtxt = display.newText(btn, txt, 0, 0, game.mainFont, 90*xscale_k)
	dtxt:setTextColor(0)
	selector.width, selector.height = bg.width*xscale_k + selector_thickness, bg.height*yscale_k + selector_thickness
	table.insert(group, {btn, selector})
	return btn
end
playbtn = addBtn(_W/2, _H*10/17, 'img/buttonmain.png', 'Играть', buttons)
-- settingsbtn = addBtn(_W/2, playbtn.y + playbtn.height, 'img/buttonmain.png', 'Settings', buttons)
exitbtn = addBtn(_W/2, playbtn.y + playbtn.height + 10, 'img/buttonmain.png', 'Выход', buttons)
diff3 = addBtn(_W - _W/16, _H/10, 'img/diff3.png', '', diff_buttons)
diff2 = addBtn(diff3.x - diff3.width*1.2, diff3.y, 'img/diff2.png', '', diff_buttons)
diff1 = addBtn(diff2.x - diff2.width*1.2, diff2.y, 'img/diff1.png', '', diff_buttons)
diff_buttons[2][2].isVisible = true
game.current_diff_selector = diff_buttons[2][2]

for i=1,#diff_buttons do
	local bg = diff_buttons[i][1]
	local selector = diff_buttons[i][2]
	bg:addEventListener('tap', function(e)
		if game.current_diff_selector ~= selector then
			game.difficulty = #diff_buttons - i + 1
			game.current_diff_selector.isVisible = false
			selector.isVisible = true
			game.current_diff_selector = selector
		end
	end)
end


local difftxt = display.newText(menu, 'Сложность:', diff1.x - diff1.width*3, diff1.y, game.mainFont, 70*xscale_k)
difftxt:setTextColor(0)

menubg:addEventListener('mouse', function(e)
	for i=1,#buttons do
		local bg = buttons[i][1]
		local selector = buttons[i][2]
		if e.x >= bg.x - bg.width/2*bg.xScale and e.x <= bg.x + bg.width/2*bg.xScale and e.y >= bg.y - bg.height/2*bg.yScale and e.y <= bg.y + bg.height/2*bg.yScale then
			selector.isVisible = true
		else
			selector.isVisible = false
		end
	end
	-- for i=1,#diff_buttons do
		-- bg = diff_buttons[i][1]
		-- selector = diff_buttons[i][2]
		-- if e.x >= bg.x - bg.width/2*bg.xScale and e.x <= bg.x + bg.width/2*bg.xScale and e.y >= bg.y - bg.height/2*bg.yScale and e.y <= bg.y + bg.height/2*bg.yScale then
			-- selector.isVisible = true
		-- else
			-- selector.isVisible = false
		-- end
	-- end
end)



local maxscoretxt1 = display.newText(menu, 'Макс. счет:', _W/5, _H*8/13, game.mainFont, 120*xscale_k)
local maxscoretxt2 = display.newText(menu, game.maxscore, maxscoretxt1.x, maxscoretxt1.y + maxscoretxt1.height, game.mainFont, 110*xscale_k)
local maxscoretxt3 = display.newText(menu, '(Сложность: '..game.maxscoredif..')', maxscoretxt2.x, maxscoretxt2.y + maxscoretxt2.height, game.mainFont, 70*xscale_k)
maxscoretxt1:setTextColor(0)
maxscoretxt2:setTextColor(0)
maxscoretxt3:setTextColor(0)

function menu_src:maxscoreupdate()
	maxscoretxt2:removeSelf()
	maxscoretxt3:removeSelf()
	maxscoretxt2 = display.newText(menu, game.maxscore, maxscoretxt1.x, maxscoretxt1.y + maxscoretxt1.height, game.mainFont, 110*xscale_k)
	maxscoretxt3 = display.newText(menu, '(Difficulty: '..game.maxscoredif..')', maxscoretxt2.x, maxscoretxt2.y + maxscoretxt2.height/1.5, game.mainFont, 40*xscale_k)
	maxscoretxt2:setTextColor(0)
	maxscoretxt3:setTextColor(0)
end

function main_src:show()
	main_src.alpha = 1
	game:resume()
	game:restart()
end
function main_src:collapse()
	main_src.alpha = 0
	game:pause()
end
function menu_src:show()
	menu_src.alpha = 1
	menu_src:maxscoreupdate()
end
function menu_src:collapse()
	menu_src.alpha = 0
end
main_src:collapse()
-- menu_src:collapse()

menu_src.first_play = true

playbtn:addEventListener('tap', function(e)
	local an = display.newRect(_W/2, _H/2, _W*2, _H*2)
	an:setFillColor(0)
	an.alpha = 0
	transition.to(an, {time=200, alpha=1, onComplete=function()
		if menu_src.first_play then
			story_src:show()
			menu_src:collapse()
		else
			main_src:show()
			menu_src:collapse()
		end
		
		transition.to(an, {time=200, delay=50, alpha=0})
	end})
end)
exitbtn:addEventListener('tap', function(e)
	native.requestExit()
end)
-- settingsbtn:addEventListener('tap', function(e)
	-- print(playbtn.y)
-- end)

local collision_bg = display.newRect(story_src, _W/2, _H/2, _W*2, _H*2)
collision_bg.alpha = 0.05

function story_src:show()
	story_src.alpha = 1
end
function story_src:collapse()
	story_src.alpha = 0
end
story_src:collapse()

local count_of_scenes = 33
local current_scene = 1
local can_skip_delta = 1000
local can_skip_time = 0
local scenes = {}

for i=count_of_scenes,1,-1 do
	local img = display.newImage(story_src, 'img/scenes/'..i..'.png', _W/2, _H/2)
	table.insert(scenes, img)
	if i == 1 then
		img:addEventListener('tap', function(e)
			story_src:next()
		end)
	end
end

function story_src:next(skip)
	if system.getTimer() >= can_skip_time then
	
		can_skip_time = system.getTimer() + can_skip_delta
		
		skip = skip or false
		-- print(skip, current_scene == count_of_scenes or skip)
		if current_scene == count_of_scenes or skip then
			local an = display.newRect(_W/2, _H/2, _W*2, _H*2)
			an:setFillColor(0)
			an.alpha = 0
			transition.to(an, {time=200, alpha=1, onComplete=function()
			
				story_src:collapse()
				main_src:show()
				ui:show_tutorial()
				menu_src.first_play = false
				
				transition.to(an, {time=200, delay=1000, alpha=0})
			end})
			return
		end
		
		cur_scene = scenes[count_of_scenes - current_scene + 1]
		current_scene = current_scene + 1
		print('Scene: '..current_scene)
		next_scene = scenes[count_of_scenes - current_scene + 1]
		
		local an = display.newRect(_W/2, _H/2, _W*2, _H*2)
		an:setFillColor(0)
		an.alpha = 0
		transition.to(an, {time=200, alpha=1, onComplete=function()
		
			cur_scene.alpha = 0
			next_scene:addEventListener('tap', function(e)
				story_src:next()
			end)
			
			transition.to(an, {time=200, delay=50, alpha=0})
		end})
	end
end


local skipbtn_selector = display.newRect(story_src, 0, 0, 0, 0)
local skipbtn = display.newImage(story_src, 'img/scenes/ru_skipbtn.png', 0, 0)
skipbtn:scale(xscale_k*1.2, yscale_k*1.2)
skipbtn.x, skipbtn.y = _W - skipbtn.width*xscale_k*1.2/2 - 50, _H - skipbtn.height*xscale_k*1.2/2 - 30
skipbtn_selector:setFillColor(1)
skipbtn_selector.isVisible = true
skipbtn_selector.x, skipbtn_selector.y = skipbtn.x, skipbtn.y
skipbtn_selector.width, skipbtn_selector.height = skipbtn.width*xscale_k*1.2 + 8, skipbtn.height*yscale_k*1.2 + 8
story_src:addEventListener('mouse', function(e)
	local bg = skipbtn
	local selector = skipbtn_selector
	if e.x >= bg.x - bg.width/2*bg.xScale and e.x <= bg.x + bg.width/2*bg.xScale and e.y >= bg.y - bg.height/2*bg.yScale and e.y <= bg.y + bg.height/2*bg.yScale then
		selector.isVisible = true
	else
		selector.isVisible = false
	end
end)

skipbtn:addEventListener('tap', function(e)
	story_src:next(true)
end)