-- ==========================================================
-- 👑 FIND WHO SLAPPED - ULTIMATE HUB V14 (FIX ALL BUGS) 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 1. DỌN DẸP GIAO DIỆN CỦ
local function getSafeParent()
    local ok, res = pcall(function() return gethui() end)
    if ok and res then return res end
    local ok2, res2 = pcall(function() return CoreGui end)
    if ok2 and res2 then return res2 end
    return playerGui
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild("FindWhoSlappedV14") then
    parentGui.FindWhoSlappedV14:Destroy()
end

-- 2. TẠO GIAO DIỆN HUB
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV14"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = parentGui

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleBtn.Image = "rbxassetid://10618928818"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
local strokeT = Instance.new("UIStroke", ToggleBtn)
strokeT.Color = Color3.fromRGB(255, 215, 0)
strokeT.Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 270)
MainFrame.Position = UDim2.new(0.12, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local strokeM = Instance.new("UIStroke", MainFrame)
strokeM.Color = Color3.fromRGB(255, 215, 0)
strokeM.Thickness = 2

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundTransparency = 1
Title.Text = "👑 SLAP HUB V14 (FIXED ALL)"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 32)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Trạng thái: Hoạt động chuẩn xác"
StatusText.TextColor3 = Color3.fromRGB(100, 255, 100)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 10

