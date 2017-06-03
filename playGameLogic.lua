function startTheGameLoop ()
    while  table.maxn(cards)<52 do
        local userCards
        local didUserCutInitial, didUserCutAdditions
        if (turn > 4) then turn = turn - 4 end
        if     (turn == 1)  then    userCards = myCards
        elseif (turn == 2)  then    userCards = user2Cards
        elseif (turn == 3)  then    userCards = user3Cards
        elseif (turn == 4)  then    userCards = user4Cards
        end

        goDownFirstSet(userCards)
        didUserCutInitial = userNeedsToCut()
        if (didUserCutInitial == true) then
            otherUsersAdd()
            didUserCutAdditions = userNeedsToCut()
                if (didUserCutAdditions ~= true) then
                    userTakesCards(userCards)
                    turn = turn + 2
                elseif (table.maxn(playAreaGroupCards) == 12) then
                     dumpCards()
                     turn = turn + 1
                end
        else 
            userTakesCards(userCards)
            turn = turn + 2
        end
    end
end
function goDownFirstSet (userCards)
    if (turn == 1) then
        waitForMyToAdd()
    else
        local minimumSet = findMinimumSet(userCards)
        addSetToPlayArea(minimumSet)
    end
end
function userNeedsToCut()
  if (turn == 4 ) then turn = 1 end
        if     (turn+1 == 1)  then    waitForMeToCut()
          elseif (turn+1 == 2)  then    userCards = user2Cards
          elseif (turn+1 == 3)  then    userCards = user3Cards
          elseif (turn+1 == 4)  then    userCards = user4Cards
        end
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
function addSetToPlayArea(cardSet)
  for i=1, table.maxn(cardSet) do
    local card = cardSet[i]

    local nextSpot = findNextPlayAreaSpot()
    local moveToX  = nextSpot.moveToX
    local movetoY  = nextSpot.moveToY

    local removedCardIndex

    card.isVisible = true
    transition.moveTo(card, {x=moveToX, y=moveToY, time=300,})
  end
end
function waitForMeToCut()
end
function waitForMeToAdd()
end
-----------------------------------------
function findMinimumSet(userCards)
  local cardValues 
  for i=1, table.maxn(userCards) do
      table.insert(cardValues, getCardValue(userCards[i]))
  end
  table.sort(cardValues)
  local result
  table.insert(result, cardValues[1])
  for i=2, table.maxn(cardValues) do
      if cardValues[1] == cardValues[i] then
        table.insert(result, cardValues[i])
      end
  end
  return result
end

function dumpCards()
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
function getCardValue (card)
    return card.value:sub(1, string.len(card.value) - 1)
end
function getCardSuit (card)
    return card.value:sub(string.len(card.value), string.len(card.value))
end 



