menu = {
	button_table = {
	sprite = love.graphics.newImage("sprites/buttons.png"),
	button_indices = {
		play = 2,
		settings = 3,
		retry = 4,
		bars = 5,
		pause = 6,
		volume = 7,
		mute = 8,
		store = 9,
		save = 10,
		no = 11,
		yes = 12
	}
}

	function menu:spriteSheet()
		self.button_table.sprite:setFilter("nearest")

		SPRITE_WIDTH, SPRITE_HEIGHT = 96, 48
		QUAD_WIDTH, QUAD_HEIGHT = 16, 16

		quads = {}

		for i = 1, 12 do
			xStartingPoint = i <= 6 and (i - 1) * QUAD_WIDTH or (i - 1) % 6 * QUAD_WIDTH
			yStartingPoint = math.floor((i - 1) / 6) * QUAD_HEIGHT
			quads[i] = love.graphics.newQuad(xStartingPoint, yStartingPoint, QUAD_WIDTH, QUAD_HEIGHT, SPRITE_WIDTH, SPRITE_HEIGHT)
		end
	end
return menu