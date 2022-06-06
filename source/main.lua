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
playdate.setCrankSoundsDisabled(true)

-- state used to apply current room/scene
local state = "intro"

-- these flags are to make sure room setup functions only get called once, since they're in playdate.update()
introCallFlag = true
roomOneCallFlag = true
roomTwoCallFlag = true
roomThreeCallFlag = true
roomFourCallFlag = true
roomFiveCallFlag = true
endingCallFlag = true

--number rounding func
function round(number, decimals)
	local power = 10^decimals
	return math.floor(number * power) / power
end

-- fade in/out of black
function fade(fadeTime, --[[optional]]imageSource)

	local blackImage = gfx.image.new(imageSource or "Images/fade/black.png")
	blackImage:draw(0, 0)
	playdate.wait(fadeTime)

end

function introSetUp()
	introFrame = 0
	playdate.graphics.setBackgroundColor(gfx.kColorClear)
	introAnimation = gfx.imagetable.new("Images/titleScreen.gif")
	introAnimation:getImage(1):draw(0, 0)
	lockSound = playdate.sound.fileplayer.new("sound/doorLock.mp3")
	playdate.graphics.setBackgroundColor(gfx.kColorClear)
	postIntroAnimation = gfx.imagetable.new("Images/introAnimation.gif")
end

function intro()
    
	local introTickCounter = playdate.getCrankTicks(6)

	if introTickCounter == 1 and introFrame < 20 then
		introFrame = introFrame + 1
		introAnimation:getImage(introFrame):draw(0, 0)
	end

	if introFrame == 20 then
		lockSound:play()
		playdate.graphics.clear()
		gfx.sprite.removeAll()
		postIntroAnimation:getImage(2):draw(0, 0)
		playdate.wait(500)
		postIntroAnimation:getImage(1):draw(0, 0)
		playdate.wait(2000)
		postIntroAnimation:getImage(2):draw(0, 0)
		playdate.wait(500)
		postIntroAnimation:getImage(3):draw(0, 0)
		playdate.wait(2000)
		postIntroAnimation:getImage(4):draw(0, 0)
		playdate.wait(1000)
		postIntroAnimation:getImage(5):draw(0, 0)
		playdate.wait(1000)
		postIntroAnimation:getImage(6):draw(0, 0)
		playdate.wait(500)
		postIntroAnimation:getImage(7):draw(0, 0)
		playdate.wait(250)
		postIntroAnimation:getImage(8):draw(0, 0)
		playdate.wait(500)
		postIntroAnimation:getImage(9):draw(0, 0)
		playdate.wait(2000)
		postIntroAnimation:getImage(10):draw(0, 0)
		playdate.wait(2000)
		postIntroAnimation:getImage(11):draw(0, 0)
		playdate.wait(500)
		postIntroAnimation:getImage(12):draw(0, 0)
		playdate.wait(1000)
		postIntroAnimation:getImage(13):draw(0, 0)
		playdate.wait(1000)
		postIntroAnimation:getImage(14):draw(0, 0)
		playdate.wait(1000)
		postIntroAnimation:getImage(15):draw(0, 0)
		playdate.wait(500)
		fade(4000, "Images/fade/room1TitleScreen.png")
		playdate.graphics.clear()
		gfx.sprite.removeAll()
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

		local change = playdate.getCrankChange(change, acceleratedChange);

		print(x, y)
		if y < 360 and y > -298 then
			roomSprite:moveBy( 0, change * .25 )
			footSprite:moveBy( 0, change * .25)
		elseif y > 360 or y < -298 then
			roomSprite:moveBy( 0, change * -1)
			footSprite:moveBy( 0, change * -1)
		end

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
			fade(4000, "Images/fade/room2TitleScreen.png")
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

	if textBoxPopCounter == 10 then
		textBoxSprite:moveTo( textBoxX, textBoxY )
    	textBoxSprite:add()
		local text1img = gfx.image.new("Images/text/text1.png")
		text1 = gfx.sprite.new(text1img)
		text1:moveTo(textX,textY)
		text1:add()
	end

	if textBoxPopCounter == 20 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX,textY + 35)
	 	text2:add()
	end

	if textBoxPopCounter == 25 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 5,textY + 20)
	 	text2:add()
	end

	if textBoxPopCounter == 30 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 10,textY + 10)
	 	text2:add()
	end

	if textBoxPopCounter == 33 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX - 2,textY - 10)
	 	text2:add()
	end

	if textBoxPopCounter == 36 then
		local text2img = gfx.image.new("Images/text/text2.png")
		local text2 = gfx.sprite.new(text2img)
		text2:moveTo(textX + 7,textY + 40)
	 	text2:add()
	end

	if textBoxPopCounter == 38 or textBoxPopCounter > 38 then
		textBoxSprite:setZIndex(30000)
		local text3img = gfx.image.new("Images/text/text3.png")
		local text3 = gfx.sprite.new(text3img)
		text3:setZIndex(30001)
		text3:moveTo(textX,textY)
	 	text3:add()
	end

	if textBoxPopCounter == 45 or textBoxPopCounter > 45 then
		fade(4000, "Images/fade/room3TitleScreen.png")
		state = "roomThree"
	end

