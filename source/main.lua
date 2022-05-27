-- to compile in git bash:
--  pdc -sdkpath "C:\Users\Parker\Documents\PlaydateSDK" "D:\Repos\Horizontal\source" "D:\Repos\Horizontal.pdx"
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

local gfx = playdate.graphics

local textBoxX, textBoxY = 95, 55
local textX, textY = 95, 55

--disable crank sounds
playdate.setCrankSoundsDisabled(disable)

-- state used to apply current room/scene
local state = "intro"

-- these flags are to make sure room setup functions only get called once, since they're in playdate.update()
roomOneCallFlag = true
roomTwoCallFlag = true

-- fade in/out of black
function fade(fadeTime, --[[optional]]imageSource)

	local blackImage = gfx.image.new(imageSource or "Images/fade/black.png")
	blackImage:draw(0, 0)
	playdate.wait(fadeTime)

end

function intro()
	local introImage = gfx.image.new("Images/titleScreen.png")
    
    introSprite = gfx.sprite.new( introImage )
    introSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    introSprite:add() -- This is critical!

	if playdate.buttonIsPressed( playdate.kButtonA ) then
		fade(1000)
		playdate.graphics.clear()
		state = "roomOne"
	end
end

function roomOneSetUp()
	gfx.sprite.removeAll()
	gfx.clear()
	enemyFound = false
    local roomImage = gfx.image.new("Images/roomOne.png")
    local footImage = gfx.image.new("Images/foot.png")

    roomSprite = gfx.sprite.new( roomImage )
    roomSprite:moveTo( 200, 120 ) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
    roomSprite:add() -- This is critical!

	footSprite = gfx.sprite.new( footImage )
    footSprite:moveTo( 130, 420 ) 
    footSprite:add()

end

function roomOne()

	-- return x and y for collision
	x,y = gfx.sprite.getPosition(roomSprite);

	--check to see if we're in zoomed out state
	if (playdate.display.getScale() == 1) and enemyFound == false then

		-- get crank change
		local change = playdate.getCrankChange(change, acceleratedChange);

		-- move the roomSprite by the crank change value
		-- also check to make sure the image position doesn't go out of bounds, bounce back a pixel if so
		if (y < 359 and y > -120) then
			roomSprite:moveBy( 0, change )
			footSprite:moveBy( 0, change )
		elseif (y > 359) then
			roomSprite:moveBy( 0, -1 )
			footSprite:moveBy( 0, -1 )
		elseif (y < -120) then
			roomSprite:moveBy( 0, 1 )
			footSprite:moveBy( 0, 1 )
		end

		-- set the scale to zoom
		-- enter zoomed state
		if playdate.buttonIsPressed(playdate.kButtonA) then

			playdate.display.setScale(4)

			-- wait for a sec so that the up input doesn't propogate down to zoomed state
			playdate.wait(100)

		end
	
	end

	-- check if we're zoomed. If so, do zoom unique controls
	if (playdate.display.getScale() == 4) then

		-- d-pad movement
		if playdate.buttonIsPressed( playdate.kButtonUp ) then
			if y < 360 then
				roomSprite:moveBy( 0, 2 )
				footSprite:moveBy( 0, 2 )
			else
				roomSprite:moveBy( 0, -2 )
				footSprite:moveBy( 0, -2 )
			end
			
		end
		if playdate.buttonIsPressed( playdate.kButtonRight ) then
			if x > -100 then
				roomSprite:moveBy( -2, 0 )
				footSprite:moveBy( -2, 0 )
			else
				roomSprite:moveBy( 2, 0 )
				footSprite:moveBy( 2, 0 )
			end
			
		end
		if playdate.buttonIsPressed( playdate.kButtonDown ) then
			if y > -300 then
				roomSprite:moveBy( 0, -2 )
				footSprite:moveBy( 0, -2 )
			else 
				roomSprite:moveBy( 0, 2 )
				footSprite:moveBy( 0, 2 )
			end
		end
		if playdate.buttonIsPressed( playdate.kButtonLeft ) then
			if x < 200 then
				roomSprite:moveBy( 2, 0 )
				footSprite:moveBy( 2, 0 )
			else
				roomSprite:moveBy( -2, 0 )
				footSprite:moveBy( -2, 0 )
			end
			
		end

		-- if press a then check area for enemy
		if playdate.buttonJustPressed(playdate.kButtonA) then
			local footX, footY = gfx.sprite.getPosition(footSprite)
			
			if footY < 60 and footY > 0 and footX > 24 and footX < 80 then
				--found the enemy
				playdate.wait(100)
				-- TODO: play sound?
				playdate.display.setScale(1)
				local enemyImage = gfx.image.new("Images/enemy.png")
				enemySprite = gfx.sprite.new( enemyImage )
				enemySprite:setScale(4)
    			enemySprite:moveTo( 200, 120 )
    			enemySprite:add()
				roomSprite:moveTo( 200, 120 )
				footSprite:moveTo( 130, 420 ) 
				enemyFound = true
			end
		end

		-- exit zoomed state if B button is pressed
		if playdate.buttonIsPressed(playdate.kButtonB) then

			playdate.display.setScale(1)
			roomSprite:moveTo( 200, 120 )
			footSprite:moveTo( 130, 420 ) 

		end

	end

	if enemyFound then

		local stabImage = gfx.image.new("Images/stab.png")
		stabSprite = gfx.sprite.new( stabImage )
		stabSprite:moveTo( 340, 80 )
		stabSprite:add() 

		if playdate.isCrankDocked() then
			fade(5000, "Images/fade/room2TitleScreen.png")
			state = "roomTwo"
		end

	end

