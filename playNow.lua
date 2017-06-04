-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
local playNowCreateObjects = require("playNowCreateObjects")
local scene = composer.newScene()
local myUserArea, user2Area, user3Area, user4Area
local cards, backCards, playAreaGroup, cardWidth, cardHeight
local myCards, user2Cards, user3Cards, user4Cards, playAreaGroupCards = {}, {}, {}, {}, {}
local user2backCards,user3backCards, user4backCards = {}, {}, {}
local handCardIndex = 1
local yourTurn = false
local turn = 1
local counter = 1
local hand = 1
local cardWasAdded = false
local updateTimer
math.randomseed(os.time())
--------------------------------------------------------------------------------------------------
function cardTapped(event)
    cardWasAdded = true
    if yourTurn then
        local added = AddMyCard(event.target)
        if added then 
            myUserArea.doneButton:setEnabled(true)
            myUserArea.doneButton:setFillColor(1)
            --timer.performWithDelay(1000, function() reArrangeMyCards(event.target) end)
        end
    end
end

function doneButtonPressed (event)
    myUserArea.doneButton:setFillColor( 0 )
    if hand == 1 then
        if cardWasAdded then
            hand1Helper()
        else
            print ("sefsefsefe")
            clearPlayArea(true)
            hand = hand + 1
            GamePlay()
        end  
    end
end
function hand1Helper()
        local didCut = CutCards(user2Cards)
        print("user was able to cut: " .. tostring(didCut))
        if didCut then 
            AddCards(user3Cards)
            timer.performWithDelay(800, function () AddCards(user4Cards) end)
            timer.performWithDelay(1600, function()
                cardWasAdded = false
                print ("attempting to cut")
                local didCutAgain = CutCards(user2Cards)
                if didCutAgain then
                    YourTurn("add")
                else
                    ClearTheBoard(false, user2Cards)
                    hand = hand + 2
                    GamePlay()
                end
            end)
        else 
            ClearTheBoard(false, user2Cards)
            hand = hand + 2
            GamePlay()
        end
end
local del = 900;
function dealMe(numberOfCards)
      if (handCardIndex == 52) then return end
      local contentX,contentY = sceneGroup.myUserArea.myUserCards:localToContent( 0, 0 )
      table.insert(myCards, cards[handCardIndex])
      sceneGroup.cards[handCardIndex]:addEventListener( "tap", cardTapped )
      local obj = sceneGroup.backCards[handCardIndex]
      local myCardObj = sceneGroup.cards[handCardIndex]
      sceneGroup.cards[handCardIndex].x = obj.x
      sceneGroup.cards[handCardIndex].y = obj.y
      
      local x = transition.moveTo(obj, {x=findEmptySpotInHolder(), y=contentY, time=100, 
                                    onComplete = function ( obj )
                                                    myCardObj.x = obj.x
                                                    myCardObj.y = obj.y
                                                    transition.dissolve( obj, myCardObj, 500 )
                                                    dealMeHelper(numberOfCards)
                                                end}) 
      handCardIndex = handCardIndex + 1       
end
function dealMeHelper(numberOfCards)
    if (numberOfCards <= 1 ) then
        return
    end
    numberOfCards  = numberOfCards - 1
    dealMe(numberOfCards)
end
function dealUser2(numberOfCards)
    print ("delay " .. del )
    if (handCardIndex == 52) then return end
    for i=1, numberOfCards do
          local contentX,contentY = user2Area.user2CardContainer:localToContent( 0, 0 )
          user2Cards.x = contentX
          user2Cards.y = contentY
          cards[handCardIndex].x = contentX
          cards[handCardIndex].y = contentY
          cards[handCardIndex].isVisible = false
          table.insert(user2Cards, cards[handCardIndex])

          transition.moveTo(backCards[handCardIndex], {delay = del, x = contentX, y = contentY, time=100})
          table.insert( user2backCards, backCards[handCardIndex] )
          del = del + 100
          handCardIndex = handCardIndex + 1 
    end
