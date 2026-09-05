-- Underground War 2.0 Ultimate VIP Fixed & Crosshair Aimbot
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

-- Xóa GUI cũ nếu tồn tại để tránh trùng lặp
if PlayerGui:FindFirstChild("UGW_UltimateVIP") then
    PlayerGui.UGW_UltimateVIP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UGW_UltimateVIP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Nút mở/đóng menu nhỏ ở góc màn hình
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(0, 255, 128)
ToggleButton.Text = "MENU"
ToggleButton.TextSize, ToggleButton.Font = 11, Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui
ToggleButton.Draggable = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 290)
MainFrame.Position = UDim2.new(0.15, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.Text = "Underground War 2.0 [VIP Pro Fix]"
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local function createButton(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = name
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    return btn
end

-- 1. ESP Địch theo Team (Đỏ / Xanh)
local espEnabled = false
createButton("Team ESP (Đỏ/Xanh): TẮT", 42, function(btn)
    espEnabled = not espEnabled
    if espEnabled then
        btn.Text = "Team ESP (Đỏ/Xanh): BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Team ESP (Đỏ/Xanh): TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("UGW_TeamHighlight") then
                p.Character.UGW_TeamHighlight:Destroy()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local char = player.Character
                local hl = char:FindFirstChild("UGW_TeamHighlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "UGW_TeamHighlight"
                    hl.Parent = char
                end
                if player.Team then
                    local tName = string.lower(player.Team.Name)
                    if tName:find("red") or player.TeamColor.Name == "Bright red" then
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    elseif tName:find("blue") or player.TeamColor.Name == "Bright blue" then
                        hl.FillColor = Color3.fromRGB(0, 100, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    else
                        hl.FillColor = Color3.fromRGB(255, 255, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    end
                end
            end
        end
    end
end)

-- 2. Aimbot chuẩn theo TÂM TRÒN giữa màn hình (Crosshair) + Wallcheck
local aimbotEnabled = false
createButton("Aimbot theo Tâm (Crosshair): TẮT", 76, function(btn)
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        btn.Text = "Aimbot theo Tâm (Crosshair): BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Aimbot theo Tâm (Crosshair): TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local function isVisible(targetPart)
    if not targetPart or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- Tìm mục tiêu nằm gần tâm tròn màn hình nhất để aim
local function getCrosshairTarget()
    local bestTarget = nil
    local shortestDistanceToCenter = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild("Head") or player.Character.HumanoidRootPart
                if isVisible(targetPart) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenVector = Vector2.new(screenPos.X, screenPos.Y)
                        local distToCenter = (screenVector - screenCenter).Magnitude
                        if distToCenter < shortestDistanceToCenter then
                            shortestDistanceToCenter = distToCenter
                            bestTarget = targetPart
                        end
                    end
                end
            end
        end
    end
    return bestTarget
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getCrosshairTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

-- 3. Tự động chém kiếm (Sword Kill Aura)
local killAuraEnabled = false
createButton("Sword Kill Aura: TẮT", 110, function(btn)
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        btn.Text = "Sword Kill Aura: BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Sword Kill Aura: TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
                    if myRoot and (myRoot.Position - hrp.Position).Magnitude < 15 then
                        tool:Activate()
                    end
                end
            end
        end
    end
end)

-- 4. X-Ray Đất/Hầm (Làm mờ)
local xrayDirtEnabled = false
createButton("X-Ray Đất Hầm (Mờ): TẮT", 144, function(btn)
    xrayDirtEnabled = not xrayDirtEnabled
    if xrayDirtEnabled then
        btn.Text = "X-Ray Đất Hầm (Mờ): BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "X-Ray Đất Hầm (Mờ): TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = string.lower(obj.Name)
            local mat = obj.Material
            if nameLower:find("dirt") or nameLower:find("ground") or nameLower:find("rock") or mat == Enum.Material.Slate or mat == Enum.Material.Grass or mat == Enum.Material.Ground then
                if xrayDirtEnabled then
                    obj.Transparency = 0.65
                    obj.CanCollide = false
                else
                    obj.Transparency = 0
                    obj.CanCollide = true
                end
            end
        end
    end
end)

-- 5. Noclip Xuyên Hầm
local noclipEnabled = false
createButton("Noclip Xuyên Hầm: TẮT", 178, function(btn)
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        btn.Text = "Noclip Xuyên Hầm: BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Noclip Xuyên Hầm: TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

RunService.Stepped:Connect(function()
    if noclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 6. Tốc độ & Reset
createButton("Tốc độ nhanh (Speed 50)", 212, function(btn)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end
end)

createButton("Reset Mặc định", 246, function(btn)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