end

function roomThreeSetUp()
	gfx.sprite.removeAll()
	gfx.clear()
	playdate.startAccelerometer()
	rightSound = playdate.sound.fileplayer.new("sound/right.mp3")
	leftSound = playdate.sound.fileplayer.new("sound/leftt.mp3")
	faceUpSound = playdate.sound.fileplayer.new("sound/putItDownNew.mp3")
	speakSound = playdate.sound.fileplayer.new("sound/find.mp3")
	rightSoundPlayed = false
	leftSoundPlayed = false
	faceUpSoundPlayed = false
	speakSoundPlayed = false
	playdate.wait(1000) --initial wait til first sound
	faceUpSound:play()
	faceUpSoundPlayed = true
end

function roomThree()

	--read accelerometer
	local x, y, z = playdate.readAccelerometer()

	-- round func to round accelerometer values to whole number
	roundedX, roundedY, roundedZ = round(x, 0), round(y, 0), round(z, 0)

	--playdate is laying face up
	if roundedX == -1.0 and roundedY == 0.0 and roundedZ == 0.0 then
		if faceUpSoundPlayed == true then
			print("you put it faceup!")
			playdate.wait(2000)
			leftSound:play()
			leftSoundPlayed = true
			faceUpSoundPlayed = false
		end
	end

	if roundedX == 0.0 and roundedY == -1.0 and roundedZ == -1.0 then
		if rightSoundPlayed == true then
			print("you turned it right!")
			playdate.wait(2000)
			speakSound:play()
			speakSoundPlayed = true
			rightSoundPlayed = false
			fade(4000, "Images/fade/room4TitleScreen.png")
			state = "roomFour"
		end
	end

	if (roundedX == -2.0 and roundedY == 0.0 and roundedZ == 0.0) or (roundedX == -2.0 and roundedY == -1.0 and roundedZ == -1.0) then
		if leftSoundPlayed == true then
			print("you turned it left!")
			playdate.wait(2000)
			leftSound:stop()
			rightSound:play()
			rightSoundPlayed = true
			leftSoundPlayed = false
		end
	end

end

function roomFourSetUp()
	gfx.sprite.removeAll()
	gfx.clear()
	playdate.stopAccelerometer()
	roomFourFinished = false
	roomFourFrame = 0
	playdate.graphics.setBackgroundColor(gfx.kColorClear)
	roomFourAnimation = gfx.imagetable.new("Images/roomFourAnimation.gif")
	roomFourAnimation:getImage(1):draw(0, 0)
	local textBoxImage = gfx.image.new("Images/textBox.png")
	textBoxSprite = gfx.sprite.new( textBoxImage )
	endSound = playdate.sound.fileplayer.new("sound/pressA.mp3")
	crashSound = playdate.sound.fileplayer.new("sound/crash.mp3")
end