end
function dealUser3(numberOfCards)
    if (handCardIndex == 52) then return end
    for i=1, numberOfCards do
          local contentX,contentY = user3Area.user3CardContainer:localToContent( 0, 0 )
          cards[handCardIndex].x = contentX
          cards[handCardIndex].y = contentY
          cards[handCardIndex].isVisible = false
          table.insert(user3Cards, cards[handCardIndex])
          transition.moveTo(backCards[handCardIndex], {delay= del,x=contentX, y=contentY, time=100})
          table.insert( user3backCards, backCards[handCardIndex] )
          del = del + 100
          handCardIndex = handCardIndex + 1
    end
end
function dealUser4(numberOfCards)
    if (handCardIndex == 52) then return end
    for i=1, numberOfCards do
          local contentX,contentY = user4Area.user4CardContainer:localToContent( 0, 0 )
          cards[handCardIndex].x = contentX
          cards[handCardIndex].y = contentY
          cards[handCardIndex].isVisible = false
          table.insert(user4Cards, cards[handCardIndex])
          transition.moveTo(backCards[handCardIndex], {delay= del,x=contentX, y=contentY, time=100})
          table.insert( user4backCards, backCards[handCardIndex] )
          del = del + 100
          handCardIndex = handCardIndex + 1
     end
end
function dealCards(numberPerPerson)
    timer.pause(updateTimer)
    dealMe(6)
    dealUser2(6)
    dealUser3(6)
    dealUser4(6)
    timer.resume(updateTimer)
    --timer.performWithDelay( 3000, reScaleCards , 1 )

    yourTurn = true
end

function GamePlay()
    if hand ==1 then
        cardWasAdded = false
        YourTurn("start")
    elseif hand == 2 then
        print ("i got to hand 2")
        timer.performWithDelay(2000, function() 
            AddCards(user2Cards)
            local didCut = CutCards(user3Cards)
            if didCut == true then
                AddCards(user4Cards)
                YourTurn("add")
            else
                ClearTheBoard(false, user3Cards)
            end
        end)
    elseif hand == 3 then
        print ("i got to hand 3")
        timer.performWithDelay(2000, function() AddCards(user3Cards) 
            timer.performWithDelay(3000, function()
                            if didCut == CutCards(user4Cards) then 
                                YourTurn("add")
                            else
                                ClearTheBoard(false, user4Cards)
                            end
            end)
        end)
    elseif hand == 4 then
        print ("i got to hand 4")
        AddCards(user4Cards)
        YourTurn("cut")
    end
end
function YourTurn(request)
    yourTurn = true
    if(request == "start") then
        myUserArea.doneButton:setFillColor( 1 )
        myUserArea:localToContent( 0, 0 )
        transition.moveBy(myUserArea.yourTurnText, {delay = 2000, x=-120, y=50, onStart = function () 
                                                        myUserArea.yourTurnText.isVisible = true 
                                                        myUserArea.yourTurnText.text = "Your Turn"
                                                    end})
    elseif request == "add" then
        myUserArea.doneButton:setFillColor( 1 )
        myUserArea:localToContent( 0, 0 )
        transition.moveBy(myUserArea.yourTurnText, {delay = 500, x=0, y=-50, 
                                                    onStart = function () 
                                                        myUserArea.yourTurnText.isVisible = true 
                                                        myUserArea.yourTurnText.text = "Would You Like To Add?"
                                                    end})
    elseif request == "cut" then
    end
end
function AddCards(userCards)
    if (table.maxn(playAreaGroupCards) <= 12) then 
        if (table.maxn(playAreaGroupCards) == 0) then
            local cardsList = {}
            for i=1, table.maxn(userCards) do
                table.insert(cardsList, userCards[i].value)
            end
            table.sort(cardsList)
            local addCards = {}
            for i=1, table.maxn(userCards) do
                if (userCards[i].value == cardsList[1]) then
                    table.insert(addCards, userCards[i] )
                end
            end
            AddCardsHelper(userCards, addCards)
        else
            local addCardsList = {}
            local canAdd = false
            for i=1, table.maxn(userCards) do
                local cardValue = getCardValue(userCards[i])
                for x=1, table.maxn(playAreaGroupCards) do
                    local value = getCardValue(playAreaGroupCards[x])
                    if (value == cardValue) then
                        table.insert(addCardsList, userCards[i])
                    end  
                end
            end
            AddCardsHelper(userCards, addCardsList)
        end
    end
