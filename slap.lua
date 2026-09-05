-- Blade Ball Auto Parry & VIP Script
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

if PlayerGui:FindFirstChild("BladeBallVIP") then
    PlayerGui.BladeBallVIP:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BladeBallVIP"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.TextColor3 = Color3.fromRGB(255, 170, 0)
ToggleButton.Text = "GUI"
ToggleButton.TextSize, ToggleButton.Font = 12, Enum.Font.SourceSansBold
ToggleButton.Parent = ScreenGui
ToggleButton.Draggable = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 220)
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
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.Text = "Blade Ball [Auto Parry VIP]"
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

-- 1. Auto Parry (Tự động đỡ bóng thông minh theo tốc độ)
local autoParryEnabled = false
createButton("Auto Parry (Tự động đỡ): TẮT", 45, function(btn)
    autoParryEnabled = not autoParryEnabled
    if autoParryEnabled then
        btn.Text = "Auto Parry (Tự động đỡ): BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Auto Parry (Tự động đỡ): TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

local function getBall()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("Part") and (obj.Name == "Ball" or obj:FindFirstChild("Trail")) then
            return obj
        end
    end
    for _, folder in pairs(Workspace:GetChildren()) do
        if folder:IsA("Folder") then
            local ball = folder:FindFirstChild("Ball") or folder:FindFirstChild("ActiveBall")
            if ball then return ball end
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if autoParryEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local ball = getBall()
        if ball then
            local dist = (hrp.Position - ball.Position).Magnitude
            local speed = ball.AssemblyLinearVelocity.Magnitude
            local threshold = math.clamp(speed * 0.3, 14, 30)
            
            if dist <= threshold then
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        end
    end
end)

-- 2. Spam Parry (Đỡ liên tục khi cận chiến)
local spamParryEnabled = false
createButton("Spam Parry (Đỡ liên tục): TẮT", 80, function(btn)
    spamParryEnabled = not spamParryEnabled
    if spamParryEnabled then
        btn.Text = "Spam Parry (Đỡ liên tục): BẬT"
        btn.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        btn.Text = "Spam Parry (Đỡ liên tục): TẮT"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end)

task.spawn(function()
    while true do
        if spamParryEnabled then
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            vim:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            task.wait(0.05)
        else
            task.wait(0.2)
        end
    end
end)

-- 3. Tốc độ chạy (WalkSpeed)
createButton("Tốc độ nhanh (Speed 30)", 115, function(btn)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 30
    end
end)

-- 4. Reset tốc độ
createButton("Reset Tốc độ mặc định", 150, function(btn)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)
