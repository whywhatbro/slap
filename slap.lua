-- Script Hub: Find Who Slapped - Auto Strong Slap & Detector
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local targetParent = CoreGui
pcall(function()
    if gethui then targetParent = gethui() end
end)

if targetParent:FindFirstChild("FindWhoSlappedPro") then
    targetParent.FindWhoSlappedPro:Destroy()
end

-- 1. TẠO GIAO DIỆN MENU NỔI TRÊN MÀN HÌNH ĐIỆN THOẠI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ToggleBtn.Text = "🖐️"
ToggleBtn.TextSize = 20
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 100, 100)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 240, 0, 225)
MainFrame.Position = UDim2.new(0.08, 0, 0.35, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 100, 100)

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    ToggleBtn.Text = menuVisible and "🖐️" or "👁️"
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 28)
Title.BackgroundTransparency = 1
Title.Text = "⚡ SLAP PRO: AUTO & DETECT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 22)
StatusText.Position = UDim2.new(0, 0, 0, 26)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Trạng thái: Đang theo dõi..."
StatusText.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 9

local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local DetectorBtn = createButton("🔍 ĐOÁN NGƯỜI TÁT: [BẬT]", 55, Color3.fromRGB(50, 150, 50))
local AutoStrongSlapBtn = createButton("💥 TỰ ĐỘNG TÁT MẠNH: [TẮT]", 95, Color3.fromRGB(180, 50, 50))
local ClearLogBtn = createButton("🧹 XÓA LỊCH SỬ THÔNG BÁO", 135, Color3.fromRGB(60, 60, 80))
local UnloadBtn = createButton("❌ ĐÓNG SCRIPT", 175, Color3.fromRGB(120, 40, 40))

-- 2. TÍNH NĂNG ĐOÁN / PHÁT HIỆN NGƯỜI TÁT (SLAP DETECTOR)
local detectorEnabled = true
DetectorBtn.MouseButton1Click:Connect(function()
    detectorEnabled = not detectorEnabled
    if detectorEnabled then
        DetectorBtn.Text = "🔍 ĐOÁN NGƯỜI TÁT: [BẬT]"
        DetectorBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        StatusText.Text = "Đã bật tính năng bắt người tát!"
    else
        DetectorBtn.Text = "🔍 ĐOÁN NGƯỜI TÁT: [TẮT]"
        DetectorBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusText.Text = "Đã tắt bắt người tát."
    end
end)

-- Theo dõi sự thay đổi máu (Health) hoặc các thuộc tính va chạm để truy vết kẻ vừa đánh
local lastHealth = player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health or 100

RunService.RenderStepped:Connect(function()
    if not detectorEnabled then return end
    pcall(function()
        local char = player.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end
        
        -- Nếu máu bịụt đột ngột (bị tát/tấn công)
        if humanoid.Health < lastHealth then
            local damageDealt = lastHealth - humanoid.Health
            lastHealth = humanoid.Health
            
            -- Tìm người chơi đứng gần nhất trong bán kính 12 mét (thường là người vừa tát bạn)
            local closestPlayer = nil
            local shortestDistance = 12
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = p.Character.HumanoidRootPart
                    local dist = (rootPart.Position - targetRoot.Position).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestPlayer = p
                    end
                end
            end
            
            if closestPlayer then
                StatusText.Text = "🚨 Kẻ vừa tát bạn: " .. closestPlayer.Name .. " (" .. math.floor(damageDealt) .. " HP)"
            else
                StatusText.Text = "⚠️ Bị tát từ góc khuất / ai đó gần đây!"
            end
        elseif humanoid.Health > lastHealth then
            lastHealth = humanoid.Health -- Cập nhật khi hồi máu
        end
    end)
end)

-- 3. TÍNH NĂNG TỰ ĐỘNG TÁT MẠNH (AUTO STRONG SLAP)
local autoStrongSlapEnabled = false
AutoStrongSlapBtn.MouseButton1Click:Connect(function()
    autoStrongSlapEnabled = not autoStrongSlapEnabled
    if autoStrongSlapEnabled then
        AutoStrongSlapBtn.Text = "💥 TỰ ĐỘNG TÁT MẠNH: [BẬT]"
        AutoStrongSlapBtn.BackgroundColor3 = Color3.fromRGB(50, 160, 50)
        StatusText.Text = "💥 Đang kích hoạt tát mạnh liên tục..."
        
        task.spawn(function()
            local vim = VirtualInputManager
            local camera = workspace.CurrentCamera
            local viewportSize = camera.ViewportSize
            local centerX = viewportSize.X / 2
            local centerY = viewportSize.Y / 2
            
            while autoStrongSlapEnabled do
                pcall(function()
                    -- Giữ chuột lâu hơn một chút (hoặc nhấn nhả liên tục mô phỏng lực tụt tát mạnh) tương ứng giữa màn hình
                    vim:SendMouseButtonEvent(centerX, centerY, 0, true, game, 1)
                    task.wait(0.25) -- Giữ để tích lực tát mạnh
                    vim:SendMouseButtonEvent(centerX, centerY, 0, false, game, 1)
                end)
                task.wait(0.5) -- Khoảng cách giữa các cú tát mạnh
            end
        end)
    else
        AutoStrongSlapBtn.Text = "💥 TỰ ĐỘNG TÁT MẠNH: [TẮT]"
        AutoStrongSlapBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        StatusText.Text = "Đã dừng tát mạnh tự động."
    end
end)

ClearLogBtn.MouseButton1Click:Connect(function()
    StatusText.Text = "Trạng thái: Đã xóa lịch sử."
    lastHealth = player.Character and player.Character.Humanoid.Health or 100
end)

UnloadBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
