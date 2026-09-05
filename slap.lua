-- ==========================================================
-- 👑 FIND WHO SLAPPED - ULTIMATE HUB V12 (100% FIXED) 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- 1. BẢO VỆ GIAO DIỆN KHỎI ANTICHEAT
local function getSafePath()
    local success, res = pcall(function() return gethui() end)
    if success and res then return res end
    local success2, res2 = pcall(function() return CoreGui end)
    if success2 and res2 then return res2 end
    return playerGui
end

local targetParent = getSafePath()
if targetParent:FindFirstChild("FindWhoSlappedV12") then
    targetParent.FindWhoSlappedV12:Destroy()
end

-- 2. TẠO MENU NỔI DI ĐỘNG
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV12"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleBtn.Image = "rbxassetid://10618928818"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 255, 255)
Instance.new("UIStroke", ToggleBtn).Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 230)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 255, 255)
Instance.new("UIStroke", MainFrame).Thickness = 2

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "👑 SLAP HUB V12 (FIXED)"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 32)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Sẵn sàng hoạt động!"
StatusText.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 10

local function createBtn(text, yPos, color)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local AutoCocoBtn    = createBtn("🥥 AUTO NHẶT DỪA (KHÔNG KÉO ẢNH): TẮT", 60, Color3.fromRGB(0, 150, 100))
local AutoFullHitBtn = createBtn("🎯 AUTO TÁT & CĂN FULL LỰC: TẮT", 105, Color3.fromRGB(200, 50, 50))
local UnlockCamBtn   = createBtn("🔓 MỞ KHOÁ CAM (NHÌN RA SAU): TẮT", 150, Color3.fromRGB(100, 50, 200))
local HideBtn        = createBtn("❌ ĐÓNG GIAO DIỆN", 195, Color3.fromRGB(60, 60, 60))

-- ==========================================
-- HÀM GIẢ LẬP CLICK CHUẨN XÁC CHO MỌI EXECUTOR
-- ==========================================
local function clickGui(guiBtn)
    pcall(function()
        if firesignal then
            firesignal(guiBtn.MouseButton1Click)
            firesignal(guiBtn.Activated)
        end
        if getconnections then
            for _, c in pairs(getconnections(guiBtn.MouseButton1Click)) do c:Fire() end
            for _, c in pairs(getconnections(guiBtn.MouseButton1Down)) do c:Fire() end
            for _, c in pairs(getconnections(guiBtn.Activated)) do c:Fire() end
        end
    end)
    pcall(function()
        local x = guiBtn.AbsolutePosition.X + (guiBtn.AbsoluteSize.X / 2)
        local y = guiBtn.AbsolutePosition.Y + (guiBtn.AbsoluteSize.Y / 2) + 36
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.02)
        VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)
end

-- ==========================================
-- 1. AUTO NHẶT DỪA BẰNG TOUCH INTEREST (CHUẨN HITBOX SERVER)
-- ==========================================
local autoCoco = false
AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA: BẬT (ĐANG HÚT)"
        StatusText.Text = "Đang gửi tín hiệu chạm dừa lên server..."
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root and firetouchinterest then
                        -- Quét tất cả các vật phẩm có thể nhặt được trên bản đồ
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("TouchTransmitter") then
                                local part = v.Parent
                                if part and part:IsA("BasePart") and not part.Parent:FindFirstChild("Humanoid") then
                                    -- Gửi tín hiệu trực tiếp cho server rằng bạn đã chạm vào vật đó
                                    firetouchinterest(root, part, 0)
                                    task.wait(0.01)
                                    firetouchinterest(root, part, 1)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.3) -- Lặp lại siêu nhanh nhưng không gây lag
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (KHÔNG KÉO ẢNH): TẮT"
        StatusText.Text = "Đã dừng nhặt dừa."
    end
end)

-- ==========================================
-- 2. AUTO TÁT & CĂN FULL LỰC 100%
-- ==========================================
local autoHit = false
local isHitting = false

AutoFullHitBtn.MouseButton1Click:Connect(function()
    autoHit = not autoHit
    if autoHit then
        AutoFullHitBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: BẬT"
        StatusText.Text = "Đang theo dõi nút Tát & Thanh Lực..."
        task.spawn(function()
            while autoHit do
                pcall(function()
                    for _, obj in pairs(playerGui:GetDescendants()) do
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                            local txt = obj.Text:upper()
                            
                            if txt == "SLAP" or txt:find("!HIT!") then
                                local btn = obj
                                if not btn:IsA("GuiButton") then btn = btn.Parent end
                                
                                if btn and btn:IsA("GuiButton") and btn.Visible and btn.AbsoluteSize.X > 0 then
                                    -- Xử lý thanh căn lực
                                    if txt:find("!HIT!") and not isHitting then
                                        isHitting = true
                                        task.wait(0.62) -- Độ trễ chuẩn xác để thanh lực lên tới Đỉnh Đỏ (100%)
                                        clickGui(btn)
                                        task.wait(1)
                                        isHitting = false
                                    
                                    -- Xử lý nút tát thường
                                    elseif txt == "SLAP" then
                                        clickGui(btn)
                                        task.wait(0.1)
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
        AutoFullHitBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: TẮT"
        StatusText.Text = "Đã dừng Auto Tát."
    end
end)

-- ==========================================
-- 3. BẺ KHOÁ CAM BẰNG METATABLE (VƯỢT MỌI ANTICHEAT)
-- ==========================================
local unlockCam = false
-- Can thiệp vào nhân của Game để chặn lệnh khóa Camera
local mt = getrawmetatable(game)
if mt and setreadonly then
    local oldNewIndex = mt.__newindex
    setreadonly(mt, false)
    mt.__newindex = newcclosure(function(t, k, v)
        if unlockCam and t == camera and (k == "CFrame" or k == "CameraType") then
            -- Bỏ qua lệnh của game, giữ cho camera được tự do
            return
        end
        return oldNewIndex(t, k, v)
    end)
    setreadonly(mt, true)
end

UnlockCamBtn.MouseButton1Click:Connect(function()
    unlockCam = not unlockCam
    if unlockCam then
        UnlockCamBtn.Text = "🔓 MỞ KHOÁ CAM (NHÌN RA SAU): BẬT"
        StatusText.Text = "Đã phá vỡ hệ thống Camera. Xoay tự do!"
        camera.CameraType = Enum.CameraType.Custom
    else
        UnlockCamBtn.Text = "🔓 MỞ KHOÁ CAM (NHÌN RA SAU): TẮT"
        StatusText.Text = "Đã trả lại quyền điều khiển Camera cho game."
    end
end)

HideBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
