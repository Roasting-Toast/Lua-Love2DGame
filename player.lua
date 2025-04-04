player = {
	player_table = {
		moveX = 0,
		moveY = 0,
		speed = 100,
		x = 1,
		y = 1,
		sprite = love.graphics.newImage("sprites/player.png"),
		current_animation = "south_idle",
		animation = { 
			timer = 0,
			frame = 1,
			south_idle = {
				min_frames = 1,
				max_frames = 6
			},
			east_idle = {
				min_frames = 7,
				max_frames = 12
			},
			west_idle = {
				min_frames = 7,
				max_frames = 12,
				flip = true
			},
			north_idle = {
				min_frames = 13,
				max_frames = 18
			},
			south_walking = {
				min_frames = 19,
				max_frames = 24
			},
			north_walking = {
				min_frames = 31,
				max_frames = 36
			},
			east_walking = {
				min_frames = 25,
				max_frames = 30
			},
			west_walking = {
				min_frames = 25,
				max_frames = 30,
				flip = true
			}
		}
	}
}
	 function player:spriteSheet()
		-- Sets a texture filter on the sprite so it isn't blurry
		self.player_table.sprite:setFilter("nearest")

		-- Total size of the sprite sheet and size of each sprite
		SPRITE_WIDTH, SPRITE_HEIGHT = 288, 480
		QUAD_WIDTH, QUAD_HEIGHT = 48, 48
	
		quads = {}

		-- Equation for picking out which frame of the sprite sheet
		for i = 1, 60 do
			xStartingPoint = i <= 6 and (i - 1) * QUAD_WIDTH or (i - 1) % 6 * QUAD_WIDTH 
			yStartingPoint = math.floor((i - 1) / 6) * QUAD_HEIGHT
			quads[i] = love.graphics.newQuad(xStartingPoint, yStartingPoint, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
		end
	end
return player