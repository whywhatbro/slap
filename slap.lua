-- ==========================================================
-- 👑 FIND WHO SLAPPED - ULTIMATE HUB V15 (FIXED) 👑
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

-- 1. DỌN DẸP GIAO DIỆN CŨ
local function getSafeParent()
    local ok, res = pcall(function() return gethui() end)
    if ok and res then return res end
    local ok2, res2 = pcall(function() return CoreGui end)
    if ok2 and res2 then return res2 end
    return playerGui
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild("FindWhoSlappedV15") then
    parentGui.FindWhoSlappedV15:Destroy()
end

-- 2. TẠO GIAO DIỆN HUB V15
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV15"
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
Title.Text = "👑 SLAP HUB V15 (ĐÃ SỬA LỖI)"
Title.TextColor3 = Color3.fromRGB(255, 215, 0)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13

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

local AutoSlapBtn = createBtn("🎯 AUTO TÁT & CĂN FULL LỰC: TẮT", 50, Color3.fromRGB(180, 40, 40))
local UnlockCamBtn= createBtn("🔓 MỞ KHÓA CAM 360 (TỰ DO XOAY): TẮT", 100, Color3.fromRGB(120, 40, 180))
local AutoCocoBtn = createBtn("🥥 AUTO NHẶT DỪA: TẮT", 150, Color3.fromRGB(0, 140, 80))
local EspPlayerBtn= createBtn("👁️ HIỆN XUYÊN TƯỜNG (ESP): TẮT", 200, Color3.fromRGB(40, 120, 180))

-- HÀM MÔ PHỎNG CLICK CHUẨN XÁC DÀNH CHO MOBILE
local function forceClickUI(guiObj)
    if not guiObj then return end
    pcall(function()
        local inset = GuiService:GetGuiInset()
        local absPos = guiObj.AbsolutePosition
        local absSize = guiObj.AbsoluteSize
        local clickX = absPos.X + (absSize.X / 2)
        local clickY = absPos.Y + (absSize.Y / 2) + inset.Y
        
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, game, 1)
    end)
end

-- ==========================================
-- 1. SỬA LỖI AUTO TÁT & CĂN LỰC
-- (Quét đệ quy toàn bộ UI để tìm nút bất kể cấu trúc)
-- ==========================================
local autoSlap = false
AutoSlapBtn.MouseButton1Click:Connect(function()
    autoSlap = not autoSlap
    if autoSlap then
        AutoSlapBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: BẬT"
        task.spawn(function()
            while autoSlap do
                pcall(function()
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("ImageLabel")) and gui.Visible then
                            local textToCheck = ""
                            if gui:IsA("TextLabel") or gui:IsA("TextButton") then
                                textToCheck = string.upper(gui.Text)
                            elseif gui:IsA("ImageLabel") and gui:FindFirstChildOfClass("TextLabel") then
                                textToCheck = string.upper(gui:FindFirstChildOfClass("TextLabel").Text)
                            end

                            if string.find(textToCheck, "SLAP") or textToCheck == "10" or textToCheck == "9" then
                                -- Bấm nút SLAP ngay lập tức khi đến lượt
                                forceClickUI(gui:IsA("GuiButton") and gui or gui.Parent)
                            elseif string.find(textToCheck, "!HIT!") then
                                -- Đợi 0.6 giây để thanh lực chạy lên mức xanh lá/đỏ (Max Damage) rồi mới click
                                task.wait(0.6)
                                forceClickUI(gui:IsA("GuiButton") and gui or gui.Parent)
                                task.wait(1) -- Tránh spam click sau khi đã đánh
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    else
        AutoSlapBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: TẮT"
    end
end)

-- ==========================================
-- 2. SỬA LỖI CAMERA (Ép góc nhìn tự do liên tục)
-- ==========================================
local unlockCam = false
local camConnection = nil

UnlockCamBtn.MouseButton1Click:Connect(function()
    unlockCam = not unlockCam
    if unlockCam then
        UnlockCamBtn.Text = "🔓 MỞ KHÓA CAM 360: BẬT"
        -- Sử dụng RenderStepped để liên tục chống lại lệnh khóa Camera của Game
        camConnection = RunService.RenderStepped:Connect(function()
            if camera.CameraType ~= Enum.CameraType.Custom then
                camera.CameraType = Enum.CameraType.Custom
                camera.CameraSubject = player.Character:FindFirstChild("Humanoid")
            end
            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = 100
        end)
    else
        UnlockCamBtn.Text = "🔓 MỞ KHÓA CAM 360 (TỰ DO XOAY): TẮT"
        if camConnection then
            camConnection:Disconnect()
            camConnection = nil
        end
    end
end)

-- ==========================================
-- 3. AUTO NHẶT DỪA (Tối ưu hóa)
-- ==========================================
local autoCoco = false
AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA: BẬT"
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("BasePart") and (v.Name:lower():find("coco") or v.Name:lower():find("nut")) then
                                v.CanCollide = false
                                v.CFrame = root.CFrame
                            end
                        end
                    end
                end)
                task.wait(1)
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA: TẮT"
    end
end)

-- ==========================================
-- 4. ESP HIGHLIGHT NGƯỜI CHƠI (Giữ nguyên - Hoạt động tốt)
-- ==========================================
local espEnabled = false
EspPlayerBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        EspPlayerBtn.Text = "👁️ HIỆN XUYÊN TƯỜNG (ESP): BẬT"
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
                                hl.FillTransparency = 0.5
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
