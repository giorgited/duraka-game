-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
local json = require( "json" )
local composer = require( "composer" )
local scene = composer.newScene()
local physics = require "physics"
local widget = require "widget"
local deckOfCards = {
  "14S", "2S", "3S", "4S", "5S", "6S", "7S", "8S",  "9S", "10S", "11S", "12S", "13S",
  "14D", "2D", "3D", "4D", "5D", "6D", "7D", "8D",  "9D", "10D", "11D", "12D", "13D",
  "14H", "2H", "3H", "4H", "5H", "6H", "7H", "8H",  "9H", "10H", "11H", "12H", "13H",
  "14C", "2C", "3C", "4C", "5C", "6C", "7C", "8C",  "9C", "10C", "11C", "12C", "13C"
}
local myCards, user2Cards, user3Cards, user4Cards = {}, {}, {}, {}
local cards = {}
local backCards = {}
local cardWidth = (display.actualContentWidth - 30)/6
local cardHeight =  cardWidth * 1.3
local sceneGroup
local yourTurn = false
local playAreaGroup = {}
local playAreaGroupCards = {}
local timerDelay = 0
local counter = 1
local moveToX = 0
local moveToY = 0
local turn = 1
local handCardIndex = 1
local centerX, centerY, zeroX, zeroY, maxX, maxY =
      display.contentCenterX, display.contentCenterY, display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight
math.randomseed(os.time())
--------------------------------------------------------------------------------------------------
function cardTapped(event)
    print ("some")
    if(yourTurn) then
        addNewCardToPlayArea(event.target)
    end
end

local del = 100;
local myCardX = zeroX + 39

function dealMe(numberOfCards)
    for i=1, numberOfCards do
        table.insert(myCards, cards[handCardIndex])
              cards[handCardIndex]:addEventListener( "tap", cardTapped )
              local obj = backCards[handCardIndex]
              local myCardObj = cards[handCardIndex]
              local x = transition.moveTo(obj, {delay = del, x=myCardX, y=maxY - 100, time=100, 
                                            onComplete = function ( obj )
                                                            myCardObj.x = obj.x
                                                            myCardObj.y = obj.y
                                                            transition.dissolve( obj, myCardObj, 500 )
                                                        end})
              del = del + 100
              myCardX = myCardX + cardWidth
              handCardIndex = handCardIndex + 1
    end   
end
function dealUser2(numberOfCards)
    for i=1, numberOfCards do
          user2Cards.x = zeroX + 30
          user2Cards.y = centerY
          cards[handCardIndex].x = zeroX + 30
          cards[handCardIndex].y = centerY
          cards[handCardIndex].isVisible = false
          table.insert(user2Cards, cards[handCardIndex])
          transition.moveTo(backCards[handCardIndex], {delay = del, x=zeroX + 30, y=centerY, time=100})
          del = del + 100
          handCardIndex = handCardIndex + 1 
    end
end
function dealUser3(numberOfCards)
    for i=1, numberOfCards do
          table.insert(user3Cards, cards[handCardIndex])
          transition.moveTo(backCards[handCardIndex], {delay= del,x=centerX, y=zeroY + 30, time=100})
          del = del + 100
          handCardIndex = handCardIndex + 1
    end
end
function dealuser4(numberOfCards)
    for i=1, numberOfCards do
          table.insert(user4Cards, cards[handCardIndex])
          transition.moveTo(backCards[handCardIndex], {delay= del,x=maxX - 30, y=centerY, time=100})
          del = del + 100
          handCardIndex = handCardIndex + 1
     end
end

function dealCards(numberPerPerson)
    local x = 1;
    
    for i=1, numberPerPerson * 4 do
        if (x == 1) then
          dealMe(1)
        elseif (x==2) then
          dealUser2(1)
        elseif (x==3) then
          dealUser3(1)
        elseif (x==4) then
          dealuser4(1)
        end
        
        if (x == 4 ) then
          x=1
        else
          x = x + 1
        end
    end
    yourTurn = true
