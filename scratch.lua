local scene = composer.newScene()
--local physics = require "physics"

local deckOfCards = {
  "14S", "2S", "3S", "4S", "5S", "6S", "7S", "8S",  "9S", "10S", "11S", "12S", "13S",
  "14D", "2D", "3D", "4D", "5D", "6D", "7D", "8D",  "9D", "10D", "11D", "12D", "13D",
  "14H", "2H", "3H", "4H", "5H", "6H", "7H", "8H",  "9H", "10H", "11H", "12H", "13H",
  "14C", "2C", "3C", "4C", "5C", "6C", "7C", "8C",  "9C", "10C", "11C", "12C", "13C"
}
local centerX, centerY, zeroX, zeroY, maxX, maxY =
      display.contentCenterX, display.contentCenterY, display.screenOriginX, display.screenOriginY, display.actualContentWidth, display.actualContentHeight
math.randomseed(os.time())
local myCards, user2Cards, user3Cards, user4Cards = {}, {}, {}, {}
local myUserArea , user3Area, user2Area, user4Area, playArea 
local myUserAreaWidth  = maxX
local myUserAreaHeight = (140/667) * maxY
local user2AreaWidth   = (4/15) * maxX
local user2AreaHeight. = (387/667) * maxY
local user3AreaWidth   = maxX
local user3AreaHeight  = (140/667) * maxY
local user4AreaWidth   = (4/15) * maxX
local user4AreaHeight  = (387/667) * maxY
local cardWidth 	   = (maxX - 30)/6
local cardheight 	   =  cardWidth * 1.3
local user2backCards,user3backCards, user4backCards = {}, {}, {}

local playAreaWidth    = (7/15) * maxX
local playAreaHeight   = (387/667) * maxY
local cards 		   = {}
local backCards = {}
local cardWidth = (display.actualContentWidth - 30)/6
local cardHeight =  cardWidth * 1.3
local sceneGroup
local yourTurn = false
local playAreaGroup = {}
local playAreaGroupCards = {}
playAreaGroupCards.myUserIsDone = true
local timerDelay = 0
local counter = 1
local moveToX = 0
local moveToY = 0
local turn = 1
local numOfCardsUser2, numOfCardsUser3, numOfCardsUser4 = {}, {}, {}
local handCardIndex = 1
local rearrangeTimer = 10000