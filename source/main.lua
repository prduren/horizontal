import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx = playdate.graphics

local roomSprite = nil

-- A function to set up our game environment.

function roomOneSetUp()

    -- Set up the room sprite.

    local roomImage = gfx.image.new("Images/roomOne.png")
    
    roomSprite = gfx.sprite.new( roomImage )
    roomSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    roomSprite:add() -- This is critical!

end

roomOneSetUp()

-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

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

    gfx.sprite.update()

end