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

local function backToMenuClicked()
		composer.gotoScene( "menu", "fade", 500 )
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
	local titleLogo = display.newText( "Joker Game", centerX, 100, native.systemFont, 50)
  local subtitleLogo = display.newText( "About", centerX, 180, native.systemFont, 30)
  --about rectangle
	local backIcon = display.newImage(  "back-icon.png", display.screenOriginX + 15, display.screenOriginY + 15)
  backIcon.width = 30
  backIcon.height = 30
  backIcon:addEventListener("tap", backToMenuClicked)

	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
  sceneGroup:insert( subtitleLogo )
  sceneGroup:insert( backIcon )
end

function scene:destroy( event )
	local sceneGroup = self.view

	if subtitleLogo then
		subtitleLogo:removeSelf()	-- widgets must be manually removed
		subtitleLogo = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
