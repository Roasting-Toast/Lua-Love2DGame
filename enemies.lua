_G.love = require("love")

function Enemy()
	return {
		level = 1,
		radius = 20,
		x = -10,
		y = -50,

		move = function(self, player_x, player_y)
			if player_x - self.x > 0 then
				self.x = self.x + self.level
	}