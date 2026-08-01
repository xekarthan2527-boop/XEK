-- ================= ตั้งค่าของพี่ =================
local VERIFY_URL = "https://discord-bot-x7k1.onrender.com/verify"
local GETSCRIPT_BASE = "https://discord-bot-x7k1.onrender.com/getscript"
local LOADER_URL = "https://raw.githubusercontent.com/xekarthan2527-boop/XEK/refs/heads/main/UI-ScriptRoblox99.lua"
local DISCORD_INVITE = "https://discord.gg/Pm5G3G8b7u"

local UI_NAME = "ScriptRoblox99_UI"
local MAIN_UI_NAME = "ScriptRoblox99_Main"
local KEY_FILE = "ScriptRoblox99_Key.txt"
local STATE_FILE = "ScriptRoblox99_State.json"

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Hui = gethui and gethui() or CoreGui
local Player = game.Players.LocalPlayer

-- ลบเวอร์ชันเก่าทิ้งก่อน
pcall(function() if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end end)
pcall(function() if Hui:FindFirstChild(UI_NAME) then Hui[UI_NAME]:Destroy() end end)

-- ================= ฟังก์ชันหลัก =================
local function getHWID() local id = "" pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end) return id end

local function checkKey(k, h)
    local encodedKey = HttpService:UrlEncode(k)
    local encodedHwid = HttpService:UrlEncode(h)
    local ok, res = pcall(function() return game:HttpGet(VERIFY_URL.."?key="..encodedKey.."&hwid="..encodedHwid) end)
    if not ok then return false, {} end
    local decOk, data = pcall(function() return HttpService:JSONDecode(res) end)
    return decOk and data and data.valid == true or false, decOk and data or {}
end

local function saveState(remainingSec)
    if not writefile then return end
    local state = {
        key = getgenv().MyKey or "",
        expireAt = tick() + tonumber(remainingSec or 0),
        lastCheck = tick()
    }
    pcall(function() writefile(STATE_FILE, HttpService:JSONEncode(state)) end)
end

local function loadSavedState()
    if not readfile or not isfile or not isfile(STATE_FILE) then return nil end
    local ok, state = pcall(function() return HttpService:JSONDecode(readfile(STATE_FILE)) end)
    if not ok or type(state) ~= "table" or not state.key then return nil end
    -- ลบถ้าหมดอายุแล้ว
    if state.expireAt and tick() > state.expireAt then
        pcall(function() if isfile and delfile then delfile(STATE_FILE) delfile(KEY_FILE) end end)
        return nil
    end
    return state
end

local function stopMain()
    pcall(function() getgenv().MyKey = nil getgenv().KeyExpire = nil getgenv().XEK_Loaded = nil getgenv().XEK_MainRunning = nil end)
    pcall(function() if isfile and delfile then delfile(KEY_FILE) delfile(STATE_FILE) end end)
    pcall(function() CoreGui:FindFirstChild(MAIN_UI_NAME):Destroy() end)
    pcall(function() Hui:FindFirstChild(MAIN_UI_NAME):Destroy() end)
end

-- รีโหลดอัตโนมัติตอนย้ายเซิร์ฟ
local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
if qot then qot('task.wait(2) loadstring(game:HttpGet("'..LOADER_URL.."))()'") end

-- โหลดข้อมูลเดิม
local hwid = getHWID()
local savedKey = getgenv().MyKey
local savedState = loadSavedState()

if not savedKey then
    if savedState and savedState.key then savedKey = savedState.key
    elseif isfile and isfile(KEY_FILE) then pcall(function() savedKey = readfile(KEY_FILE) end) end
end

-- ================= สร้าง UI รูปแบบเดิมทุกประการ =================
local gui = Instance.new("ScreenGui")
gui.Name = UI_NAME
gui.ResetOnSpawn = false
gui.Parent = Hui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,340,0,250)
frame.Position = UDim2.new(0.5,-170,0.5,-125)
frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
frame.BorderSizePixel = 0
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)
local stroke = Instance.new("UIStroke",frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,170,255)

local top = Instance.new("Frame")
top.Parent = frame
top.Size = UDim2.new(1,0,0,38)
top.BackgroundColor3 = Color3.fromRGB(25,25,35)
top.BorderSizePixel = 0
Instance.new("UICorner",top).CornerRadius = UDim.new(0,14)

