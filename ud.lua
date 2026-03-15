

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local FPS_CAP = 30
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    local now = tick()
    local targetDelta = 1 / FPS_CAP
    while (tick() - lastTime) < targetDelta do
    end
    lastTime = tick()
end)

local function applyPotato()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ShadowSoftness = 0
    Lighting.FogEnd = 60          
    Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(90, 90, 90)  
    Lighting.ClockTime = 12      

    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") then
            v.Enabled = false
        end
    end

    if Lighting:FindFirstChildOfClass("Sky") then
        Lighting:FindFirstChildOfClass("Sky"):Destroy()
    end

    local function potatoify(obj)
        if obj:IsA("BasePart") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false

            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1
                end
            end
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        pcall(potatoify, obj)
    end

    workspace.DescendantAdded:Connect(function(obj)
        task.delay(0.2, function()
            pcall(potatoify, obj)
        end)
    end)
end

local function createBlackOverlay()
    local sg = player:WaitForChild("PlayerGui"):FindFirstChild("BlackoutGui")
    if not sg then
        sg = Instance.new("ScreenGui")
        sg.Name = "BlackoutGui"
        sg.IgnoreGuiInset = true        
        sg.ResetOnSpawn = false
        sg.Parent = player.PlayerGui
    end

    local blackFrame = sg:FindFirstChild("BlackFrame")
    if not blackFrame then
        blackFrame = Instance.new("Frame")
        blackFrame.Name = "BlackFrame"
        blackFrame.Size = UDim2.new(1, 0, 1, 0)
        blackFrame.Position = UDim2.new(0, 0, 0, 0)
        blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)  
        blackFrame.BackgroundTransparency = 0            
        blackFrame.BorderSizePixel = 0
        blackFrame.ZIndex = 9999                         
        blackFrame.Parent = sg
    end

end

task.spawn(function()
    task.wait(1)  
    applyPotato()
    createBlackOverlay()
    print("Potato")
end)

local blackVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        blackVisible = not blackVisible
        local targetTrans = blackVisible and 0 or 1
        local tween = TweenService:Create(
            player.PlayerGui.BlackoutGui.BlackFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Linear),
            {BackgroundTransparency = targetTrans}
        )
        tween:Play()
        print("Black screen toggled: " .. (blackVisible and "ON" or "OFF"))
    end
end)