end

function roomTwoSetUp()
	--to be used to decide when to pop the text box after some idle time in the room
	textBoxPopCounter = 0
	--value to be used to choose which frame to draw
	--incremented by cranking up or down
	roomTwoFrame = 0
	gfx.sprite.removeAll()
	gfx.clear()
	playdate.graphics.setBackgroundColor(gfx.kColorClear)
	roomTwoAnimation = gfx.imagetable.new("Images/roomTwoAnimation.gif")
	roomTwoAnimation:getImage(1):draw(0, 0)
	local bedImage = gfx.image.new("Images/bed.png")
	bedSprite = gfx.sprite.new( bedImage )
    bedSprite:moveTo( 200, 220 )
    bedSprite:add()
	local textBoxImage = gfx.image.new("Images/textBox.png")
	textBoxSprite = gfx.sprite.new( textBoxImage )
end

function roomTwo()
	local tickCounter = playdate.getCrankTicks(8)
	-- every time a tick gets hit, add 1 to roomTwoFrame
	-- also increment textBoxPopCounter to pop text box after messing around in the room for a bit
	if tickCounter == 1 and roomTwoFrame < 8 then
		textBoxPopCounter = textBoxPopCounter + 1
		roomTwoFrame = roomTwoFrame + 1
		roomTwoAnimation:getImage(roomTwoFrame):draw(0, 0)
		bedSprite:moveBy( 0, -5)
	elseif tickCounter == -1 and roomTwoFrame > 1 then
		textBoxPopCounter = textBoxPopCounter + 1
		roomTwoFrame = roomTwoFrame - 1
		roomTwoAnimation:getImage(roomTwoFrame):draw(0, 0)
		bedSprite:moveBy( 0, 5 )
	end

	if textBoxPopCounter == 5 then
		textBoxSprite:moveTo( textBoxX, textBoxY )
    	textBoxSprite:add()
		local text1img = gfx.image.new("Images/text/text1.png")
		text1 = gfx.sprite.new(text1img)
		text1:moveTo(textX,textY)
		text1:add()
	end

	if textBoxPopCounter == 10 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX,textY + 35)
	 	text2:add()
	end

	if textBoxPopCounter == 15 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 5,textY + 20)
	 	text2:add()
	end

	if textBoxPopCounter == 20 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 10,textY + 10)
	 	text2:add()
	end

	if textBoxPopCounter == 25 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX - 2,textY - 10)
	 	text2:add()
	end

	if textBoxPopCounter == 30 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 7,textY + 40)
	 	text2:add()
	end

	if textBoxPopCounter == 40 or textBoxPopCounter > 40 then
		textBoxSprite:setZIndex(30000)
		local text3img = gfx.image.new("Images/text/text3.png")
		local text3 = gfx.sprite.new(text3img)
		text3:setZIndex(30001)
		text3:moveTo(textX,textY)
	 	text3:add()
		playdate.wait(3000)
		fade(5000, "Images/fade/room3TitleScreen.png")
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
	-- call roomTwo and roomTwoSetup after roomOne end
	if (state == "roomTwo") then
		if roomTwoCallFlag == true then
			roomTwoSetUp()
			roomTwoCallFlag = false
		end
		roomTwo()
	end
	
    gfx.sprite.update()
	playdate.timer.updateTimers()

end