local title = Instance.new("TextLabel",top)
title.Size = UDim2.new(1,-110,1,0)
title.Position = UDim2.new(0,12,0,0)
title.BackgroundTransparency = 1
title.Text = "⚡ ScriptRoblox99"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton",top)
minimize.Size = UDim2.new(0,30,0,28)
minimize.Position = UDim2.new(1,-35,0,5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.BackgroundColor3 = Color3.fromRGB(45,45,55)
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner",minimize)

-- ส่วนเนื้อหา
local body = Instance.new("Frame",frame)
body.Position = UDim2.new(0,0,0,45)
body.Size = UDim2.new(1,0,1,-45)
body.BackgroundTransparency = 1

local infoBox = Instance.new("Frame",body)
infoBox.Size = UDim2.new(0.88,0,0,62)
infoBox.Position = UDim2.new(0.06,0,0.05,0)
infoBox.BackgroundColor3 = Color3.fromRGB(10,10,15)
Instance.new("UICorner",infoBox).CornerRadius = UDim.new(0,10)
local infoStroke = Instance.new("UIStroke",infoBox)
infoStroke.Color = Color3.fromRGB(0,170,255)
infoStroke.Thickness = 1.2

local infoText = Instance.new("TextLabel",infoBox)
infoText.Size = UDim2.new(1,-20,1,-10)
infoText.Position = UDim2.new(0,10,0,5)
infoText.BackgroundTransparency = 1
infoText.Text = "ใส่คีย์เพื่อใช้งาน\nคีย์จะจำอัตโนมัติ ไม่ต้องใส่ใหม่"
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextColor3 = Color3.fromRGB(220,220,220)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top

local keyBox = Instance.new("TextBox",body)
keyBox.Size = UDim2.new(0.88,0,0,38)
keyBox.Position = UDim2.new(0.06,0,0.38,0)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,35)
keyBox.PlaceholderText = "วางคีย์ ScriptRoblox99_... ที่นี่"
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
Instance.new("UICorner",keyBox).CornerRadius = UDim.new(0,8)

local checkBtn = Instance.new("TextButton",body)
checkBtn.Size = UDim2.new(0.88,0,0,40)
checkBtn.Position = UDim2.new(0.06,0,0.6,0)
checkBtn.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
checkBtn.Font = Enum.Font.GothamBold
checkBtn.TextSize = 15
checkBtn.TextColor3 = Color3.new(1,1,1)
checkBtn.BackgroundColor3 = Color3.fromRGB(0,140,255)
Instance.new("UICorner",checkBtn).CornerRadius = UDim.new(0,10)

local discordBtn = Instance.new("TextButton",body)
discordBtn.Size = UDim2.new(0.88,0,0,32)
discordBtn.Position = UDim2.new(0.06,0,0.82,0)
discordBtn.Text = "🔑 ขอรหัสฟรี / ก๊อปปี้ดิสคอร์ด"
discordBtn.Font = Enum.Font.Gotham
discordBtn.TextSize = 12
discordBtn.TextColor3 = Color3.fromRGB(200,200,200)
discordBtn.BackgroundColor3 = Color3.fromRGB(40,40,50)
Instance.new("UICorner",discordBtn).CornerRadius = UDim.new(0,8)

-- นาฬิกานับเวลา
local Circle = Instance.new("Frame",gui)
Circle.Name = "TimerCircle"
Circle.Size = UDim2.new(0,65,0,65)
Circle.Position = UDim2.new(1,-80,0,20)
Circle.BackgroundColor3 = Color3.fromRGB(18,18,22)
Circle.Visible = false
Instance.new("UICorner",Circle).CornerRadius = UDim.new(1,0)
local CircleStroke = Instance.new("UIStroke",Circle)
CircleStroke.Color = Color3.fromRGB(0,255,170)
CircleStroke.Thickness = 3
local CircleText = Instance.new("TextLabel",Circle)
CircleText.Size = UDim2.new(1,0,1,0)
CircleText.BackgroundTransparency = 1
CircleText.Text = "00:00"
CircleText.TextColor3 = Color3.new(1,1,1)
CircleText.TextSize = 14
CircleText.Font = Enum.Font.GothamBold

