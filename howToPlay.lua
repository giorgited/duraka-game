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
		return true
end


function scene:create( event )
	local sceneGroup = self.view

	-- background
	local background = display.newImageRect( "images/main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX 				 = 0
	background.anchorY 				 = 0
	background.x       				 = display.screenOriginX
	background.y 	   				 = display.screenOriginY
	background.fill.effect 			 = "filter.brightness"
	background.fill.effect.intensity = -.4
	local centerX 				     = display.contentCenterX
	local centerY 					 = display.contentCenterY
	sceneGroup:insert( background )
	------------------

  	local title = display.newText( "How To Play", centerX, 70, native.systemFont, 45)
  	sceneGroup:insert( title )

  	--back button
  	local backIcon = display.newImage(  "images/back-icon.png", display.screenOriginX + 15, display.screenOriginY + 15)
  	backIcon.width = 30
  	backIcon.height = 30
  	backIcon:addEventListener("tap", backToMenuClicked)
  	sceneGroup:insert( backIcon )
  	-----------------

  	local options = {
	   text 	= "",
	   x 		= centerX,
	   y 		= title.y + 100,
	   fontSize = 16,
	   width    = display.actualContentWidth * .8 ,
	   height   = 0,
	   align    = "left"
	}
	
	options.text = "Objective: The goal of the game is to be the first of getting rid of the cards."
	options.y = options.y + 50
	local objective = display.newText( options )
	sceneGroup:insert( objective )

	options.text = "Rule 1: "
	options.y = options.y + 50
	local rule1 = display.newText( options )
	sceneGroup:insert( rule1 )

	options.text = "Rule 2: "
	options.y = options.y + 50
	local rule2 = display.newText( options )
	sceneGroup:insert( rule2 )

	options.text = "Rule 3: "
	options.y = options.y + 50
	local rule3 = display.newText( options )
	sceneGroup:insert( rule3 )

	options.text = "Rule 4: "
	options.y = options.y + 50
	local rule4 = display.newText( options )
	sceneGroup:insert( rule4 )

end

function scene:destroy( event )
	local sceneGroup = self.view

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
