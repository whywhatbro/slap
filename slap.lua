-- ==========================================================
-- 👑 FIND WHO SLAPPED - ULTIMATE HUB V10 (HITBOX & CAM UNLOCK) 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 1. BẢO VỆ GIAO DIỆN TRÊN MOBILE
local function getSafePath()
    local success, res = pcall(function() return gethui() end)
    if success and res then return res end
    local success2, res2 = pcall(function() return CoreGui end)
    if success2 and res2 then return res2 end
    return playerGui
end

local targetParent = getSafePath()
if targetParent:FindFirstChild("FindWhoSlappedV10") then
    targetParent.FindWhoSlappedV10:Destroy()
end

-- 2. TẠO MENU NỔI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV10"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ToggleBtn.Image = "rbxassetid://10618928818"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local stroke1 = Instance.new("UIStroke", ToggleBtn)
stroke1.Color = Color3.fromRGB(0, 255, 200)
stroke1.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local stroke2 = Instance.new("UIStroke", MainFrame)
stroke2.Color = Color3.fromRGB(0, 255, 200)
stroke2.Thickness = 2

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "👑 SLAP HUB V10 (HITBOX & UNLOCK)"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 11

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 30)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Trạng thái: Sẵn sàng sử dụng!"
StatusText.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 10

local function createBtn(text, yPos, color1, color2)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local gradient = Instance.new("UIGradient", btn)
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    }
    return btn
end

local AutoCocoBtn    = createBtn("🥥 AUTO NHẶT DỪA (HITBOX): TẮT", 58, Color3.fromRGB(0, 160, 120), Color3.fromRGB(0, 100, 80))
local AutoFullHitBtn = createBtn("🎯 AUTO TÁT FULL LỰC (100%): TẮT", 100, Color3.fromRGB(200, 50, 50), Color3.fromRGB(130, 20, 20))
local AutoSlapBtn    = createBtn("💥 AUTO TÁT LIÊN TỤC: TẮT", 142, Color3.fromRGB(220, 100, 30), Color3.fromRGB(150, 60, 20))
local UnlockCamBtn   = createBtn("🔓 MỞ KHOÁ CAM (NHÌN RA SAU): TẮT", 184, Color3.fromRGB(120, 50, 200), Color3.fromRGB(80, 20, 140))
local ESPBtn         = createBtn("👁️ NHÌN XUYÊN TƯỜNG (ESP): TẮT", 226, Color3.fromRGB(40, 100, 180), Color3.fromRGB(20, 60, 120))

-- HÀM KÍCH HOẠT NÚT MÀN HÌNH
local function triggerGuiButton(btn)
    if not btn or not btn:IsA("GuiButton") or not btn.Visible then return end
    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        end
    end)
    pcall(function()
        if getconnections then
            for _, conn in pairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(btn.Activated)) do conn:Fire() end
        end
    end)
    pcall(function()
        if btn.AbsolutePosition and btn.AbsoluteSize then
            local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X / 2
            local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y / 2 + 36
            VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.Begin, x, y)
            task.wait(0.01)
            VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.End, x, y)
        end
    end)
end

-- ==========================================
-- 1. AUTO NHẶT DỪA BẰNG HITBOX / TOUCH INTEREST
-- ==========================================
local autoCoco = false
AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (HITBOX): BẬT"
        StatusText.Text = "Đang hút Dừa từ xa bằng Hitbox..."
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            -- Kiểm tra vật thể Dừa (Coconut)
                            if (obj.Name:lower():find("coconut") or obj.Name:lower():find("dừa")) then
                                local touch = obj:FindFirstChildOfClass("TouchTransmitter") or obj:FindFirstChild("TouchInterest")
                                local partToTouch = obj:IsA("BasePart") and obj or obj:FindFirstChildOfClass("BasePart")
                                
                                -- 1. Dùng TouchInterest để gặt dừa từ xa
                                if firetouchinterest and partToTouch then
                                    firetouchinterest(root, partToTouch, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, partToTouch, 1)
                                end
                                
                                -- 2. Dùng ProximityPrompt từ xa
                                local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                                if prompt and prompt.Enabled then
                                    if fireproximityprompt then
                                        fireproximityprompt(prompt)
                                    else
                                        prompt:InputHoldBegin()
                                        task.wait(prompt.HoldDuration)
                                        prompt:InputHoldEnd()
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (HITBOX): TẮT"
        StatusText.Text = "Đã dừng hút dừa."
    end
end)

