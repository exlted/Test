-- Declarations
Jump = {}

jumpWindow = nil
jumpButton = nil
jumpWindowReady = nil
jumpButtonMoveDelta = nil

-- Utility functions
local padding = 20

-- Handles finding the lowest point that Y should be at for the inner rect
local function getStartingBottomPosition(parentRect, innerRect)
	local parentBottom  = parentRect.y + parentRect.height
	
	return parentBottom - innerRect.height - padding
end

-- Handles finding the leftmost point that X should be at  for the inner rect
local function getStartingRightPosition(parentRect, innerRect)
	local parentRight = parentRect.x + parentRect.width
	
	return parentRight - innerRect.width - padding
end

-- Checks whether the innerRect is contained by the parentRect
local function isContainedBy(innerRect, parentRect)
	return innerRect.x > parentRect.x and (innerRect.x + innerRect.width) < (parentRect.x + parentRect.width)
	   and innerRect.y > parentRect.y and (innerRect.y + innerRect.height) < (parentRect.y + parentRect.height)
end

-- Main Hooks
function init()
	connect(g_game, {onOpenJumpWindow = Jump.create,
	                 onGameEnd = Jump.destroy})
	connect(g_app, {onNewFrame = Jump.run})

    g_keyboard.bindKeyDown('Ctrl+J', Jump.toggle)
end


function terminate()
    g_keyboard.unbindKeyDown('Ctrl+J')

	disconnect (g_game, {onOpenJumpWindow = Jump.create,
						 onGameEnd = Jump.destroy})
	disconnect (g_game, {onNewFrame = Jump.run})

	Jump.destroy()

	Jump  = nil
end

-- Internal Hooks
-- Hooks up Ctrl + J for showing/hiding the dialog
function Jump.toggle()
  if jumpWindow then
	Jump.destroy()
  else
	Jump.create()
  end
end

-- Creates and initializes the dialog
function Jump.create()
	Jump.destroy()

	jumpWindow = g_ui.displayUI("jump_dialog.otui")

	local windowRect = jumpWindow:getRect()
	
	jumpButton = jumpWindow:getChildById("buttonJump")
	local jumpButtonRect = jumpButton:getRect()
	
	jumpButton:setPosition(initialPos)
	jumpButtonMoveDelta = 0;
	jumpWindowReady = true
end

-- Cleans up and closes the dialog
function Jump.destroy()
	if jumpWindow then
		jumpWindow:destroy()
		jumpWindow = nil
		jumpButton = nil
		jumpWindowReady = nil
		jumpButtonMoveDelta = nil
	end
end

-- Handles the per-frame updates of the dialog
function Jump.run(delta)
	if jumpWindowReady then
		jumpButtonMoveDelta = jumpButtonMoveDelta - delta;
		if (jumpButtonMoveDelta <= 0) then
			local windowRect = jumpWindow:getRect()
			local jumpButtonRect = jumpButton:getRect()
			
			jumpButtonRect.x = jumpButtonRect.x - math.random(10,100)
			if (not isContainedBy(jumpButtonRect, windowRect)) then
				jumpButtonRect.x = getStartingRightPosition(windowRect, jumpButtonRect)
				jumpButtonRect.y = jumpButtonRect.y - math.random(25,  75);
				if (not isContainedBy(jumpButtonRect, windowRect)) then
					jumpButtonRect.y = getStartingBottomPosition(windowRect, jumpButtonRect)
				end
			end
			
			jumpButton:setPosition({x = jumpButtonRect.x, y = jumpButtonRect.y})
			jumpButtonMoveDelta = jumpButtonMoveDelta + math.random(100, 250)
		end
	end
end

-- Handles clicking on the Jump! button
function Jump.onButtonJumpPress()
	local windowRect = jumpWindow:getRect()
	local jumpButtonRect = jumpButton:getRect()
	
	jumpButtonRect.x = getStartingRightPosition(windowRect, jumpButtonRect)
	jumpButtonRect.y = jumpButtonRect.y - math.random(25, 75);
	if (not isContainedBy(jumpButtonRect, windowRect)) then
		jumpButtonRect.y = getStartingBottomPosition(windowRect, jumpButtonRect)
	end
	
	jumpButton:setPosition({x = jumpButtonRect.x, y = jumpButtonRect.y})
end