end
function AddCardsHelper(usersCards, cardsList)
    if table.maxn(cardsList) == 0 then return end
    local card = cardsList[1]
    local emptySpot = findNextPlayAreaSpot()
    local x = transition.moveTo(card, {x= emptySpot.moveToX, y=emptySpot.moveToY, time=200,
                                    onStart = function ()
                                        card.isVisible = true
                                        end,
                                    onComplete = function ()
                                                    card.hasBeenCut = false
                                                    removedCardIndex = table.indexOf(usersCards, card)
                                                    table.insert(playAreaGroupCards, card)
                                                    table.remove(cardsList, 1)
                                                    table.remove(usersCards, removedCardIndex)
                                                    AddCardsHelper(usersCards, cardsList)
                                    end}) 
end
function AddMyCard(card)
    local cardValue = getCardValue(card)
    local cardAdded = false
    if(yourTurn) then
        if (table.maxn(playAreaGroupCards) == 0) then
            local nextSpot = findNextPlayAreaSpot()
            nextSpot.x = nextSpot.moveToX
            nextSpot.y = nextSpot.moveToY
            addMyCardHelper(card, myCards,nextSpot)
             transition.moveBy(myUserArea.yourTurnText, {delay = 1000, x=0, y=50, onStart = function () myUserArea.yourTurnText.isVisible = false end})
            cardAdded = true
        else
            local canAdd = false
            for i=1, table.maxn(playAreaGroupCards) do
                local length = string.len(playAreaGroupCards[i].value)
                local value = getCardValue(playAreaGroupCards[i])
                if (value == cardValue) then
                    canAdd = true
                end  
            end
            if (canAdd) then
                local nextSpot = findNextPlayAreaSpot()
                nextSpot.x = nextSpot.moveToX
                nextSpot.y = nextSpot.moveToY
                addMyCardHelper(card, myCards,nextSpot) 
                myUserArea:localToContent( 0, 0 )
                transition.moveBy(myUserArea.yourTurnText, {delay = 1000, x=0, y=50, onStart = function () myUserArea.yourTurnText.isVisible = false end})
                cardIndex = table.indexOf(myCards, cards)
                cardAdded = true
            end
        end
        return cardAdded
    end
end
function addMyCardHelper (card, usersCards, spot)
    print ("adding: " .. card.value)
        local moveToX  = spot.x
        local movetoY  = spot.y

        local removedCardIndex

        card.isVisible = true
        transition.moveTo(card, {x=moveToX, y=moveToY, time=300,
                 onComplete = function ()
                    print ("removing frmo: " .. table.indexOf(usersCards, card))
                        card.hasBeenCut = false
                        removedCardIndex = table.indexOf(usersCards, card)
                        table.insert(playAreaGroupCards, card)
                        table.remove(usersCards, removedCardIndex)
                    end
                    })       
end
function CutCards(userCards)
    local numberOfCuts = 0;
    for i=1, table.maxn(playAreaGroupCards) do
        if (playAreaGroupCards[i].hasBeenCut) then
            numberOfCuts = numberOfCuts + 1
        end
    end
    for i=1, table.maxn( playAreaGroupCards ) do
        if (playAreaGroupCards[i].hasBeenCut ~= true) then
            local cutCardVal  = getCardValue(playAreaGroupCards[i])
            local cutCardSuit = getCardSuit(playAreaGroupCards[i])
            for x=1, table.maxn(userCards) do
                local cardVal = getCardValue(userCards[x])
                local cardSuit = getCardSuit(userCards[x])
                if (cardSuit == cutCardSuit) then
                    cutCardVal = tonumber( cutCardVal )
                    cardVal = tonumber(cardVal)
                    if (cardVal > cutCardVal) then
                        playAreaGroupCards[i].hasBeenCut = true
                        local obj = userCards[x]
                        transition.moveTo(obj, {x=playAreaGroupCards[i].x+20, y=playAreaGroupCards[i].y, time=200, onStart = function (obj) 
                                                    obj.isVisible=true 
                                                end})
                        obj.hasBeenCut = true
                        table.insert(playAreaGroupCards, obj)
                        table.remove(userCards, x)
                        numberOfCuts = numberOfCuts + 2
                        counter = counter + 1;
                        break;
                    else
                    end
                end
            end
        end
    end
    if (numberOfCuts == table.maxn( playAreaGroupCards )) then
        return true
    else
        return false
    end
