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
	local background = display.newImageRect( "images/mainMenu.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY


	sceneGroup:insert( background )

	local playNow = display.newRoundedRect( 0, 0, 164,  100, 7 )
			playNow.strokeWidth = 3
			playNow:setFillColor(0,0,0,0)
			playNow:setStrokeColor( .6, 0, 0 )
			playNow.x = centerX
			playNow.y = centerY-43
	local howToPlay = display.newRoundedRect( 0, 0, 170,  100, 7 )
			howToPlay.strokeWidth = 3
			howToPlay:setFillColor(0,0,0,0)
			howToPlay:setStrokeColor( .6, 0, 0 )
			howToPlay.x = centerX -2
			howToPlay.y = centerY+90

	local scores = display.newRoundedRect( 0, 0, 170,  100, 7 )
			scores.strokeWidth = 3
			scores:setFillColor(0,0,0,0)
			scores:setStrokeColor( .6, 0, 0 )
			scores.x = centerX -2
			scores.y = centerY+231

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
