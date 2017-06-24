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

local function backToMenuClicked()
		composer.gotoScene( "menu", "fade", 500 )
		return true	-- indicates successful touch
end

local function onPlayBtnRelease()
		composer.gotoScene( "playNow", "fade", 500 )
		return true	-- indicates successful touch
end
function scene:create( event )
	local sceneGroup = self.view

	-- display a background image
	local background = display.newImageRect( "images/main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	background.fill.effect = "filter.brightness"
	background.fill.effect.intensity = -.4
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY
	-- create/position logo/title image on upper-half of the screen
  local subtitleLogo = display.newText( "Game Over", centerX, centerY-150, native.systemFont, 30)
  local backIcon = display.newImage(  "images/back-icon.png", display.screenOriginX + 15, display.screenOriginY + 15)
  backIcon.width = 30
  backIcon.height = 30
  backIcon:addEventListener("tap", backToMenuClicked)

	local playBtn = display.newRoundedRect( 0, 0, 150,  50, 12 )
				playBtn.strokeWidth = 3
				playBtn:setFillColor( 0 )
				playBtn:setStrokeColor( 1, 0, 0 )
				playBtn.x = centerX
				playBtn.y = centerY 
	--how to play text
	playTxt = widget.newButton{
					label="Play Again",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = onPlayBtnRelease	-- event listener function
	}
	playTxt.x = display.contentCenterX
	playTxt.y = centerY 
	-- all display objects must be inserted into group


	sceneGroup:insert( background )
    sceneGroup:insert( subtitleLogo )
    sceneGroup:insert( backIcon )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( playTxt )

end

function scene:destroy( event )
	local sceneGroup = self.view

	subtitleLogo.removeSelf()
  subtitleLogo = nil

	if playBtn then
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