-- ==========================================
-- 2. AUTO TÁT FULL LỰC 100% (PERFECT HIT)
-- ==========================================
local autoFullHit = false
AutoFullHitBtn.MouseButton1Click:Connect(function()
    autoFullHit = not autoFullHit
    if autoFullHit then
        AutoFullHitBtn.Text = "🎯 AUTO TÁT FULL LỰC (100%): BẬT"
        StatusText.Text = "Đang canh thanh lực để bấm 100%..."
        task.spawn(function()
            while autoFullHit do
                pcall(function()
                    -- Quét giao diện thanh đập lực tát
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                            local txt = gui:IsA("TextButton") and gui.Text:upper() or gui.Name:upper()
                            if txt:find("HIT") or txt:find("SLAP") or txt:find("BAR") or gui.Name:find("Hit") then
                                if gui.Visible then
                                    -- Kiểm tra con trỏ vị trí nếu có indicator
                                    local indicator = gui.Parent and (gui.Parent:FindFirstChild("Indicator") or gui.Parent:FindFirstChild("Bar"))
                                    if indicator then
                                        -- Căn chỉnh đúng thời điểm thanh ở giữa/ở điểm cao nhất
                                        local posX = indicator.Position.X.Scale
                                        if posX >= 0.45 and posX <= 0.55 or posX >= 0.85 then
                                            triggerGuiButton(gui)
                                        end
                                    else
                                        -- Nếu là nút !HIT! đập lực trực tiếp
                                        triggerGuiButton(gui)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.02)
            end
        end)
    else
        AutoFullHitBtn.Text = "🎯 AUTO TÁT FULL LỰC (100%): TẮT"
        StatusText.Text = "Đã tắt Auto Full Lực."
    end
end)

-- ==========================================
-- 3. AUTO TÁT LIÊN TỤC (TỰ ĐỘNG BẤM TÁT)
-- ==========================================
local autoSlap = false
AutoSlapBtn.MouseButton1Click:Connect(function()
    autoSlap = not autoSlap
    if autoSlap then
        AutoSlapBtn.Text = "💥 AUTO TÁT LIÊN TỤC: BẬT"
        StatusText.Text = "Đang tự động nhấn tát liên tục..."
        task.spawn(function()
            while autoSlap do
                pcall(function()
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local name = gui.Name:upper()
                            local txt = gui:IsA("TextButton") and gui.Text:upper() or ""
                            if name:find("SLAP") or txt:find("SLAP") or name:find("TAP") or txt:find("TAP") then
                                triggerGuiButton(gui)
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        AutoSlapBtn.Text = "💥 AUTO TÁT LIÊN TỤC: TẮT"
        StatusText.Text = "Đã dừng tát liên tục."
    end
end)

-- ==========================================
-- 4. MỞ KHOÁ CAMERA (BẺ CAM NHÌN RA SAU KHÓA)
-- ==========================================
local unlockCam = false
UnlockCamBtn.MouseButton1Click:Connect(function()
    unlockCam = not unlockCam
    if unlockCam then
        UnlockCamBtn.Text = "🔓 MỞ KHOÁ CAM (NHÌN RA SAU): BẬT"
        StatusText.Text = "Đã mở khóa Camera! Bạn có thể xoay nhìn sau lưng."
        task.spawn(function()
            while unlockCam do
                pcall(function()
                    -- Chuyển Camera về trạng thái tự do nếu bị khóa Scriptable
                    if camera.CameraType == Enum.CameraType.Scriptable then
                        camera.CameraType = Enum.CameraType.Custom
                    end
                    
                    -- Nếu đang ngồi hoặc bị khóa hướng, hỗ trợ xoay cam 180 độ ra đằng sau
                    local char = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") then
                        camera.CameraSubject = char.HumanoidRootPart
                    end
                end)
                task.wait(0.1)
            end
        end)
    else
        UnlockCamBtn.Text = "🔓 MỞ KHOÁ CAM (NHÌN RA SAU): TẮT"
        StatusText.Text = "Đã trả lại Camera mặc định."
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
        end)
    end
end)

-- ==========================================
-- 5. ESP (NHÌN XUYÊN TƯỜNG)
-- ==========================================
local espEnabled = false
local espObjects = {}

ESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPBtn.Text = "👁️ NHÌN XUYÊN TƯỜNG (ESP): BẬT"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hl = Instance.new("Highlight", p.Character)
                hl.FillColor = Color3.fromRGB(255, 50, 50)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                table.insert(espObjects, hl)
            end
        end
    else
        ESPBtn.Text = "👁️ NHÌN XUYÊN TƯỜNG (ESP): TẮT"
        for _, obj in pairs(espObjects) do
            if obj then obj:Destroy() end
        end
        espObjects = {}
    end
end)