end
function addNewCardToPlayArea (card)
    local playAreaWidth = playAreaGroup.playArea.width
    local playAreaHeight = playAreaGroup.playArea.height
    local playAreaX = playAreaGroup.playArea.x
    local playAreaY = playAreaGroup.playArea.y
    local xMin  = playAreaGroup.playArea.contentBounds.xMin
    local xMax  = playAreaGroup.playArea.contentBounds.xMax
    local yMin  = playAreaGroup.playArea.contentBounds.yMin
    local yMax = playAreaGroup.playArea.contentBounds.yMax

    print (table.maxn(playAreaGroupCards))
    if (table.maxn(playAreaGroupCards) == 0) then
        moveToX = playAreaX - 50
        moveToY = playAreaY - 100
    else
        for i=1, table.maxn(playAreaGroupCards) do
            if ((playAreaGroupCards[i].x + playAreaGroupCards[i].y) ~= (playAreaX + 50 + playAreaY - 100)) then
                moveToX = playAreaX + 50
                moveToY = playAreaY - 100
            elseif ((playAreaGroupCards[i].x + playAreaGroupCards[i].y) ~= (playAreaX - 50 + playAreaY)) then
                moveToX = playAreaX - 50 
                moveToY = playAreaY 
            elseif ((playAreaGroupCards[i].x + playAreaGroupCards[i].y) ~= (playAreaX + 50 + playAreaY)) then
                moveToX = playAreaX + 50 
                moveToY = playAreaY
            elseif ((playAreaGroupCards[i].x + playAreaGroupCards[i].y) ~= (playAreaX - 50 + playAreaY + 100)) then
                moveToX = playAreaX - 50
                moveToY = playAreaY + 100
            elseif ((playAreaGroupCards[i].x + playAreaGroupCards[i].y) ~= (playAreaX + 50 + playAreaY + 100)) then
                moveToX = playAreaX + 50
                moveToY = playAreaY + 100
            end
        end
    end
    

    local cardValue = getCardValue(card)
    if (table.maxn(playAreaGroupCards) == 0) then
        transition.moveTo(card, {x=moveToX, y=moveToY, time=300})
        card.hasBeenCut = false
        table.insert(playAreaGroupCards, card)
        timerDelay = timerDelay + 3000
        timer.performWithDelay( timerDelay, usersTurn )
    else
        for i=1, table.maxn(playAreaGroupCards) do
            local length = string.len(playAreaGroupCards[i].value)
            local value = getCardValue(playAreaGroupCards[i])
            if (value == cardValue) then
                transition.moveTo(card, {x=moveToX, y=moveToY, time=300})
                table.insert(playAreaGroupCards, card)
                card.hasBeenCut = false
                timerDelay = timerDelay + 3000
                timer.performWithDelay( timerDelay, usersTurn )
            end  
        end
    end
end

function usersTurn()
    print ("im called")
    local numberOfCuts = 0;
    for i=1, table.maxn( playAreaGroupCards ) do
        if (playAreaGroupCards[i].hasBeenCut ~= true) then
            local cutCardVal  = getCardValue(playAreaGroupCards[i])
            local cutCardSuit = getCardSuit(playAreaGroupCards[i])
            for x=1, table.maxn(user2Cards) do
                print (x)
                local cardVal = getCardValue(user2Cards[x])
                local cardSuit = getCardSuit(user2Cards[x])
                print ("cardVal: " .. cardVal .. " cardSuit: ".. cardSuit)
                if (cardSuit == cutCardSuit) then
                    cutCardVal = tonumber( cutCardVal )
                    cardVal = tonumber(cardVal)
                    if (cardVal > cutCardVal) then
                        print("cut it")
                        playAreaGroupCards[i].hasBeenCut = true
                        local obj = user2Cards[x]
                        transition.moveTo(obj, {x=playAreaGroupCards[i].x+20, y=playAreaGroupCards[i].y, time=200,
                                                            onStart = function (obj) obj.isVisible=true end} )
                        table.insert(playAreaGroupCards, obj)
                        numberOfCuts = numberOfCuts + 2
                        counter = counter + 1;
                        table.remove(user2Cards, x)
                        break;
                    else
                        print("cannot cut it")
                    end
                end
            end
        end
    end
    
   
    local delay = 2000
    if (numberOfCuts == table.maxn( playAreaGroupCards )) then
        for i=1, table.maxn( playAreaGroupCards ) do

            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = 500, y = -100, time = 300, 
                onComplete = function(obj) table.remove(playAreaGroupCards, i) end})
            delay = delay  + 100
        end
    else
        for i=1, table.maxn( playAreaGroupCards ) do
            print ("i: " .. i .. "max : " .. table.maxn( playAreaGroupCards ))
            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = user2Cards.x, y = user2Cards.y, time = 300, 
                onComplete = function(obj) 
                                        playAreaGroupCards[i].isVisible = false
                                        table.insert(user2Cards, playAreaGroupCards[i]) 
                                        table.remove(playAreaGroupCards, i)
                             end})
            delay = delay  + 100
        end
