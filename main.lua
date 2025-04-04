_G.love = require("love")
local player = require("player")
GAMESTATE_PAUSED = "paused"
GAMESTATE_MENU = "menu"
GAMESTATE_RUNNING = "running"
GAMESTATE_ENDED = "ended"
local game = {
	state = GAMESTATE_RUNNING
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
	player:spriteSheet()
end

function love.keypressed(key)
	if key == "escape" and (game.state == GAMESTATE_RUNNING or game.state == GAMESTATE_PAUSED) then
		if game.state == GAMESTATE_PAUSED then
			game.state = GAMESTATE_RUNNING
		else
			game.state = GAMESTATE_PAUSED
		end

		print("Game is".. game.state)
	end
end

function love.update(dt)
	local player = player.player_table
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
	if game.state == GAMESTATE_RUNNING then
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
	end
	-- Resets the animation when it changes animation
	if last_animation ~= player.current_animation then
		player.animation.frame = player.animation[player.current_animation].min_frames
	end
end

function love.draw()
	local player = player.player_table
	love.graphics.printf("FPS: " .. love.timer.getFPS(), love.graphics.newFont(16), 10, 10, love.graphics.getWidth())
	if game.state["menu"] then
		love.graphics.draw()
		love.graphics.scale(5)
	if game.state == GAMESTATE_RUNNING then
		-- Flips Sprite for A/D movement
		flip = player.animation[player.current_animation].flip and -1 or 1
		-- Tells the code how to render the sprite with the blank margins
		x_offset = player.animation[player.current_animation].flip and 48 or 0
		-- Bigger sprite
		love.graphics.scale(5)
		-- Draws sprite
		love.graphics.draw(player.sprite, quads[player.animation.frame], 
		player.x, player.y, 0, flip, 1, x_offset)
	end
end