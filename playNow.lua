-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
local widget = require "widget"
local deckOfCards = {
  "AS", "2S", "3S", "4S", "5S", "6S", "7S", "8S",  "9S", "10S", "JS", "QS", "KS",
  "AD", "2D", "3D", "4D", "5D", "6D", "7D", "8D",  "9D", "10D", "JD", "QD", "KD",
  "AH", "2H", "3H", "4H", "5H", "6H", "7H", "8H",  "9H", "10H", "JH", "QH", "KH",
  "AC", "2C", "3C", "4C", "5C", "6C", "7C", "8C",  "9C", "10C", "JC", "QC", "KC"
}
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local cardsContainer = display.newContainer(  30, 50 )
math.randomseed(os.time())
--------------------------------------------
function shuffleCards (t)
      local rand = math.random
      assert( t, "shuffleTable() expected a table, got nil" )
      local iterations = #t
      local j

      for i = iterations, 2, -1 do
          j = rand(i)
          t[i], t[j] = t[j], t[i]
      end
end
function dealCards(numberPerPerson)
    shuffleCards(deckOfCards)
    local totalCards = 52
    for i = 1, totalCards do
        if string.ends(deckOfCards[i], "S") then
          if string.starts(deckOfCards[i], "A") then
            local card = display.newImage("deckOfCards/ace_of_spades.png", centerX, centerY)
            card.width=40
            card.height=60
          end
        end
    end
end


function scene:create( event )
	local sceneGroup = self.view

  physics.start()
	physics.pause()
	-- display a background image
	local background = display.newImageRect( "main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX
	background.y = 0 + display.screenOriginY
	local centerX = display.contentCenterX
	local centerY = display.contentCenterY
	-- create/position logo/title image on upper-half of the screen

  local myUserCards = display.newRect( 0, 0, display.actualContentWidth -50,  50)
        myUserCards.strokeWidth = 3
        myUserCards:setFillColor( 0.7, .4 )
        myUserCards:setStrokeColor( 1, 0, 0, .2 )
        myUserCards.x = centerX
        myUserCards.y = display.actualContentHeight - 100

  local user2 = display.newRect( 0, 0, 50, display.actualContentHeight/4.5)
        user2.strokeWidth = 3
        user2:setFillColor( 0.7, .4 )
        user2:setStrokeColor( 1, 0, 0, .2 )
        user2.x = display.screenOriginX + 30
        user2.y = centerY
  local user3 = display.newRect( 0, 0, 50, display.actualContentHeight/4.5)
        user3.strokeWidth = 3
        user3:setFillColor( 0.7, .4 )
        user3:setStrokeColor( 1, 0, 0, .2 )
        user3.x = display.actualContentWidth - 30
        user3.y = centerY
  local user4 = display.newRect( 0, 0, display.actualContentWidth/2,  50)
        user4.strokeWidth = 3
        user4:setFillColor( .7, .4)
        user4:setStrokeColor( 1, 0, 0, .2 )
        user4.x = centerX - 30
        user4.y = display.screenOriginY + 30
  shuffleCards(deckOfCards)
  for i = 0, 52 do
      local faceDownCard = display.newImage("DeckOfCards/faceDown.png", centerX, centerY)
            faceDownCard.width= 60
            faceDownCard.height = 80
        physics.addBody( faceDownCard, { } )
        sceneGroup:insert(faceDownCard)
  end



	physics.addBody( myUserCards, "static", { friction=0.3 } )
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
  sceneGroup:insert(myUserCards)
  sceneGroup:insert(user2)
  sceneGroup:insert(user3)
  sceneGroup:insert(user4)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		physics.start()
	end
end


function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