local function createBtn(text, yPos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local AutoSlapBtn = createBtn("🎯 AUTO TÁT & CĂN FULL LỰC: TẮT", 60, Color3.fromRGB(180, 40, 40))
local UnlockCamBtn= createBtn("🔓 MỞ KHÓA CAM 360 (TỰ DO XOAY): TẮT", 110, Color3.fromRGB(120, 40, 180))
local AutoCocoBtn = createBtn("🥥 AUTO NHẶT DỪA (KHÔNG BỊ LỖI VĂNG): TẮT", 160, Color3.fromRGB(0, 140, 80))
local EspPlayerBtn= createBtn("👁️ HIỆN XUYÊN TƯỜNG (ESP): TẮT", 210, Color3.fromRGB(40, 120, 180))

-- HÀM BẤM NÚT CHUẨN TỌA ĐỘ MOBILE (TÍNH CẢ INSET)
local function triggerButton(guiObj)
    pcall(function()
        -- 1. Thử gửi tín hiệu trực tiếp
        if firesignal then
            firesignal(guiObj.MouseButton1Click)
            firesignal(guiObj.Activated)
        end
        if getconnections then
            for _, conn in pairs(getconnections(guiObj.MouseButton1Click)) do conn:Fire() end
            for _, conn in pairs(getconnections(guiObj.Activated)) do conn:Fire() end
        end
        
        -- 2. Thử mô phỏng nhấp chuột theo vị trí chuẩn xác
        local inset = GuiService:GetGuiInset()
        local x = guiObj.AbsolutePosition.X + (guiObj.AbsoluteSize.X / 2)
        local y = guiObj.AbsolutePosition.Y + (guiObj.AbsoluteSize.Y / 2) + inset.Y
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
end

-- ==========================================
-- 1. FIX AUTO TÁT & CĂN LỰC FULL
-- ==========================================
local autoSlap = false

AutoSlapBtn.MouseButton1Click:Connect(function()
    autoSlap = not autoSlap
    if autoSlap then
        AutoSlapBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: BẬT"
        StatusText.Text = "Đang quét nút SLAP và vạch lực !HIT!..."
        
        task.spawn(function()
            while autoSlap do
                pcall(function()
                    -- Quét các RemoteEvent hỗ trợ tát trực tiếp nếu có
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("slap") or remote.Name:lower():find("hit")) then
                            remote:FireServer()
                        end
                    end

                    -- Quét các nút giao diện SLAP / !HIT!
                    for _, v in pairs(playerGui:GetDescendants()) do
                        if (v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("ImageButton")) and v.Visible then
                            local text = v:IsA("TextLabel") and v.Text or (v:IsA("TextButton") and v.Text or "")
                            text = text:upper()
                            
                            -- Nút SLAP ban đầu
                            if text == "SLAP" or text:find("SLAP") then
                                local target = v:IsA("GuiButton") and v or v.Parent
                                if target and target:IsA("GuiButton") then
                                    triggerButton(target)
                                end
                            end
                            
                            -- Nút !HIT! khi thanh lực chạy
                            if text:find("HIT") then
                                local target = v:IsA("GuiButton") and v or v.Parent
                                if target and target:IsA("GuiButton") then
                                    -- Chờ thanh lực đạt mức cao nhất
                                    task.wait(0.65)
                                    triggerButton(target)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        AutoSlapBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: TẮT"
        StatusText.Text = "Đã tắt Auto Tát."
    end
end)

-- ==========================================
-- 2. FIX MỞ KHÓA CAMERA 360 (TỰ DO XOAY GÓC)
-- ==========================================
local unlockCam = false
local camConn = nil

local function applyFreeCam()
    pcall(function()
        camera.CameraType = Enum.CameraType.Custom
        player.CameraMinZoomDistance = 0.5
        player.CameraMaxZoomDistance = 150
        player.CameraMode = Enum.CameraMode.Classic
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
        end
    end)
end

UnlockCamBtn.MouseButton1Click:Connect(function()
    unlockCam = not unlockCam
    if unlockCam then
        UnlockCamBtn.Text = "🔓 MỞ KHÓA CAM 360: BẬT"
        StatusText.Text = "Camera đã mở tự do 360 độ!"
        
        applyFreeCam()
        
        -- Lắng nghe khi nhân vật ngồi vào ghế để reset góc quay tự do
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            camConn = player.Character:FindFirstChildOfClass("Humanoid").Seated:Connect(function()
                if unlockCam then
                    task.wait(0.1)
                    applyFreeCam()
                end
            end)
        end
    else
        UnlockCamBtn.Text = "🔓 MỞ KHÓA CAM 360 (TỰ DO XOAY): TẮT"
        StatusText.Text = "Đã trả Camera về mặc định."
        if camConn then camConn:Disconnect() end
    end
end)

-- ==========================================
-- 3. FIX AUTO NHẶT DỪA (AN TOÀN - KHÔNG VĂNG)
-- ==========================================
local autoCoco = false

AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA: BẬT"
        StatusText.Text = "Đang nhặt dừa an toàn..."
        
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("BasePart") and (v.Name:lower():find("coco") or v.Name:lower():find("nut")) then
                                -- Tắt va chạm vật lý để không bị đẩy văng nhân vật
                                v.CanCollide = false
                                
                                -- Tích hợp chạm bằng TouchTransmitter thay vì dịch chuyển nhân vật
                                local touch = v:FindFirstChildOfClass("TouchTransmitter")
                                if touch and firetouchinterest then
                                    firetouchinterest(root, v, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, v, 1)
                                else
                                    -- Nếu executor không hỗ trợ firetouchinterest thì mới đưa dừa lại sát chân
                                    v.CFrame = root.CFrame * CFrame.new(0, -2, 0)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (KHÔNG BỊ LỖI VĂNG): TẮT"
        StatusText.Text = "Đã dừng nhặt dừa."
    end
end)

-- ==========================================
-- 4. ESP HIGHLIGHT NGƯỜI CHƠI
-- ==========================================
local espEnabled = false

EspPlayerBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspPlayerBtn.Text = "👁️ HIỆN XUYÊN TƯỜNG (ESP): BẬT"
        StatusText.Text = "Đã bật viền phát sáng người chơi..."
        
        task.spawn(function()
            while espEnabled do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local hl = p.Character:FindFirstChild("SlapESP")
                            if not hl then
                                hl = Instance.new("Highlight")
                                hl.Name = "SlapESP"
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                                hl.FillTransparency = 0.3
                                hl.Parent = p.Character
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        EspPlayerBtn.Text = "👁️ HIỆN XUYÊN TƯỜNG (ESP): TẮT"
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("SlapESP") then
                p.Character.SlapESP:Destroy()
            end
        end
    end
end)