end
    



---------------------------------------HELPERS--------------------------------------------------
end
function getCardValue (card)
    return card.value:sub(1, string.len(card.value) - 1)
end
function getCardSuit (card)
    return card.value:sub(string.len(card.value), string.len(card.value))
end 
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

function scene:create( event )
	sceneGroup = self.view

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

  local myUserCards = display.newRect( 0, 0, display.actualContentWidth -30,  cardHeight)
        myUserCards.strokeWidth = 3
        myUserCards:setFillColor( 0.7, .4 )
        myUserCards:setStrokeColor( 1, 0, 0, .2 )
        myUserCards.x = centerX
        myUserCards.y = display.actualContentHeight - 100
        myUserCards.alpha = .2

  local user2 = display.newRect( 0, 0, cardWidth, cardHeight)
        user2.strokeWidth = 3
        user2:setFillColor( 0.7, .4 )
        user2:setStrokeColor( 1, 0, 0, .2 )
        user2.x = zeroX + 30
        user2.y = centerY
        user2.alpha = .2
    local user3 = display.newRect( 0, 0, cardWidth,  cardHeight)
        user3.strokeWidth = 3
        user3:setFillColor( .7, .4)
        user3:setStrokeColor( 1, 0, 0, .2 )
        user3.x = centerX
        user3.y = zeroY + 30
        user3.alpha = 1.0
  local user4 = display.newRect( 0, 0, cardWidth, cardHeight)
        user4.strokeWidth = 3
        user4:setFillColor( 0.7, .4 )
        user4:setStrokeColor( 1, 0, 0, .2 )
        user4.x = maxX - 30
        user4.y = centerY
        user4.alpha = .2

 
  local playArea = display.newRect( 0, 0, maxX/2,  maxY/2)
        playArea:setFillColor( .7, .4)
        playArea.alpha = .3
        playArea.x = centerX
        playArea.y = centerY
    playAreaGroup.playArea = playArea

	physics.addBody( myUserCards, "static", { friction=0.3 } )
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
    shuffleCards(deckOfCards)
  for i = 1, 52 do
        local cardFront = display.newImage("DeckOfCards/".. deckOfCards[i]..".png", zeroX + cardWidth/2, zeroY + cardHeight/2)
            cardFront.width= cardWidth
            cardFront.height = cardHeight
            cardFront.isVisible = false
            cardFront.value = deckOfCards[i]
        cards[i] = cardFront
        local cardBack = display.newImage("DeckOfCards/faceDown.png", zeroX + cardWidth/2, zeroY + cardHeight/2)
            cardBack.width= cardWidth
            cardBack.height = cardHeight
        backCards[i] = cardBack
        sceneGroup:insert(cardBack)
  end
  sceneGroup:insert(myUserCards)
  sceneGroup:insert(user2)
  sceneGroup:insert(user3)
  sceneGroup:insert(user4)
  sceneGroup:insert(playArea)
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
    dealCards(6)
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
