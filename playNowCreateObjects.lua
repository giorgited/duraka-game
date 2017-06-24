widget = require "widget"
json = require( "json" )
composer = require( "composer" )


centerX, centerY, zeroX, zeroY, maxX, maxY =
      display.contentCenterX, display.contentCenterY, display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight
local myUserArea , user3Area, user2Area, user4Area, playArea 
local myUserAreaWidth = maxX
local myUserAreaHeight = (140/667) * maxY
local user2AreaWidth = (4/15) * maxX
local user2AreaHeight = (387/667) * maxY
local user3AreaWidth = maxX
local user3AreaHeight = (140/667) * maxY
local user4AreaWidth = (4/15) * maxX
local user4AreaHeight = (387/667) * maxY


local deckOfCards = {
  "14S", "2S", "3S", "4S", "5S", "6S", "7S", "8S",  "9S", "10S", "11S", "12S", "13S",
  "14D", "2D", "3D", "4D", "5D", "6D", "7D", "8D",  "9D", "10D", "11D", "12D", "13D",
  "14H", "2H", "3H", "4H", "5H", "6H", "7H", "8H",  "9H", "10H", "11H", "12H", "13H",
  "14C", "2C", "3C", "4C", "5C", "6C", "7C", "8C",  "9C", "10C", "11C", "12C", "13C"
}
local cards = {}
local backCards = {}
 

