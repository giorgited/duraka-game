-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local loadsave = require("loadsave")
-- include Corona's "widget" library
local widget = require "widget"
--------------------------------------------

local function backToMenuClicked()
		composer.gotoScene( "menu", "fade", 500 )
		return true	-- indicates successful touch
end


function scene:create( event )
	local sceneGroup = self.view

	local currentInfo  	     = loadsave.loadTable("userInfo.json")
	local totalScore         = currentInfo["totalScore"]
	local firstPlaceAmount   = currentInfo["firstPlace"]
	local secondPlaceAmount  = currentInfo["secondPlace"]
	local thirdPlaceAmount   = currentInfo["thirdPlace"]
	local fourthPlaceAmount  = currentInfo["fourthPlace"]
	local totalGamesAmount   = currentInfo["totalGames"]
	local highScore 		 = currentInfo["highestScore"]

	-- display a background image
	local background = display.newImageRect( "images/main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX 				 = 0
	background.anchorY 				 = 0
	background.x       				 = 0 + display.screenOriginX
	background.y 	   				 = 0 + display.screenOriginY
	background.fill.effect 			 = "filter.brightness"
	background.fill.effect.intensity = -.4
	local centerX 				     = display.contentCenterX
	local centerY 					 = display.contentCenterY
	sceneGroup:insert( background )

	local titleLogo = display.newText( "Scoreboard", centerX, 70, native.systemFont, 45)

	--scores info-----
	local options = {
	   text = "",
	   x = centerX - 50,
	   y = titleLogo.y + 100,
	   fontSize = 18,
	   width = 150,
	   height = 50,
	   align = "right"
	}
	 
	options.text = "Total Games: "
	options.y = options.y + 50
	local totalGames = display.newText( options )
	local totalGamesInt = display.newText(totalGamesAmount, totalGames.x + 100 , totalGames.y -15)
	sceneGroup:insert( totalGames )
	sceneGroup:insert( totalGamesInt )

	options.text = "1st Place: "
	options.y = options.y + 50
	local firstPlace = display.newText( options )
	local firstPlaceint = display.newText(firstPlaceAmount, firstPlace.x + 100 , firstPlace.y -15)
	sceneGroup:insert( firstPlace )
	sceneGroup:insert( firstPlaceint )

	options.text = "2nd Place: "
	options.y = options.y + 50
	local secondPlace = display.newText( options )
	local secondPlaceInt = display.newText(secondPlaceAmount, secondPlace.x + 100 , secondPlace.y -15)
	sceneGroup:insert( secondPlace )
	sceneGroup:insert( secondPlaceInt )

	options.text = "3rd Place: "
	options.y = options.y + 50
	local thirdPlace = display.newText( options )
	local thirdPlaceInt = display.newText(thirdPlaceAmount, thirdPlace.x + 100 , thirdPlace.y -15)
	sceneGroup:insert( thirdPlace )
	sceneGroup:insert( thirdPlaceInt )

	options.text = "4th Place: "
	options.y = options.y + 50
	local fourthPlace = display.newText( options )
	local fourthPlaceInt = display.newText(fourthPlaceAmount, fourthPlace.x + 100 , fourthPlace.y -15)
	sceneGroup:insert( fourthPlace )
	sceneGroup:insert( fourthPlaceInt )

	options.text = "High Score: "
	options.y = options.y + 50
	local HighestScore = display.newText( options )
	local HighestScoreInt = display.newText(highScore, HighestScore.x + 100 , HighestScore.y -15)
	sceneGroup:insert( HighestScore )
	sceneGroup:insert( HighestScoreInt )

	options.text = "Total Score: "
	options.y = options.y + 50
	local totalPoints = display.newText( options )
	local totalPointsInt = display.newText(totalScore, totalPoints.x + 100 , totalPoints.y -15)
	sceneGroup:insert( totalPoints )
	sceneGroup:insert( totalPointsInt )

	------------------
	local backIcon = display.newImage(  "images/back-icon.png", display.screenOriginX + 15, display.screenOriginY + 15)
  	backIcon.width = 30
  	backIcon.height = 30
 	backIcon:addEventListener("tap", backToMenuClicked)

	
	sceneGroup:insert( titleLogo )
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
