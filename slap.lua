-- ==========================================================
-- 👑 FIND WHO SLAPPED - PREMIUM HUB V8 (MOBILE OPTIMIZED) 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

-- 1. BẢO VỆ GIAO DIỆN & TÌM ĐƯỜNG DẪN HIỆN UI TỐI ƯU NHẤT CHO MOBILE
local function getSafeUIPath()
    local success, result = pcall(function() return gethui() end)
    if success and result then return result end
    local success2, result2 = pcall(function() return CoreGui end)
    if success2 and result2 then return result2 end
    return player:WaitForChild("PlayerGui")
end

local targetParent = getSafeUIPath()
if targetParent:FindFirstChild("FindWhoSlappedPremium") then
    targetParent.FindWhoSlappedPremium:Destroy()
end

-- 2. TẠO GIAO DIỆN (UI) HIỆN ĐẠI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

-- Nút Logo thu gọn
local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.2, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.Image = "rbxassetid://10618928818" -- Bàn tay tát Icon
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", ToggleBtn)
stroke1.Color = Color3.fromRGB(255, 215, 0) -- Viền vàng VIP
stroke1.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.15, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local stroke2 = Instance.new("UIStroke", MainFrame)
stroke2.Color = Color3.fromRGB(255, 215, 0)
stroke2.Thickness = 2

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

-- Tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "👑 SLAP HUB PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 14

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 35)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Sẵn sàng thống trị server!"
StatusText.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 11

-- Hàm tạo nút chuẩn VIP
local function createButton(text, yPos, color1, color2)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local gradient = Instance.new("UIGradient", btn)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    return btn
end

local AutoSlapBtn = createButton("💥 AUTO TÁT (SUPER HIT): TẮT", 65, Color3.fromRGB(180, 40, 40), Color3.fromRGB(120, 20, 20))
local DetectorBtn = createButton("🔍 CẢNH BÁO KẺ TÁT: TẮT", 110, Color3.fromRGB(40, 180, 40), Color3.fromRGB(20, 120, 20))
local ESPBtn = createButton("👁️ NHÌN XUYÊN TƯỜNG (ESP): TẮT", 155, Color3.fromRGB(40, 100, 180), Color3.fromRGB(20, 60, 120))
local SpeedBtn = createButton("⚡ HACK TỐC ĐỘ CHẠY", 200, Color3.fromRGB(150, 80, 180), Color3.fromRGB(100, 40, 120))
local CloseBtn = createButton("❌ ĐÓNG MENU", 240, Color3.fromRGB(60, 60, 60), Color3.fromRGB(30, 30, 30))