function roomFour()
	local roomFourtickCounter = playdate.getCrankTicks(4)
	-- every time a tick gets hit, add 1 to roomFourFrame
	if roomFourtickCounter == 1 and roomFourFrame < 30 then
		roomFourFrame = roomFourFrame + 1
		roomFourAnimation:getImage(roomFourFrame):draw(0, 0)
	elseif roomFourtickCounter == -1 and roomFourFrame > 1 then
		roomFourFrame = roomFourFrame - 1
		roomFourAnimation:getImage(roomFourFrame):draw(0, 0)
	end

	if roomFourFrame == 30 then	
		roomFourFinished = true
	end

	if roomFourFinished then
		textBoxSprite:moveTo( textBoxX, textBoxY )
    	textBoxSprite:add()
		local text1img = gfx.image.new("Images/text/roomFourText.png")
		text1 = gfx.sprite.new(text1img)
		text1:moveTo(textX,textY)
		text1:add()
		endSound:play()
		crashSound:play()
		if playdate.buttonIsPressed(playdate.kButtonA) then
			endSound:stop()
			crashSound:stop()
			fade(4000, "Images/fade/room5TitleScreen.png")
			state = "roomFive"
		end
	end

end

function roomFiveSetUp()
	gfx.sprite.removeAll()
	gfx.clear()
	roomFiveFrame = 0
	roomFivePopCounter = 0
	playdate.graphics.setBackgroundColor(gfx.kColorClear)
	roomFiveImage = gfx.image.new("Images/roomFive.png")
	roomFiveImage:draw(0,0)
	darknessOverlay = gfx.imagetable.new("Images/darkness_overlay.gif")
	darknessOverlay:getImage(1):draw(0, 0)
	newEnemyImg = gfx.image.new("Images/roomFiveEnemy.png")
	newEnemy = gfx.sprite.new(newEnemyImg)
end

function roomFive()
	local roomFivetickCounter = playdate.getCrankTicks(8)
	-- every time a tick gets hit, add 1 to roomFourFrame
	if roomFivetickCounter == 1 and roomFiveFrame < 8 then
		roomFiveFrame = roomFiveFrame + 1
		roomFivePopCounter = roomFivePopCounter + 1
		gfx.sprite.removeAll()
		gfx.clear()
		roomFiveImage:draw(0,0)
		darknessOverlay:getImage(roomFiveFrame):draw(0, 0)
	elseif roomFivetickCounter == -1 and roomFiveFrame > 1 then
		roomFiveFrame = roomFiveFrame - 1
		darknessOverlay:getImage(roomFiveFrame):draw(0, 0)
	end

	if roomFivePopCounter > 14 and roomFivePopCounter < 16 then
		newEnemy:moveTo(120, 60)
		newEnemy:add()
	elseif roomFivePopCounter > 27 and roomFivePopCounter < 30 then
		newEnemy:setScale(2)
		newEnemy:moveTo(160, 100)
		newEnemy:add()
	elseif roomFivePopCounter > 49 and roomFivePopCounter < 55 then
		newEnemy:setScale(7)
		newEnemy:moveTo(200, 120)
		newEnemy:add()
	elseif roomFivePopCounter == 55 then
		fade(4000, "Images/fade/endingTitleScreen.png")
		state = "ending"
	end

end

function endingSetUp()
	gfx.sprite.removeAll()
	gfx.clear()
	endingCounter = 0
	playdate.graphics.setBackgroundColor(gfx.kColorBlack)
	textBoxImage = gfx.image.new("Images/textBox.png")
	textBoxSprite = gfx.sprite.new( textBoxImage )
	endtext1img = gfx.image.new("Images/text/endtext1.png")
	endtext1 = gfx.sprite.new(endtext1img)
	textBoxSprite:moveTo( textBoxX, textBoxY )
    textBoxSprite:add()
end

function ending()
	if endingCounter == 0 then
		endtext1:moveTo(textX,textY)
		endtext1:add()
	end
end

function playdate.update()
	if (state == "intro") then
		if introCallFlag == true then
			introSetUp()
			introCallFlag = false
		end
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

	if (state == "roomThree") then
		if roomThreeCallFlag == true then
			roomThreeSetUp()
			roomThreeCallFlag = false
		end
		roomThree()
	end

	if (state == "roomFour") then
		if roomFourCallFlag == true then
			roomFourSetUp()
			roomFourCallFlag = false
		end
		roomFour()
	end

	if (state == "roomFive") then
		if roomFiveCallFlag == true then
			roomFiveSetUp()
			roomFiveCallFlag = false
		end
		roomFive()
	end

	if (state == "ending") then
		if endingCallFlag == true then
			endingSetUp()
			endingCallFlag = false
		end
		ending()
	end
	
    gfx.sprite.update()
	playdate.timer.updateTimers()
end