end
function ClearTheBoard(cut, userCards)
    local delay = 200

    if (cut) then
        for i=1, table.maxn( playAreaGroupCards ) do

            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = 500, y = -100, time = 300, 
                onComplete = function(obj) 
                            table.remove(playAreaGroupCards, table.indexOf(obj)) 
                            end})

            delay = delay  + 100
        end
    else 
        for i=1, table.maxn( playAreaGroupCards ) do
            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = userCards.x, y = userCards.y, time = 300, 
                onComplete = function(obj) 
                            obj.isVisible = false
                            table.insert(userCards, playAreaGroupCards[table.indexOf(playAreaGroupCards,obj)]) 
                            table.remove(playAreaGroupCards, table.indexOf(playAreaGroupCards, obj))
                 end})
            delay = delay  + 100
        end
    end
    timer.performWithDelay(1000,function () fillUpUsers() end )
end
---------------------------------------HELPERS--------------------------------------------------

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
      print ("iterrr" .. iterations)
      for i = iterations, 2, -1 do
          j = rand(i)
          t[i], t[j] = t[j], t[i]
      end
end
function clearPlayArea(cut, user)
    local delay = 200

    if (cut) then
        for i=1, table.maxn( playAreaGroupCards ) do

            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = 500, y = -100, time = 300, 
                onComplete = function(obj) 
                            table.remove(playAreaGroupCards, table.indexOf(obj)) 
                            --turn = turn + 1
                            end})

            delay = delay  + 100
        end
    else 
        for i=1, table.maxn( playAreaGroupCards ) do
            transition.moveTo(playAreaGroupCards[i], {delay = delay, x = user.x, y = user.y, time = 300, 
                onComplete = function(obj) 
                            obj.isVisible = false
                            table.insert(user, playAreaGroupCards[table.indexOf(playAreaGroupCards,obj)]) 
                            table.remove(playAreaGroupCards, table.indexOf(playAreaGroupCards, obj))

                            --turn = turn + 2
                 end})
            delay = delay  + 100
        end
    end
    fillUpUsers()
end
function fillUpUsers()
    del = 900
    if (table.maxn(myCards) < 6 ) then
        dealMe(6  - table.maxn(myCards))
    end

    if (table.maxn(user2Cards) < 6 ) then
        dealUser2(6  - table.maxn(user2Cards))
    end

    if (table.maxn(user3Cards) < 6) then
        dealUser3(6  - table.maxn(user3Cards))
    end

    if (table.maxn(user4Cards) < 6) then
        dealUser4(6  - table.maxn(user4Cards))
    end
end
function isMyCardHolderFull()
    if (table.maxn(myCards) == 6) then
        return true
    else 
        return false
    end
end
function findEmptySpotInHolder()
    local nums = {}
    for i = 1, table.maxn( myCards ) do
        table.insert(nums, myCards[i].x)
    end
    table.sort(nums)
    if (table.maxn( myCards ) == 1 ) then
        local contentX,contentY = myUserArea.myUserCards:localToContent( - myUserArea.myUserCards.width * 1/2 + 1/2*cardWidth + 2, 0 )
        return contentX
    else
        return nums[table.maxn(nums)] + cardWidth
    end
end
function findSpots()
    local result = {}
    local playAreaX = playAreaGroup.playArea.x
    local playAreaY = playAreaGroup.playArea.y
    local spot={}
    spot.x = playAreaX + 50
    spot.y = playAreaY - 100
    table.insert(result,spot)
    spot.x = playAreaX - 50 
    spot.y = playAreaY 
    table.insert(result,spot)
    spot.x = playAreaX + 50 
    spot.y = playAreaY
    table.insert(result,spot)
    spot.x = playAreaX - 50
    spot.y = playAreaY + 100
    table.insert(result,spot)
    spot.x = playAreaX + 50
    spot.y = playAreaY + 100
    table.insert(result,spot)

    return result