-- ================= ระบบทำงาน =================
local function startCountdown(sec)
    Circle.Visible = true
    frame.Visible = false
    saveState(sec)

    task.spawn(function()
        local total = tonumber(sec) or 0
        while total > 0 and getgenv().MyKey do
            -- เช็คกับเซิร์ฟเวอร์ทุก 15 วินาที
            if total % 15 == 0 then
                local ok, data = checkKey(getgenv().MyKey, hwid)
                if ok and data.remaining and data.remaining > 0 then
                    total = data.remaining
                    saveState(total)
                else
                    break
                end
            end

            local m = math.floor(total / 60)
            local s = total % 60
            CircleText.Text = string.format("%02d:%02d", m, s)

            if total < 300 then
                CircleStroke.Color = Color3.fromRGB(255,80,80)
                CircleText.TextColor3 = Color3.fromRGB(255,80,80)
            else
                CircleStroke.Color = Color3.fromRGB(0,255,170)
                CircleText.TextColor3 = Color3.fromRGB(0,255,170)
            end

            task.wait(1)
            total -= 1
        end

        -- หมดเวลา
        stopMain()
        Circle.Visible = false
        frame.Visible = true
        checkBtn.Text = "✨ คีย์หมดอายุ กรุณาใส่ใหม่"
        keyBox.Text = ""
    end)
end

local function loadGame(key)
    if getgenv().XEK_MainRunning then return end
    getgenv().XEK_MainRunning = true

    -- รอโหลดฉากเสร็จก่อน
    task.delay(2, function()
        local url = GETSCRIPT_BASE.."?key="..HttpService:UrlEncode(key).."&placeId="..game.PlaceId.."&hwid="..HttpService:UrlEncode(hwid)
        local ok, code = pcall(function() return game:HttpGet(url) end)

        if ok and code and not code:find("Invalid") and not code:find("not found") and not code:find("HWID mismatch") then
            pcall(function() loadstring(code)() end)
            -- ปิดหน้านี้เมื่อสำเร็จ
            task.delay(4, function() pcall(function() gui:Destroy() end) end)
        else
            infoText.Text = "❌ โหลดไม่ได้\nเกมยังไม่รองรับ หรือเซิร์ฟมีปัญหา"
            getgenv().XEK_MainRunning = nil
            Circle.Visible = false
            frame.Visible = true
        end
    end)
end

-- เช็คคีย์เดิมโดยอัตโนมัติ
if savedKey and savedKey ~= "" then
    keyBox.Text = savedKey
    infoText.Text = "🔍 ตรวจสอบคีย์เดิมกับเซิร์ฟเวอร์..."
    checkBtn.Text = "กำลังตรวจสอบ..."
    frame.Active = false

    local ok, data = checkKey(savedKey, hwid)
    if ok and data.remaining and data.remaining > 0 then
        getgenv().MyKey = savedKey
        getgenv().XEK_Loaded = true
        startCountdown(data.remaining)
        loadGame(savedKey)
    else
        stopMain()
        infoText.Text = "⚠️ คีย์หมดอายุหรือไม่ถูกต้อง\nกรุณาใส่คีย์ใหม่"
        checkBtn.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
        frame.Active = true
    end
end

-- กดยืนยันคีย์
checkBtn.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text:gsub("%s+", "")
    if inputKey == "" then return end

    infoText.Text = "🔍 ส่งตรวจสอบไปที่เซิร์ฟเวอร์..."
    checkBtn.Text = "รอสักครู่..."
    frame.Active = false

    local ok, data = checkKey(inputKey, hwid)
    if ok and data.remaining and data.remaining > 0 then
        getgenv().MyKey = inputKey
        getgenv().XEK_Loaded = true
        if writefile then
            pcall(function() writefile(KEY_FILE, inputKey) end)
            saveState(data.remaining)
        end
        startCountdown(data.remaining)
        loadGame(inputKey)
    else
        infoText.Text = "❌ คีย์ไม่ถูกต้อง/หมดอายุ\nรับคีย์ใหม่ที่ดิสคอร์ด"
        checkBtn.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
        frame.Active = true
    end
end)

discordBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    discordBtn.Text = "✅ คัดลอกลิงค์แล้ว!"
    task.delay(2, function() discordBtn.Text = "🔑 ขอรหัสฟรี / ก๊อปปี้ดิสคอร์ด" end)
end)

-- ลากย่อขยาย
local open = true
minimize.MouseButton1Click:Connect(function()
    open = not open
    body.Visible = open
    if open then 
        frame:TweenSize(UDim2.new(0,340,0,250), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.35, true) 
        minimize.Text = "-"
    else 
        frame:TweenSize(UDim2.new(0,340,0,38), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.35, true) 
        minimize.Text = "+" 
    end
end)

local dragging, dragStart, startPos
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- แสดงผลด้วยแอนิเมชั่น
frame.Size = UDim2.new(0,0,0,0)
TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(0,340,0,250)}):Play()
