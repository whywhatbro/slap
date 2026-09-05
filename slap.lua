-- ==========================================================
-- 👑 SLAP HUB V16 - HOÀN CHỈNH CHO MOBILE 👑
-- ==========================================================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. DỌN DẸP GIAO DIỆN CŨ
local function getSafeParent()
    local ok, res = pcall(function() return gethui() end)
    if ok and res then return res end
    local ok2, res2 = pcall(function() return CoreGui end)
    if ok2 and res2 then return res2 end
    return playerGui
end

local parentGui = getSafeParent()
if parentGui:FindFirstChild("FindWhoSlappedV16") then
    parentGui.FindWhoSlappedV16:Destroy()
end

-- 2. TẠO GIAO DIỆN HUB V16
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindWhoSlappedV16"
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
Title.Text = "👑 SLAP HUB V16 (MOBILE FIX)"
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

local AutoSlapBtn = createBtn("🎯 AUTO TÁT (NATIVE API): TẮT", 50, Color3.fromRGB(180, 40, 40))
local ShowSlapperBtn = createBtn("👁️ HIỆN ẢNH NGƯỜI TÁT: TẮT", 100, Color3.fromRGB(120, 40, 180))
local AutoCocoBtn = createBtn("🥥 AUTO NHẶT DỪA (VIỀN TRẮNG): TẮT", 150, Color3.fromRGB(0, 140, 80))
local EspPlayerBtn = createBtn("👁️ HIỆN XUYÊN TƯỜNG (ESP): TẮT", 200, Color3.fromRGB(40, 120, 180))

-- ==========================================
-- KHUNG HIỂN THỊ AVATAR NGƯỜI TÁT Ở GÓC MÀN HÌNH
-- ==========================================
local SlapperHUD = Instance.new("Frame", ScreenGui)
SlapperHUD.Size = UDim2.new(0, 90, 0, 110)
SlapperHUD.Position = UDim2.new(0.85, 0, 0.05, 0)
SlapperHUD.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SlapperHUD.Visible = false
Instance.new("UICorner", SlapperHUD).CornerRadius = UDim.new(0, 8)
local strokeHUD = Instance.new("UIStroke", SlapperHUD)
strokeHUD.Color = Color3.fromRGB(255, 0, 0)
strokeHUD.Thickness = 2

local HUDTitle = Instance.new("TextLabel", SlapperHUD)
HUDTitle.Size = UDim2.new(1, 0, 0, 25)
HUDTitle.BackgroundTransparency = 1
HUDTitle.Text = "NGƯỜI TÁT"
HUDTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HUDTitle.Font = Enum.Font.GothamBold
HUDTitle.TextSize = 9

local AvatarImage = Instance.new("ImageLabel", SlapperHUD)
AvatarImage.Size = UDim2.new(0, 60, 0, 60)
AvatarImage.Position = UDim2.new(0.5, -30, 0, 28)
AvatarImage.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0) -- Hình tròn vừa phải

local NameLabel = Instance.new("TextLabel", SlapperHUD)
NameLabel.Size = UDim2.new(1, 0, 0, 20)
NameLabel.Position = UDim2.new(0, 0, 0, 90)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = "None"
NameLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
NameLabel.Font = Enum.Font.Gotham
NameLabel.TextSize = 8

-- ==========================================
-- 1. AUTO NHẶT DỪA (Nhận diện viền trắng/vật phẩm)
-- ==========================================
local autoCoco = false
AutoCocoBtn.MouseButton1Click:Connect(function()
    autoCoco = not autoCoco
    if autoCoco then
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (VIỀN TRẮNG): BẬT"
        task.spawn(function()
            while autoCoco do
                pcall(function()
                    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, v in pairs(workspace:GetDescendants()) do
                            if v:IsA("BasePart") and (v.Name:lower():find("coco") or v.Name:lower():find("nut")) then
                                local highlight = v:FindFirstChildOfClass("Highlight") or v:FindFirstChild("SelectionBox")
                                if highlight or v.Transparency < 1 then
                                    v.CFrame = root.CFrame
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    else
        AutoCocoBtn.Text = "🥥 AUTO NHẶT DỪA (VIỀN TRẮNG): TẮT"
    end
end)

-- ==========================================
-- 2. AUTO TÁT (An toàn cho di động, không mất nút ảo)
-- ==========================================
local autoSlap = false
AutoSlapBtn.MouseButton1Click:Connect(function()
    autoSlap = not autoSlap
    if autoSlap then
        AutoSlapBtn.Text = "🎯 AUTO TÁT (NATIVE API): BẬT"
        task.spawn(function()
            while autoSlap do
                pcall(function()
                    for _, gui in pairs(playerGui:GetDescendants()) do
                        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui.Visible then
                            local txt = string.upper(gui.Name)
                            if gui:FindFirstChildOfClass("TextLabel") then
                                txt = txt .. " " .. string.upper(gui:FindFirstChildOfClass("TextLabel").Text)
                            end
                            if txt:find("SLAP") or txt:find("HIT") then
                                for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                                    connection:Fire()
                                end
                            end
                        end
                    end
                end)
                task.wait(0.2)
            end
        end)
    else
        AutoSlapBtn.Text = "🎯 AUTO TÁT (NATIVE API): TẮT"
    end
end)

-- ==========================================
-- 3. HIỆN ẢNH NGƯỜI TÁT BẠN
-- ==========================================
local showSlapper = false
ShowSlapperBtn.MouseButton1Click:Connect(function()
    showSlapper = not showSlapper
    if showSlapper then
        ShowSlapperBtn.Text = "👁️ HIỆN ẢNH NGƯỜI TÁT: BẬT"
        SlapperHUD.Visible = true
        
        -- Lắng nghe sự kiện giảm máu hoặc tương tác tát từ người chơi khác
        task.spawn(function()
            local char = player.Character or player.CharacterAdded:Wait()
            local humanoid = char:WaitForChild("Humanoid")
            local lastHealth = humanoid.Health

            humanoid.HealthChanged:Connect(function(health)
                if showSlapper and health < lastHealth then
                    -- Tìm người chơi ở gần nhất hoặc vừa tương tác để hiển thị Avatar
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (p.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                            if dist < 15 then -- Khoảng cách tát trực tiếp
                                local thumbType = Enum.ThumbnailType.HeadShot
                                local thumbSize = Enum.ThumbnailSize.Size150x150
                                local content, isReady = Players:GetUserThumbnailAsync(p.UserId, thumbType, thumbSize)
                                if isReady then
                                    AvatarImage.Image = content
                                    NameLabel.Text = p.Name
                                end
                                break
                            end
                        end
                    end
                end
                lastHealth = health
            end)
        end)
    else
        ShowSlapperBtn.Text = "👁️ HIỆN ẢNH NGƯỜI TÁT: TẮT"
        SlapperHUD.Visible = false
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
        task.spawn(function()
            while espEnabled do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and not p.Character:FindFirstChild("SlapESP") then
                            local hl = Instance.new("Highlight")
                            hl.Name = "SlapESP"
                            hl.FillColor = Color3.fromRGB(255, 0, 0)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.5
                            hl.Parent = p.Character
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