end
function findNextPlayAreaSpot()
    local playAreaWidth = playAreaGroup.playArea.width
        local playAreaHeight = playAreaGroup.playArea.height
        local playAreaX = playAreaGroup.playArea.x
        local playAreaY = playAreaGroup.playArea.y
        local xMin  = playAreaGroup.playArea.contentBounds.xMin
        local xMax  = playAreaGroup.playArea.contentBounds.xMax
        local yMin  = playAreaGroup.playArea.contentBounds.yMin
        local yMax = playAreaGroup.playArea.contentBounds.yMax
        local openSpots = {}
        openSpots.one = true
        openSpots.two = true
        openSpots.three = true 
        openSpots.four = true
        openSpots.five = true
        openSpots.six = true

        if (table.maxn(playAreaGroupCards) == 0) then
            moveToX = playAreaX - 50
            moveToY = playAreaY - 100
        else
            for i=1, table.maxn(playAreaGroupCards) do
                
                if (playAreaGroupCards[i].x  == (playAreaX + 50) and playAreaGroupCards[i].y == (playAreaY - 100)) then
                    openSpots.two = false
                end
                if (playAreaGroupCards[i].x == (playAreaX - 50) and playAreaGroupCards[i].y ==  playAreaY) then
                    openSpots.three = false
                end
                if (playAreaGroupCards[i].x == (playAreaX + 50) and  playAreaGroupCards[i].y ==  playAreaY) then
                    openSpots.four = false
                end
                if (playAreaGroupCards[i].x == (playAreaX - 50) and  playAreaGroupCards[i].y ==  (playAreaY + 100)) then
                    openSpots.five = false
                end
                if (playAreaGroupCards[i].x == (playAreaX + 50) and playAreaGroupCards[i].y ==   (playAreaY + 100)) then
                    openSpots.six = false
                end
            end
            

                if (openSpots.two) then
                    moveToX = playAreaX + 50
                    moveToY = playAreaY - 100
                elseif (openSpots.three) then
                    moveToX = playAreaX - 50 
                    moveToY = playAreaY 
                elseif (openSpots.four) then
                    moveToX = playAreaX + 50 
                    moveToY = playAreaY
                elseif (openSpots.five) then
                    moveToX = playAreaX - 50
                    moveToY = playAreaY + 100
                elseif (openSpots.six) then
                    moveToX = playAreaX + 50
                    moveToY = playAreaY + 100
                end

        end
        local result = {}
        result.moveToX = moveToX
        result.moveToY = moveToY
        return result
end
function reScaleCards ()
    print("whos turn: " .. turn)
    if (turn == 1) then         --our turn
        for i=1, table.maxn(user2backCards) do
            user2backCards[i].fill.effect = ""
            user2backCards[i].width = cardWidth
            user2backCards[i].height = cardHeight
        end
        for i=1, table.maxn(user3backCards) do
            user3backCards[i].fill.effect = "filter.blurGaussian"
            if (user3backCards[i].width ~= cardWidth * .8) then
                user3backCards[i].width = cardWidth * .8
                user3backCards[i].height = cardHeight * .8
            end
        end
        for i=1, table.maxn(user4backCards) do
            user4backCards[i].fill.effect = "filter.blurGaussian"
            if (user4backCards[i].width ~= cardWidth * .8) then
                user4backCards[i].width = cardWidth * .8
                user4backCards[i].height = cardHeight * .8
            end
        end
        yourTurn = true
    elseif (turn == 2) then     --user 2 turn
        for i=1, table.maxn(user3backCards) do
            user2backCards[i].fill.effect = ""
            user3backCards[i].width = cardWidth
            user3backCards[i].height = cardHeight
        end
        for i=1, table.maxn(user2backCards) do
            user2backCards[i].fill.effect = ""
            if (user2backCards[i].width ~= cardWidth * .8) then
                user2backCards[i].width = cardWidth * .8
                user2backCards[i].height = cardHeight * .8
            end
        end
        for i=1, table.maxn(user4backCards) do
            user4backCards[i].fill.effect = "filter.blurGaussian"
            if (user4backCards[i].width ~= cardWidth * .8) then
                user4backCards[i].width = cardWidth * .8
                user4backCards[i].height = cardHeight * .8
            end
        end
        yourTurn = false
    elseif (turn == 3) then     --user 3 turn
        for i=1, table.maxn(user4backCards) do
            user2backCards[i].fill.effect = ""
            user4backCards[i].width = cardWidth
            user4backCards[i].height = cardHeight
        end
        for i=1, table.maxn(user2backCards) do
            user2backCards[i].fill.effect = "filter.blurGaussian"
            if (user2backCards[i].width ~= cardWidth * .8) then
                user2backCards[i].width = cardWidth * .8
                user2backCards[i].height = cardHeight * .8
            end
        end
        for i=1, table.maxn(user3backCards) do
            user2backCards[i].fill.effect = ""
            if (user3backCards[i].width ~= cardWidth * .8) then
                user3backCards[i].width = cardWidth * .8
                user3backCards[i].height = cardHeight * .8
            end
        end
        yourTurn = false
    elseif (turn == 4) then     --user 4 turn
        for i=1, table.maxn(user4backCards) do
            user2backCards[i].fill.effect = ""
            if (user4backCards[i].width ~= cardWidth * .8) then
                user4backCards[i].width = cardWidth * .8
                user4backCards[i].height = cardHeight * .8
            end
        end
        yourTurn = true
    end

    if (yourTurn ~= true)  then
        for i=1, table.maxn(myCards) do
            myCards[i].fill.effect = "filter.blurGaussian"
        end
    end
