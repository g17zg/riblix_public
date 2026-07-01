--[[made by
    
                  oe    dL ud8Nu  :8c                        
                .@88    8Fd888888L %8      ..                
     uL     ==*88888    4N88888888cuR    .@88i        uL
 .ue888Nc..    88888    4F   ^""%""d    ""%888>   .ue888Nc.. 
d88E`"888E`    88888    d       .z8       '88%   d88E`"888E` 
888E  888E     88888    ^     z888      ..dILr~` 888E  888E  
888E  888E     88888        d8888'     '".-%88b  888E  888E  
888E  888E     88888       888888       @  '888k 888E  888E  
888& .888E     88888      :888888      8F   8888 888& .888E  
*888" 888&     88888       888888     '8    8888 *888" 888&  
 `"   "888E '**%%%%%%**    '%**%      '8    888F  `"   "888E 
.dWi   `88E                            %k  <88F  .dWi   `88E 
4888~  J8%                              "+:*%`   4888~  J8%  
 ^"===*"`                                         ^"===*"`   
]]--
local a = 0
while a < 100 do
    print("made by g17zg on roblox")
    print("_k2pp on discord")
    print(":3")
    task.wait()
    a = a+1
end
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local TARGET_KEY = Enum.KeyCode.Z
local MAX_WORLD_DISTANCE = 150
local MAX_SCREEN_DISTANCE = 300

local targetCharacter = nil
local connection = nil
local isLocked = false

local function getClosestPlayerToCursor()
	local closestPlayer = nil
	local shortestScreenDistance = MAX_SCREEN_DISTANCE
	
	local localCharacter = localPlayer.Character
	if not localCharacter or not localCharacter:FindFirstChild("HumanoidRootPart") then
		return nil
	end
	
	local localPos = localCharacter.HumanoidRootPart.Position
	local mousePosition = UserInputService:GetMouseLocation()

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
				if char.Humanoid.Health > 0 then
					
					local worldDistance = (char.HumanoidRootPart.Position - localPos).Magnitude
					if worldDistance <= MAX_WORLD_DISTANCE then
						
						local screenPos, onScreen = camera:WorldToViewportPoint(char.HumanoidRootPart.Position)
						
						if onScreen then
							local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
							local screenDistance = (playerScreenPos - mousePosition).Magnitude
							
							if screenDistance < shortestScreenDistance then
								shortestScreenDistance = screenDistance
								closestPlayer = char
							end
						end
						
					end
					
				end
			end
		end
	end
	
	return closestPlayer
end

local function lockOn()
	if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
		local localCharacter = localPlayer.Character
		
		if localCharacter and localCharacter:FindFirstChild("HumanoidRootPart") then
			local currentDistance = (targetCharacter.HumanoidRootPart.Position - localCharacter.HumanoidRootPart.Position).Magnitude
			if currentDistance > MAX_WORLD_DISTANCE then
				stopLockOn()
				return
			end
		end
		
		local targetPos = targetCharacter.HumanoidRootPart.Position
		camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
	else
		stopLockOn()
	end
end

function stopLockOn()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	targetCharacter = nil
	isLocked = false
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == TARGET_KEY then
		if isLocked then
			stopLockOn()
		else
			targetCharacter = getClosestPlayerToCursor()
			if targetCharacter then
				isLocked = true
				connection = RunService.RenderStepped:Connect(lockOn)
			end
		end
	end
end)