-- ==========================================
-- 3. CHỨC NĂNG: AUTO TÁT SIÊU VIỆT (SUPER HIT)
-- ==========================================
local autoSlap = false
local function performSlap()
    pcall(function()
        -- 1. Ưu tiên: Kích hoạt Tool (Vật phẩm tay tát) nếu có
        local char = player.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then tool:Activate() end
            end
            for _, tool in ipairs(player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = char
                    tool:Activate()
                end
            end
        end
        -- 2. Kích hoạt phím E ảo (Vì game có chức năng E SLAP)
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end)
end

AutoSlapBtn.MouseButton1Click:Connect(function()
    autoSlap = not autoSlap
    if autoSlap then
        AutoSlapBtn.Text = "💥 AUTO TÁT (SUPER HIT): BẬT"
        AutoSlapBtn.AutoButtonColor = false
        StatusText.Text = "Đang Auto Tát Mọi Đứa Gần Nhất!"
        task.spawn(function()
            while autoSlap do
                performSlap()
                task.wait(0.1) -- Tốc độ tát kinh hoàng
            end
        end)
    else
        AutoSlapBtn.Text = "💥 AUTO TÁT (SUPER HIT): TẮT"
        StatusText.Text = "Đã dừng Auto Tát."
    end
end)

-- ==========================================
-- 4. CHỨC NĂNG: BẮT QUẢ TANG KẺ TÁT (DETECTOR)
-- ==========================================
local detector = false
local lastHealth = 100

-- Hàm hiển thị thông báo nổi giữa màn hình
local function notifyCulprit(name, damage)
    local notif = Instance.new("TextLabel", ScreenGui)
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.7, 0)
    notif.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    notif.Text = "🚨 " .. name .. " VỪA TÁT BẠN! (-" .. math.floor(damage) .. " HP)"
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.GothamBlack
    notif.TextSize = 14
    Instance.new("UICorner", notif).CornerRadius = UDim.new(0, 8)
    
    -- Hiệu ứng bay lên và mờ dần
    local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(notif, tweenInfo, {Position = UDim2.new(0.5, -150, 0.4, 0), TextTransparency = 1, BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function() notif:Destroy() end)
end

DetectorBtn.MouseButton1Click:Connect(function()
    detector = not detector
    if detector then
        DetectorBtn.Text = "🔍 CẢNH BÁO KẺ TÁT: BẬT"
        StatusText.Text = "Đang theo dõi radar máu..."
    else
        DetectorBtn.Text = "🔍 CẢNH BÁO KẺ TÁT: TẮT"
        StatusText.Text = "Đã tắt radar."
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                local hm = char.Humanoid
                if lastHealth == 100 then lastHealth = hm.Health end
                
                if hm.Health < lastHealth and detector then
                    local damage = lastHealth - hm.Health
                    lastHealth = hm.Health
                    
                    local root = char:FindFirstChild("HumanoidRootPart")
                    if root then
                        local culprit = nil
                        local minDist = 20
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    culprit = p
                                end
                            end
                        end
                        if culprit then
                            notifyCulprit(culprit.Name, damage)
                        end
                    end
                elseif hm.Health > lastHealth then
                    lastHealth = hm.Health
                end
            end
        end)
    end
end)

-- ==========================================
-- 5. CHỨC NĂNG: ESP (NHÌN XUYÊN TƯỜNG)
-- ==========================================
local espEnabled = false
local espHighlights = {}

local function createESP(targetPlayer)
    if targetPlayer == player then return end
    local char = targetPlayer.Character
    if char and not char:FindFirstChild("ESPHighlight") then
        local hl = Instance.new("Highlight", char)
        hl.Name = "ESPHighlight"
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        table.insert(espHighlights, hl)
    end
end

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPBtn.Text = "👁️ NHÌN XUYÊN TƯỜNG (ESP): BẬT"
        StatusText.Text = "Đã bật nhìn trộm mọi người chơi!"
        for _, p in pairs(Players:GetPlayers()) do createESP(p) end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                if espEnabled then task.wait(1) createESP(p) end
            end)
        end)
    else
        ESPBtn.Text = "👁️ NHÌN XUYÊN TƯỜNG (ESP): TẮT"
        for _, hl in pairs(espHighlights) do
            if hl and hl.Parent then hl:Destroy() end
        end
        espHighlights = {}
    end
end)

-- ==========================================
-- 6. TĂNG TỐC ĐỘ (BỎ CHẠY TRỐN / ĐUỔI THEO)
-- ==========================================
SpeedBtn.MouseButton1Click:Connect(function()
    pcall(function()
        local hm = player.Character.Humanoid
        if hm.WalkSpeed <= 16 then
            hm.WalkSpeed = 50
            SpeedBtn.Text = "⚡ TỐC ĐỘ: ĐANG CHẠY NHANH"
            StatusText.Text = "Tốc độ: 50 (Sẵn sàng bỏ trốn!)"
        else
            hm.WalkSpeed = 16
            SpeedBtn.Text = "⚡ HACK TỐC ĐỘ CHẠY"
            StatusText.Text = "Tốc độ: Mặc định"
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Chống Văng Game
player.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
end)
