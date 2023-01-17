local schoolboy = {}

function schoolboy.spawn(x, y, game)
	
	local sch = display.newGroup()
	game:insert(sch)
	sch.x = x
	sch.y = y
	local body = display.newCircle(sch, 0, 0, 35)
	body.alpha = 0.3
	local face = display.newImage(sch, 'img/Schoolman.png')
	return sch
	
end

return schoolboy;