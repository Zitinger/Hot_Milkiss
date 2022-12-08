local granny = {}

function granny.spawn(x, y, game)
	
	local gr = display.newGroup()
	game:insert(gr)
	gr.x = x
	gr.y = y
	local body = display.newCircle(gr, 0, 0, 35)
	body.alpha = 0.3
	local face = display.newImage(gr, 'img/angry_granny.png')
	return gr
	
end

return granny;