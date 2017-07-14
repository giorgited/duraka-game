-----------------------------------------------------------------------------------------
--
-- GameOver.lua
--
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local widget   = require "widget"
local loadsave = require("loadsave")
local scene    = composer.newScene()
--------------------------------------------


local function backToMenuClicked()
	composer.gotoScene( "menu", "fade", 500 )
	return true	-- indicates successful touch
end

local function onPlayBtnRelease()
	composer.gotoScene( "playNow", "fade", 500 )
	return true	-- indicates successful touch
end
function scene:create( event )
	composer.removeScene("playNow")
	local sceneGroup  = self.view
	----------------------------------
	local points = event.params.points
	local place  = event.params.place

	--LOAD USER INFO FROM FILE
	local currentInfo  = loadsave.loadTable("userInfo.json")
	local totalScore  = currentInfo["totalScore"]
	local highestScore = currentInfo["highestScore"]
	print (highestScore)

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


	--UPPER CORNER STATS
	local highestScoreText = display.newText( "Highest Score: " .. highestScore, 0, 10, native.systemFont, 12)
		highestScoreText.x = maxX - highestScoreText.width/2 -1

	local TotalScoreText = display.newText( "Total Score: " .. totalScore, 0, highestScoreText.y + 20, native.systemFont, 12)
		TotalScoreText.x = maxX - TotalScoreText.width/2 -1
	--GAME STATS
    local gameOverText = display.newText( "Game Over", centerX, centerY-150, native.systemFont, 30)
    local placeText 	 = display.newText( "Place: " .. place, centerX, gameOverText.y + 40, native.systemFont, 28)
    local pointsText 	 = display.newText( "Score: " .. tostring(points), centerX, placeText.y + 40, native.systemFont, 28)

  	--REDIRECT BUTTONS
  		--PLAY AGAIN
	local playBtn = display.newRoundedRect( 0, 0, 150,  50, 12 )
				playBtn.strokeWidth = 3
				playBtn:setFillColor( 0 )
				playBtn:setStrokeColor( 1, 0, 0 )
				playBtn.x = centerX
				playBtn.y = centerY 
	playTxt = widget.newButton{
					label="Play Again",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = onPlayBtnRelease	-- event listener function
	}
	playTxt.x = display.contentCenterX
	playTxt.y = centerY 

		--BACK TO MENU
	local backToMenu = display.newRoundedRect( 0, 0, 150,  50, 12 )
				backToMenu.strokeWidth = 3
				backToMenu:setFillColor( 0 )
				backToMenu:setStrokeColor( 1, 0, 0 )
				backToMenu.x = centerX
				backToMenu.y = playBtn.y + 70 
	backToMenuTxt = widget.newButton{
					label="Back To Menu",
					labelColor = { default={255}, over={128} },
					width=154, height=40,
					onRelease = backToMenuClicked	-- event listener function
	}
	backToMenuTxt.x = display.contentCenterX
	backToMenuTxt.y = playTxt.y + 70


	--ADD OBJECTS TO SCENEGROUP
	sceneGroup:insert( background )
    sceneGroup:insert( gameOverText )
    sceneGroup:insert( placeText )
    sceneGroup:insert( pointsText )
    sceneGroup:insert( highestScoreText )
    sceneGroup:insert( TotalScoreText )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( playTxt )
	sceneGroup:insert( backToMenu)
	sceneGroup:insert( backToMenuTxt)

end

function scene:destroy( event )
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
