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
		composer.gotoScene( "scores", "fade", 500 )
		return true	-- indicates successful touch
end

local function createScores()
	local currentInfo = loadsave.loadTable("userInfo.json")
    local userInfo 
    if (currentInfo == nil) then --create fresh file
        userInfo = {
                        highestScore = 0,
                        totalScore   = 0,
                        firstPlace   = 0,
                        secondPlace  = 0,
                        thirdPlace   = 0,
                        fourthPlace  = 0,
                        totalGames   = 0
                    }
        loadsave.saveTable(userInfo, "userInfo.json")
    end
    
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

	createScores()
	sceneGroup:insert( background )

	local playNow = display.newRoundedRect( 0, 0, 164,  100, 7 )
			playNow.strokeWidth = 3
			playNow:setFillColor(0,0,0,0)
			playNow:setStrokeColor( .6, 0, 0 )
			playNow.x = centerX
			playNow.y = centerY-43
	playTxt = widget.newButton{
					x= playNow.x, y = playNow.y,
 					width=playNow.width, height=playNow.height,
 					onRelease = onPlayBtnRelease	-- event listener function
 			}
	sceneGroup:insert( playNow )
 	sceneGroup:insert( playTxt )


	local howToPlay = display.newRoundedRect( 0, 0, 170,  100, 7 )
			howToPlay.strokeWidth = 3
			howToPlay:setFillColor(0,0,0,0)
			howToPlay:setStrokeColor( .6, 0, 0 )
			howToPlay.x = centerX -2
			howToPlay.y = centerY+90
	howToTxt = widget.newButton{
					x= howToPlay.x, y = howToPlay.y,
 					width=howToPlay.width, height=howToPlay.height,
 					onRelease = onHowToBtnRelease	-- event listener function
 			}
 	sceneGroup:insert( howToPlay )
 	sceneGroup:insert( howToTxt )


	local scores = display.newRoundedRect( 0, 0, 170,  100, 7 )
			scores.strokeWidth = 3
			scores:setFillColor(0,0,0,0)
			scores:setStrokeColor( .6, 0, 0 )
			scores.x = centerX -2
			scores.y = centerY+231
	scoresTxt = widget.newButton{
					x= scores.x, y = scores.y,
 					width=scores.width, height=scores.height,
 					onRelease = onAboutBtnRelease	-- event listener function
 			}
 	sceneGroup:insert( scores )
 	sceneGroup:insert( scoresTxt
 	 )

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