function createAllObjects(sceneGroup)
    storeSharedVariables(sceneGroup)
    local background = display.newImageRect( "images/main-menu-background.png", display.actualContentWidth, display.actualContentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0 + display.screenOriginX
    background.y = 0 + display.screenOriginY
    background.fill.effect = "filter.brightness"
    background.fill.effect.intensity = -.3

    sceneGroup:insert( background )

    createSceneGrid(sceneGroup)
    createMyUserObjects(sceneGroup)
    createUser2Objects(sceneGroup)
    createUser3Objects(sceneGroup)
    createUser4Objects(sceneGroup)
    createCardObjects(sceneGroup)
    createCutterCardObject(sceneGroup)

    
end
function storeSharedVariables(sceneGroup)
    sceneGroup.cardWidth = (maxX - 30)/6
    sceneGroup.cardHeight =  sceneGroup.cardWidth * 1.3
    sceneGroup.deckOfCards = deckOfCards
    sceneGroup.playAreaGroup = {}
end
function createSceneGrid(sceneGroup)
    myUserArea =  display.newGroup()
            myUserArea.width = myUserAreaWidth
            myUserArea.height = MyUserAreaHeight
            myUserArea.x = centerX
            myUserArea.y = zeroY + ((maxY * 527/667) + (1/2 * myUserAreaHeight))
    sceneGroup.myUserArea = myUserArea

    user3Area =  display.newGroup()
            user3Area.width = user3AreaWidth
            user3Area.height = user3AreaHeight
            user3Area.x = centerX
            user3Area.y = zeroY + (1/2) * user3AreaHeight
    sceneGroup.user3Area = user3Area

    user2Area = display.newGroup()
            user2Area.width = user2AreaWidth
            user2Area.height = user2AreaHeight
            user2Area.x = zeroX + (1/2) * user2AreaWidth
            user2Area.y = centerY
    sceneGroup.user2Area = user2Area

    user4Area = display.newGroup()
            user4Area.width = user4AreaWidth
            user4Area.height = user4AreaHeight
            user4Area.x = zeroX + (11/15) * maxX + 1/2 * user4AreaWidth
            user4Area.y = centerY
    sceneGroup.user4Area = user4Area

    playArea = display.newGroup()
            playArea.width = playAreaWidth
            playArea.height = playAreaHeight
            playArea.x = centerX
            playArea.y = centerY
    sceneGroup.playArea = playArea
end

function createMyUserObjects(sceneGroup)
    local yourTurnText = display.newText( "Your Turn",0, 0, native.systemFontBold, 16)
    myUserArea.yourTurnText = yourTurnText
    myUserArea:insert(yourTurnText)

    yourTurnText.x = 0
    yourTurnText.y = -50
    local myUserCards = display.newRect( 0, 0, sceneGroup.cardWidth*6,  sceneGroup.cardHeight)
        myUserCards.strokeWidth = 3
        myUserCards:setFillColor( 0.7, .4 )
        myUserCards:setStrokeColor( 1, 0, 0, .4 )

    local doneButton = widget.newButton
        {
            x = 0, 
            y = myUserCards.y + (1/2)*myUserCards.height + 18, 
            width = maxX * .25, 
            height = maxY * .04, 
            defaultFile = "images/doneButton.png",
            label= "done",
            labelColor = { default={ 1, 1, 1, .6 }, over={ 0, 0, 0, 0.5 }},
            onPress = doneButtonPressed,
        }
        doneButton:setFillColor( 0 )

    local place = display.newText( "",0, 0, native.systemFontBold, 16)
    place.x = doneButton.x - 100
    place.y = doneButton.y
    myUserArea.place = place
    myUserArea:insert(place)


    myUserArea.myUserCards = myUserCards
    myUserArea:insert(myUserCards)
    myUserArea.doneButton = doneButton
    myUserArea:insert(doneButton)

    local text = display.newText( "You Completed The Game! ", myUserArea.x, myUserArea.y, native.systemFontBold, 20)
    text.isVisible = false
    myUserArea.completionText =  text

    
    sceneGroup.myUserArea = myUserArea
    sceneGroup:insert(myUserArea)
end
function createUser2Objects(sceneGroup)

    local user2CardContainer = display.newRect( 0, 0, sceneGroup.cardWidth *.8, sceneGroup.cardHeight*.8)
        user2CardContainer.strokeWidth = 3
        user2CardContainer:setFillColor( 0.7, .4 )
        user2CardContainer:setStrokeColor( 1, 0, 0, .4 )
        
    local title = display.newText( "User 2", user2CardContainer.x, user2CardContainer.y + 1/2*sceneGroup.cardHeight + 5, native.systemFontBold, 12)
    local text = display.newText( "Remaining Cards: ", title.x, title.y + 15, native.systemFont, 10)
    local numOfCardsUser2 = display.newText( "0", text.x, text.y + 15, native.systemFont, 10)
    numOfCardsUser2.value = 0

    local place = display.newText( "",0, 0, native.systemFontBold, 14)
    place.x = user2CardContainer.x
    place.y = user2CardContainer.y - 50

    user2Area.user2CardContainer = user2CardContainer
    user2Area.text = text
    user2Area.numOfCardsUser2 = numOfCardsUser2
    user2Area.place  = place

    user2Area:insert(user2CardContainer)
    user2Area:insert(title)
    user2Area:insert(text)
    user2Area:insert(place)
    user2Area:insert(numOfCardsUser2)

    sceneGroup:insert(user2Area)
    --sceneGroup:insert(numOfCardsUser2)
    --sceneGroup:insert(user2)
end
function createUser3Objects(sceneGroup)
    local user3CardContainer = display.newRect( 0, 0, sceneGroup.cardWidth*.8,  sceneGroup.cardHeight*.8)
        user3CardContainer.strokeWidth = 3
        user3CardContainer:setFillColor( .7, .4)
        user3CardContainer:setStrokeColor( 1, 0, 0, .4 )
        
    local title = display.newText( "User 3", user3CardContainer.x, user3CardContainer.y + 1/2*sceneGroup.cardHeight + 5, native.systemFontBold, 12)
    local text = display.newText( "Remaining Cards: ", title.x, title.y + 15, native.systemFont, 10)
    local place = display.newText( "",0, 0, native.systemFontBold, 14)
    place.x = user3CardContainer.x
    place.y = user3CardContainer.y - 50


    local numOfCardsUser3 = display.newText( "0", text.x, text.y+15, native.systemFont, 10)
    numOfCardsUser3.value = 0
    
    user3Area.user3CardContainer = user3CardContainer
    user3Area.text = text
    user3Area.numOfCardsUser3 = numOfCardsUser3
    user3Area.place = place

    user3Area:insert(user3CardContainer)
    user3Area:insert(title)
    user3Area:insert(text)
    user3Area:insert(place)
    user3Area:insert(numOfCardsUser3)
    sceneGroup:insert(user3Area)
end
function createUser4Objects(sceneGroup)
    local user4CardContainer = display.newRect( 0, 0, sceneGroup.cardWidth*.8, sceneGroup.cardHeight*.8)
        user4CardContainer.strokeWidth = 3
        user4CardContainer:setFillColor( 0.7, .4 )
        user4CardContainer:setStrokeColor( 1, 0, 0, .4 )

    local title = display.newText( "User 4", user4CardContainer.x, user4CardContainer.y + 1/2*sceneGroup.cardHeight + 5, native.systemFontBold, 12)
    local text = display.newText( "Remaining Cards: ", title.x, title.y + 15, native.systemFont, 10)

    local place = display.newText( "",0, 0, native.systemFontBold, 14)
    place.x = user4CardContainer.x
    place.y = user4CardContainer.y - 50

    local numOfCardsUser4 = display.newText( "0", text.x, text.y+15, native.systemFont, 10)
    numOfCardsUser4.value = 0
    
    
    user4Area.user4CardContainer = user4CardContainer
    user4Area.text = text
    user4Area.numOfCardsUser4 = numOfCardsUser4
    user4Area.place = place

    user4Area:insert(title)
    user4Area:insert(user4CardContainer)
    user4Area:insert(text)
    user4Area:insert(place)
    user4Area:insert(numOfCardsUser4)

    sceneGroup:insert(user4Area)
end
function createCardObjects(sceneGroup)
   sceneGroup.cards ={}

    for i = 1, 52 do
        local cardFront = display.newImage("images/DeckOfCards/".. deckOfCards[i].."-min.jpg", zeroX + sceneGroup.cardWidth/2, zeroY + sceneGroup.cardHeight/2)
            cardFront.width= sceneGroup.cardWidth
            cardFront.height = sceneGroup.cardHeight
            cardFront.isVisible = false
            cardFront.value = deckOfCards[i]
        sceneGroup.cards[i] = cardFront
        local cardBack = display.newImage("images/DeckOfCards/faceDown-min.jpg", zeroX + sceneGroup.cardWidth * .8/2, zeroY + sceneGroup.cardHeight * .8/2)
            cardBack.width= sceneGroup.cardWidth * .8
            cardBack.height = sceneGroup.cardHeight * .8
            cardBack.x = zeroX + sceneGroup.cardWidth/2
            cardBack.y = zeroY + sceneGroup.cardHeight/2
        backCards[i] = cardBack
        sceneGroup:insert(cardBack)
    end

    sceneGroup.backCards = backCards


    local numOfCardsDeck = display.newText( "52/52", zeroX + sceneGroup.cardWidth/2 , zeroY + sceneGroup.cardHeight, native.systemFontBold, 12)
    numOfCardsDeck:setFillColor( black )
    numOfCardsDeck.value = 52
    
    sceneGroup.numOfCardsDeck = numOfCardsDeck
    sceneGroup:insert(numOfCardsDeck)
end

function createCutterCardObject(sceneGroup)
    local cutterSuit = display.newText( "Cutter Suit", maxX - 32, zeroY + sceneGroup.cardHeight/2 - 10, native.systemFontBold, 12)

    local cutterHeart = display.newImageRect( "images/heart.png", display.actualContentWidth, display.actualContentHeight )
    cutterHeart.x = cutterSuit.x
    cutterHeart.y = cutterSuit.y + 30
    cutterHeart.width= 30 
    cutterHeart.height = 30 
    cutterHeart.isVisible = false
    cutterHeart.value = "H"
    local cutterDiamond = display.newImageRect( "images/diamond.png", display.actualContentWidth, display.actualContentHeight )
    cutterDiamond.x = cutterSuit.x
    cutterDiamond.y = cutterSuit.y + 30
    cutterDiamond.width= 40 
    cutterDiamond.height = 40 
    cutterDiamond.isVisible = false
    cutterDiamond.value = "D"
    local cutterClub = display.newImageRect( "images/club.png", display.actualContentWidth, display.actualContentHeight )
    cutterClub.x = cutterSuit.x
    cutterClub.y = cutterSuit.y + 30
    cutterClub.width= 30 
    cutterClub.height = 30 
    cutterClub.isVisible = false
    cutterClub.value = "C"
    local cutterSpade = display.newImageRect( "images/spade.png", display.actualContentWidth, display.actualContentHeight )
    cutterSpade.x = cutterSuit.x
    cutterSpade.y = cutterSuit.y + 30
    cutterSpade.width= 30 
    cutterSpade.height = 40 
    cutterSpade.isVisible = false
    cutterSpade.value = "S"
    local cutters = {}
    table.insert(cutters, cutterHeart)
    table.insert(cutters, cutterDiamond)
    table.insert(cutters, cutterClub)
    table.insert(cutters, cutterSpade)

    local a = cutters[math.random(4)]    
    a.isVisible = true

    sceneGroup.cutterCard = a
    sceneGroup:insert(a)
end
