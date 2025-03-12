_G.love = require("love")

local game = {
	state = {
		menu = false,
		paused = false,
		running = false,
		ended = false
	}
}

function normalizeVector(x, y)
    local length = math.sqrt(x * x + y * y)
    if length == 0 then
        return 0, 0
    else
        return x / length, y / length
    end
end

function love.load()
	love.mouse.setVisible(false)
	love.window.setTitle("Game")
	player = {
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

	-- Sets a texture filter on the sprite so it isn't blurry
	player.sprite:setFilter("nearest")

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

function love.update(dt)

		--Runs animation on delta time
		player.animation.timer = player.animation.timer + dt
		


		-- Update the frame of the animation based on a timer
		if player.animation.timer > 0.2 then
			player.animation.timer = 0	
			player.animation.frame = player.animation.frame + 1

			if player.animation.frame > player.animation[player.current_animation].max_frames then
				player.animation.frame = player.animation[player.current_animation].min_frames
			end
		end

		--Stores the last animation
		last_animation = player.current_animation

	-- Movement controls
	if love.keyboard.isDown("a") 
	or love.keyboard.isDown("d")
	or love.keyboard.isDown("s")
	or love.keyboard.isDown("w") then
		if love.keyboard.isDown("a") then
			player.moveX = -1
			player.current_animation = "west_walking"
		end
		if love.keyboard.isDown("d") then
			player.moveX = 1	
			player.current_animation = "east_walking"
		end
		if love.keyboard.isDown("s") then
			player.moveY = 1
			player.current_animation = "south_walking"
		end
		if love.keyboard.isDown("w") then
			player.moveY = -1
			player.current_animation = "north_walking"
		end

		-- Normalize the movement vector
		player.moveX, player.moveY = normalizeVector(player.moveX, player.moveY)
		player.x = player.x + player.moveX * player.speed * dt
		player.y = player.y + player.moveY * player.speed * dt
		player.moveX, player.moveY = 0, 0

		-- Sets animation back to idle with no movement detected
	elseif player.current_animation == "south_walking" then
		player.current_animation = "south_idle"
	elseif player.current_animation == "north_walking" then
		player.current_animation = "north_idle"
	elseif player.current_animation == "east_walking" then
		player.current_animation = "east_idle"
	elseif player.current_animation == "west_walking" then
		player.current_animation = "west_idle"
	end

		-- Resets the animation when it changes animation
		if last_animation ~= player.current_animation then
			player.animation.frame = player.animation[player.current_animation].min_frames
		end
end

function love.draw()
	love.graphics.printf("FPS: " .. love.timer.getFPS(), love.graphics.newFont(16), 10, 10, love.graphics.getWidth())
	if game.state["running"] then
	-- Flips Sprite for A/D movement
	flip = player.animation[player.current_animation].flip and -1 or 1
	-- Tells the code how to render the sprite with the blank margins
	x_offset = player.animation[player.current_animation].flip and 48 or 0
	-- Bigger sprite
	love.graphics.scale(5)
	-- Draws sprite
	love.graphics.draw(player.sprite, quads[player.animation.frame], player.x, player.y, 0, flip, 1, x_offset)
	end
end