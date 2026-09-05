-- ==========================================================
-- 👑 FIND WHO SLAPPED - ULTIMATE HUB V11 (100% FIXED) 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")

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
if targetParent:FindFirstChild("FindWhoSlappedV11") then
    targetParent.FindWhoSlappedV11:Destroy()
end

-- 2. TẠO MENU NỔI DI ĐỘNG
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV11"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local ToggleBtn = Instance.new("ImageButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleBtn.Image = "rbxassetid://10618928818"
ToggleBtn.Active = true
ToggleBtn.Draggable = true
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", ToggleBtn).Thickness = 2

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 260)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", MainFrame).Thickness = 2

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "👑 SLAP HUB V11 (FIXED)"
Title.TextColor3 = Color3.fromRGB(255, 100, 100)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 13

local StatusText = Instance.new("TextLabel", MainFrame)
StatusText.Size = UDim2.new(1, 0, 0, 20)
StatusText.Position = UDim2.new(0, 0, 0, 32)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Trạng thái: Đã fix lỗi!"
StatusText.TextColor3 = Color3.fromRGB(150, 255, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 10

local function createBtn(text, yPos, color1)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = color1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    return btn
end

local AutoCocoBtn    = createBtn("🥥 AUTO TELEPORT DỪA VÀO NGƯỜI: TẮT", 60, Color3.fromRGB(0, 120, 80))
local AutoFullHitBtn = createBtn("🎯 AUTO TÁT & CĂN FULL LỰC: TẮT", 105, Color3.fromRGB(180, 50, 50))
local UnlockCamBtn   = createBtn("🔓 BẺ KHOÁ CAM (NHÌN ĐƯỢC RA SAU): TẮT", 150, Color3.fromRGB(80, 50, 150))
local HideBtn        = createBtn("❌ ĐÓNG GIAO DIỆN", 205, Color3.fromRGB(80, 80, 80))

-- HÀM GIẢ LẬP CLICK (CHUẨN TỌA ĐỘ GUI INSET)
local function triggerBtn(guiBtn)
    if not guiBtn or not guiBtn.Visible then return end
    pcall(function()
        local inset = GuiService:GetGuiInset()
        local x = guiBtn.AbsolutePosition.X + (guiBtn.AbsoluteSize.X / 2)
        local y = guiBtn.AbsolutePosition.Y + (guiBtn.AbsoluteSize.Y / 2) + inset.Y
        VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.Begin, x, y)
        task.wait(0.05)
        VirtualInputManager:SendTouchEvent(1, Enum.UserInputState.End, x, y)
    end)
end

-- ==========================================
-- 1. AUTO NHẶT DỪA BẰNG CÁCH DỊCH CHUYỂN DỪA
-- ==========================================
local autoCoco = false
AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO TELEPORT DỪA VÀO NGƯỜI: BẬT"
        StatusText.Text = "Đang hút mọi trái dừa trên map..."
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in pairs(workspace:GetDescendants()) do
                            -- Nếu vật thể tên là "Coconut" hoặc có chứa chữ "coco"
                            if v:IsA("BasePart") and (v.Name:lower():find("coco") or v.Name:lower():find("nut")) then
                                -- Dịch chuyển thẳng trái dừa tới vị trí của bạn
                                v.CFrame = root.CFrame
                            end
                        end
                    end
                end)
                task.wait(0.5) -- Lặp lại mỗi nửa giây
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO TELEPORT DỪA VÀO NGƯỜI: TẮT"
        StatusText.Text = "Đã dừng hút dừa."
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
        StatusText.Text = "Đang quét nút Tát và Thanh lực..."
        task.spawn(function()
            while autoHit do
                pcall(function()
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if gui:IsA("TextButton") or gui:IsA("ImageButton") then
                            local txt = gui:IsA("TextButton") and gui.Text:upper() or gui.Name:upper()
                            
                            -- Xử lý nút SLAP (Tát bình thường)
                            if txt == "SLAP" and gui.Visible and gui.AbsoluteSize.X > 0 then
                                triggerBtn(gui)
                                task.wait(0.1)
                            end
                            
                            -- Xử lý nút !HIT! (Thanh căn lực)
                            if (txt:find("!HIT!") or txt:find("HIT")) and gui.Visible and not isHitting then
                                isHitting = true
                                
                                -- ĐỢI THÔNG MINH: Chờ 0.55s - 0.65s để thanh lực chạy lên mức Đỏ/Max rồi mới bấm
                                task.wait(0.6) 
                                triggerBtn(gui)
                                
                                task.wait(1.5) -- Đợi game reset thanh lực
                                isHitting = false
                            end
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        AutoFullHitBtn.Text = "🎯 AUTO TÁT & CĂN FULL LỰC: TẮT"
        StatusText.Text = "Đã dừng Auto Tát."
    end
end)

-- ==========================================
-- 3. BẺ KHOÁ CAMERA (NHÌN ĐƯỢC ĐẰNG SAU)
-- ==========================================
local unlockCam = false
UnlockCamBtn.MouseButton1Click:Connect(function()
    unlockCam = not unlockCam
    if unlockCam then
        UnlockCamBtn.Text = "🔓 BẺ KHOÁ CAM (NHÌN ĐƯỢC RA SAU): BẬT"
        StatusText.Text = "Đã bẻ khoá! Bạn có thể tự do xoay Camera."
        
        -- Dùng BindToRenderStep để giành lại quyền điều khiển Camera từ tay hệ thống Game
        RunService:BindToRenderStep("ForceUnlockCamera", Enum.RenderPriority.Camera.Value + 1, function()
            if camera.CameraType == Enum.CameraType.Scriptable then
                camera.CameraType = Enum.CameraType.Custom
            end
        end)
    else
        UnlockCamBtn.Text = "🔓 BẺ KHOÁ CAM (NHÌN ĐƯỢC RA SAU): TẮT"
        StatusText.Text = "Đã khóa Camera như cũ."
        RunService:UnbindFromRenderStep("ForceUnlockCamera")
    end
end)

HideBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