end

function reArrangeMyCards()
    local containerWidth = myUserArea.myUserCards.width
    local spacePerCard = containerWidth/ (table.maxn( myCards ))
    local contentX,contentY = myUserArea.myUserCards:localToContent( - myUserArea.myUserCards.width * 1/2 + 1/2*spacePerCard + 2, 0 )
    
    
    for i =1, table.maxn( myCards ) do
        transition.moveTo( myCards[i], {x = contentX + spacePerCard * (i-1), y= contentY, time = 100} )
    end

end
function updateCardCounter(event)
        user2Area.numOfCardsUser2.text = table.maxn( user2Cards )

        user3Area.numOfCardsUser3.text = table.maxn( user3Cards )
        
        user4Area.numOfCardsUser4.text = table.maxn( user4Cards )

        sceneGroup.numOfCardsDeck.text = table.maxn( cards ) - handCardIndex + 1 .. " /52"
end
timer.performWithDelay( 1000, updateCardCounter, 0 )
updateTimer = timer.performWithDelay( 7000, reArrangeMyCards, 0 )
function printAllTheCards()
            print ("---------My Cards--------")
            for i=1, table.maxn(myCards) do
                print ("my cards: " .. myCards[i].value .. " @" ..myCards[i].x .." " .. myCards[i].y)
            end
            print ("-----------------") 

            print ("---------User2 Cards--------")
            for i=1, table.maxn(user2Cards) do
                print ("my cards: " .. user2Cards[i].value .. " @" ..user2Cards[i].x .." " .. user2Cards[i].y)
            end

            print ("---------User3 Cards--------")
            for i=1, table.maxn(user3Cards) do
                print ("my cards: " .. user3Cards[i].value .. " @" ..user3Cards[i].x .." " .. user3Cards[i].y)
            end

            print ("---------User4 Cards--------")
            for i=1, table.maxn(user4Cards) do
                print ("my cards: " .. user4Cards[i].value .. " @" ..user4Cards[i].x .." " .. user4Cards[i].y)
            end

            print ("-----------------") 
            print ("---------PlayArea Cards--------")
            for i=1, table.maxn(playAreaGroupCards) do
                print ("playarea group cards: " .. playAreaGroupCards[i].value .. " @" ..playAreaGroupCards[i].x .." " .. playAreaGroupCards[i].y)
            end
            print ("-----------------")
end
-------------------------------Scene Create/Show/Destroy-----------------------------------------
function scene:create( event )
	sceneGroup = self.view

    createAllObjects(sceneGroup)

    myUserArea = sceneGroup.myUserArea
    user2Area = sceneGroup.user2Area
    user3Area = sceneGroup.user3Area
    user4Area = sceneGroup.user4Area
    cards = sceneGroup.cards
    backCards = sceneGroup.backCards
    playAreaGroup = sceneGroup.playAreaGroup
    cardHeight = sceneGroup.cardHeight
    cardWidth = sceneGroup.cardWidth

    shuffleCards(cards)

    
    local playArea = display.newRect( 0, 0, maxX/2,  maxY/2)
        playArea:setFillColor( .7, .4)
        playArea.alpha = .3
        playArea.x = centerX
        playArea.y = centerY
    playAreaGroup.playArea = playArea
	
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
		--physics.start()

    dealCards(6)
    printAllTheCards()
    GamePlay()
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
