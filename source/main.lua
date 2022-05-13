import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics
-- local roomSprite = nil
-- state used to apply current room/scene
local state = "intro"

--this flag is to make sure roomOneSetUp only gets called once, since its in playdate.update()
roomOneCallFlag = true

function intro()
	local introImage = gfx.image.new("Images/titleScreen.png")
    
    introSprite = gfx.sprite.new( introImage )
    introSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    introSprite:add() -- This is critical!

	if playdate.buttonIsPressed( playdate.kButtonA ) then
		playdate.graphics.clear()
		state = "roomOne"
	end
end

function roomOneSetUp()

    local roomImage = gfx.image.new("Images/roomOne.png")
    
    roomSprite = gfx.sprite.new( roomImage )
    roomSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    roomSprite:add() -- This is critical!

end

function roomOne()
	--check to see if we're in zoomed out state
	if (playdate.display.getScale() == 1) then

		-- get crank change
		local change = playdate.getCrankChange(change, acceleratedChange);

		local x,y = gfx.sprite.getPosition(roomSprite);

		-- move the roomSprite by the crank change value
		-- also check to make sure the image position doesn't go out of bounds, bounce back a pixel if so
		if (y < 359 and y > -120) then
			roomSprite:moveBy( 0, change )
		elseif (y > 359) then
			roomSprite:moveBy( 0, -1 )
		elseif (y < -120) then
			roomSprite:moveBy( 0, 1 )
		end

		-- set the scale to zoom

		-- enter zoomed state
		if playdate.buttonIsPressed(playdate.kButtonUp) then

			playdate.display.setScale(4)

			-- wait for a sec so that the up input doesn't propogate down to zoomed state
			playdate.wait(100)

		end

	end
	


	-- check if we're zoomed. If so, do zoom unique controls
	if (playdate.display.getScale() == 4) then
		-- d-pad movement

		if playdate.buttonIsPressed( playdate.kButtonUp ) then
			roomSprite:moveBy( 0, 2 )
		end
		if playdate.buttonIsPressed( playdate.kButtonRight ) then
			roomSprite:moveBy( -2, 0 )
		end
		if playdate.buttonIsPressed( playdate.kButtonDown ) then
			roomSprite:moveBy( 0, -2 )
		end
		if playdate.buttonIsPressed( playdate.kButtonLeft ) then
			roomSprite:moveBy( 2, 0 )
		end

		-- if press a then check area for enemy
		-- if enemy found then set scale to 1, begin fight sequence and exit zoom

		-- exit zoomed state if B button is pressed
		if playdate.buttonIsPressed(playdate.kButtonB) then

			playdate.display.setScale(1)
			roomSprite:moveTo( 200, 120 )

		end

	end
end

function playdate.update()

	if (state == "intro") then
		intro()
	end
	-- call roomOne and roomOneSetUp after opening sequence
	if (state == "roomOne") then
		if roomOneCallFlag == true then
			roomOneSetUp()
			roomOneCallFlag = false
		end
		roomOne()
	end
	

    gfx.sprite.update()

end