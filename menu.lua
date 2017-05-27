-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
		composer.gotoScene( "playNow", "fade", 500 )
		return true	-- indicates successful touch
end
local function onHowToBtnRelease()
		composer.gotoScene( "howToPlay", "fade", 500 )
		return true	-- indicates successful touch
end
local function onAboutBtnRelease()
		composer.gotoScene( "about", "fade", 500 )
		return true	-- indicates successful touch
end


function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newText( "Joker Game", centerX, 50, native.systemFont, 50)
  local subtitleLogo = display.newText( "Main Menu", centerX, 100, native.systemFont, 30)

	local cardsImg = display.newImage("cards.png", centerX, 200)
				cardsImg.width = 150
				cardsImg.height = 130
	--how to play rectangle
	local playBtn = display.newRoundedRect( 0, 0, 150,  50, 12 )
				playBtn.strokeWidth = 3
				playBtn:setFillColor( 0.5 )
				playBtn:setStrokeColor( 1, 0, 0 )
				playBtn.x = centerX
				playBtn.y = cardsImg.y + 100
	--how to play text
	playTxt = widget.newButton{
					label="Play Now",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = onPlayBtnRelease	-- event listener function
	}
	playTxt.x = display.contentCenterX
	playTxt.y = cardsImg.y + 100

	--how to play rectangle
	local howToBtn = display.newRoundedRect( 0, 0, 150,  50, 12 )
				howToBtn.strokeWidth = 3
				howToBtn:setFillColor( 0.5 )
				howToBtn:setStrokeColor( 1, 0, 0 )
				howToBtn.x = centerX
				howToBtn.y = playBtn.y + 60
	--how to play text
	howToTxt = widget.newButton{
					label="How To Play",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = onHowToBtnRelease	-- event listener function
	}
	howToTxt.x = display.contentCenterX
	howToTxt.y = playBtn.y + 60

	--about rectangle
	local aboutBtn = display.newRoundedRect( 0, 0, 150,  50, 12 )
				aboutBtn.strokeWidth = 3
				aboutBtn:setFillColor( 0.5 )
				aboutBtn:setStrokeColor( 1, 0, 0 )
				aboutBtn.x = centerX
				aboutBtn.y = howToBtn.y + 60
	--about text
	aboutTxt = widget.newButton{
					label="About",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = onAboutBtnRelease	-- event listener function
	}
	aboutTxt.x = display.contentCenterX
	aboutTxt.y = howToBtn.y + 60
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( subtitleLogo )
	sceneGroup:insert( playBtn)
	sceneGroup:insert( playTxt )
	sceneGroup:insert( howToBtn)
	sceneGroup:insert( howToTxt )
	sceneGroup:insert( aboutBtn)
	sceneGroup:insert( aboutTxt)
	sceneGroup:insert( cardsImg)

end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	if playTxt then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if howToTxt then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if aboutTxt then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
