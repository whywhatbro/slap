-- Underground War 2.0 Ultimate VIP Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("UGW_UltimateVIP") then
    CoreGui.UGW_UltimateVIP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UGW_UltimateVIP"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 240)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Text = "Underground War 2.0 [VIP Custom]"
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 1. Aimbot thông minh phân biệt Team & Check Tường (Wallcheck)
local aimbotEnabled = false
local aimBtn = createButton("Aimbot Team + Wallcheck: TẮT", 45, function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        aimBtn.Text = "Aimbot Team + Wallcheck: BẬT"
        aimBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        aimBtn.Text = "Aimbot Team + Wallcheck: TẮT"
        aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

-- Hàm kiểm tra vật cản (Wallcheck) giữa Camera và mục tiêu
local function isVisible(targetPart)
    if not targetPart or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
    end
    return false
end

-- Lọc mục tiêu khác team, ưu tiên gần nhưng phải qua Wallcheck (nếu gần bị vướng tường thì tự động tìm người ở xa hơn không bị vướng)
local function getBestTarget()
    local bestTarget = nil
    local shortestDistance = math.huge
    
    -- Bước 1: Tìm người không bị vướng tường trước
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild("Head") or player.Character.HumanoidRootPart
                if isVisible(targetPart) then
                    local dist = (Camera.CFrame.Position - targetPart.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        bestTarget = targetPart
                    end
                end
            end
        end
    end
    
    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getBestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- 2. Tự động chém kiếm (Sword Kill Aura)
local killAuraEnabled = false
local auraBtn = createButton("Sword Kill Aura: TẮT", 82, function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        auraBtn.Text = "Sword Kill Aura: BẬT"
        auraBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        auraBtn.Text = "Sword Kill Aura: TẮT"
        auraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

RunService.Heartbeat:Connect(function()
    if killAuraEnabled and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    local myRoot = char:FindFirstChild("HumanoidRootPart")
                    if myRoot and (myRoot.Position - hrp.Position).Magnitude < 14 then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- 3. X-Ray Đất/Hầm (Làm mờ xuyên qua mọi lớp đất đá)
local xrayDirtEnabled = false
local xrayBtn = createButton("X-Ray Đất Hầm (Mờ): TẮT", 119, function()
    xrayDirtEnabled = not xrayDirtEnabled
    if xrayDirtEnabled then
        xrayBtn.Text = "X-Ray Đất Hầm (Mờ): BẬT"
        xrayBtn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        xrayBtn.Text = "X-Ray Đất Hầm (Mờ): TẮT"
        xrayBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            local mat = obj.Material
            if nameLower:find("dirt") or nameLower:find("ground") or nameLower:find("rock") or mat == Enum.Material.Slate or mat == Enum.Material.Grass or mat == Enum.Material.Ground then
                if xrayDirtEnabled then
                    obj.Transparency = 0.65 -- Làm mờ để thấy xuyên qua nhiều lớp
                    obj.CanCollide = false
                else
                    obj.Transparency = 0
                    obj.CanCollide = true
                end
            end
        end
    end
end)
