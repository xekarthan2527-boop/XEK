-- ================= ตั้งค่าของพี่ =================
local VERIFY_URL = "https://discord-bot-x7k1.onrender.com/verify"
local GETSCRIPT_BASE = "https://discord-bot-x7k1.onrender.com/getscript"
local LOADER_URL = "https://raw.githubusercontent.com/xekarthan2527-boop/XEK/refs/heads/main/UI-ScriptRoblox99" -- ลิงค์ไฟล์นี้แหละครับ
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

-- ลบเก่าทิ้งก่อน
pcall(function() if CoreGui:FindFirstChild(UI_NAME) then CoreGui[UI_NAME]:Destroy() end end)
pcall(function() if Hui:FindFirstChild(UI_NAME) then Hui[UI_NAME]:Destroy() end end)

-- ================= ฟังก์ชันหลัก =================
local function getHWID() local id = "" pcall(function() id = game:GetService("RbxAnalyticsService"):GetClientId() end) return id end

local function checkKey(k, h)
    local ok, res = pcall(function() return game:HttpGet(VERIFY_URL.."?key="..HttpService:UrlEncode(k).."&hwid="..HttpService:UrlEncode(h)) end)
    if not ok then return false, {} end
    local decOk, data = pcall(function() return HttpService:JSONDecode(res) end)
    return decOk and data and data.valid == true, decOk and data or {}
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
    -- ถ้าหมดอายุแล้วลบทิ้ง
    if state.expireAt and tick() > state.expireAt then
        pcall(function() if isfile and delfile then delfile(STATE_FILE) delfile(KEY_FILE) end end)
        return nil
    end
    return state
end

local function clearAllData()
    pcall(function() getgenv().MyKey = nil getgenv().KeyExpire = nil getgenv().XEK_Loaded = nil getgenv().XEK_MainRunning = nil end)
    pcall(function() if isfile and delfile then delfile(KEY_FILE) delfile(STATE_FILE) end end)
    pcall(function() if Hui:FindFirstChild(UI_NAME) then Hui[UI_NAME]:Destroy() end end)
end

local function stopMainScript()
    clearAllData()
    pcall(function() for _, v in pairs(Hui:GetChildren()) do if v.Name == MAIN_UI_NAME then v:Destroy() end end end)
end

-- รีโหลดอัตโนมัติตอนเปลี่ยนเซิร์ฟ
local qot = queue_on_teleport or queueonteleport or (syn and syn.queue_on_teleport)
if qot then qot('task.wait(2) loadstring(game:HttpGet("'..LOADER_URL..'"))()') end

-- โหลดข้อมูลเดิม
local hwid = getHWID()
local savedKey = getgenv().MyKey
local savedState = loadSavedState()

if not savedKey then
    if savedState and savedState.key then savedKey = savedState.key
    elseif isfile and isfile(KEY_FILE) then pcall(function() savedKey = readfile(KEY_FILE) end) end
end

-- ================= สร้าง UI =================
local gui = Instance.new("ScreenGui")
gui.Name = UI_NAME
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = Hui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 250)
frame.Position = UDim2.new(0.5, -170, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(15,15,20)
frame.BorderSizePixel = 0
frame.CornerRadius = UDim.new(0,14)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local stroke = Instance.new("UICorner")
stroke.CornerRadius = UDim.new(0,14)
stroke.Parent = frame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(25,25,35)
topBar.CornerRadius = UDim.new(0,14)
topBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ScriptRoblox99"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 30, 0, 28)
btnClose.Position = UDim2.new(1, -35, 0, 5)
btnClose.BackgroundColor3 = Color3.fromRGB(45,45,55)
btnClose.Text = "-"
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 20
btnClose.TextColor3 = Color3.fromRGB(255,255,255)
btnClose.CornerRadius = UDim.new(0,8)
btnClose.Parent = topBar

local body = Instance.new("Frame")
body.Size = UDim2.new(1, 0, 1, -45)
body.Position = UDim2.new(0, 0, 0, 45)
body.BackgroundTransparency = 1
body.Parent = frame

local infoBox = Instance.new("Frame")
infoBox.Size = UDim2.new(0.88, 0, 0, 62)
infoBox.Position = UDim2.new(0.06, 0, 0.05, 0)
infoBox.BackgroundColor3 = Color3.fromRGB(25,25,35)
infoBox.CornerRadius = UDim.new(0,10)
infoBox.Parent = body

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, 0)
infoText.Position = UDim2.new(0, 10, 0, 5)
infoText.BackgroundTransparency = 1
infoText.Text = "ใส่คีย์เพื่อใช้งาน\nคีย์จะจำอัตโนมัติ ไม่ต้องใส่ใหม่"
infoText.Font = Enum.Font.Gotham
infoText.TextSize = 13
infoText.TextColor3 = Color3.fromRGB(220,220,220)
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = infoBox

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.88, 0, 0, 38)
keyBox.Position = UDim2.new(0.06, 0, 0.42, 0)
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
keyBox.PlaceholderText = "วางคีย์ ScriptRoblox99_... ที่นี่"
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 13
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.CornerRadius = UDim.new(0,8)
keyBox.PlaceholderColor3 = Color3.fromRGB(120,120,120)
key.Parent = body

local btnCheck = Instance.new("TextButton")
btnCheck.Size = UDim2.new(0.88, 0, 0, 40)
btnCheck.Position = UDim2.new(0.06, 0, 0.65, 0)
btnCheck.BackgroundColor3 = Color3.fromRGB(0,120,255)
btnCheck.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
btnCheck.Font = Enum.Font.GothamBold
btnCheck.TextSize = 15
btnCheck.TextColor3 = Color3.fromRGB(255,255,255)
btnCheck.CornerRadius = UDim.new(0,10)
btnCheck.Parent = body

local btnDiscord = Instance.new("TextButton")
btnDiscord.Size = UDim2.new(0.88, 0, 0, 32)
btnDiscord.Position = UDim2.new(0.06, 0, 0.87, 0)
btnDiscord.BackgroundColor3 = Color3.fromRGB(40,40,50)
btnDiscord.Text = "🔑 เข้า Discord ขอคีย์"
btnDiscord.Font = Enum.Font.Gotham
btnDiscord.TextSize = 12
btnDiscord.TextColor3 = Color3.fromRGB(200,200,200)
btnDiscord.CornerRadius = UDim.new(0,8)
btnDiscord.Parent = body

local circleTimer = Instance.new("Frame")
circleTimer.Size = UDim2.new(0,65,0,65)
circleTimer.Position = UDim2.new(1,-80,0,20)
circleTimer.BackgroundColor3 = Color3.fromRGB(18,18,25)
circleTimer.Visible = false
circleTimer.CornerRadius = UDim.new(1,0)
circleTimer.Parent = gui

local timerStroke = Instance.new("UICorner")
timerStroke.CornerRadius = UDim.new(1,0)
timerStroke.Parent = circleTimer

local timerText = Instance.new("TextLabel")
timerText.Size = UDim2.new(1,0,1,0)
timerText.BackgroundTransparency = 1
timerText.Text = "00:00"
timerText.Font = Enum.Font.GothamBold
timerText.TextSize = 14
timerText.TextColor3 = Color3.fromRGB(0,255,170)
timerText.Parent = circleTimer

-- ================= ระบบทำงาน =================
local function startCountdown(sec)
    circleTimer.Visible = true
    frame.Visible = false
    saveState(sec)

    task.spawn(function()
        local total = tonumber(sec) or 0
        while total > 0 and getgenv().MyKey do
            -- เช็คใหม่ทุก 15 วินาทีจากเซิร์ฟ
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
            timerText.Text = string.format("%02d:%02d", m, s)

            -- แดงเมื่อเหลือน้อยกว่า 5 นาที
            if total < 300 then
                timerText.TextColor3 = Color3.fromRGB(255,70,70)
            else
                timerText.TextColor3 = Color3.fromRGB(0,255,170)
            end

            task.wait(1)
            total -= 1
        end

        -- หมดเวลา
        clearAllData()
        circleTimer.Visible = false
        frame.Visible = true
        btnCheck.Text = "✨ คีย์หมดอายุ กรุณาใส่ใหม่"
        keyBox.Text = ""
    end)
end

local function loadMainScript(key)
    if getgenv().XEK_MainRunning then return end
    getgenv().XEK_MainRunning = true

    task.delay(1.5, function()
        local url = GETSCRIPT_BASE.."?key="..HttpService:UrlEncode(key).."&placeId="..game.PlaceId.."&hwid="..HttpService:UrlEncode(hwid)
        local getOk, code = pcall(function() return game:HttpGet(url) end)

        if getOk and code and not code:find("Invalid") and not code:find("not found") and not code:find("HWID mismatch") then
            pcall(function() loadstring(code)() end)
            -- ปิดหน้านี้เมื่อโหลดสำเร็จ
            task.delay(3, function() pcall(function() gui:Destroy() end) end)
        else
            infoText.Text = "❌ โหลดสคริปต์ไม่ได้\nรอสักครู่แล้วลองใหม่อีกครั้ง"
            getgenv().XEK_MainRunning = nil
            frame.Visible = true
            circleTimer.Visible = false
        end
    end)
end

-- ถ้ามีข้อมูลเดิมอยู่แล้ว ทำงานทันที
if savedKey and savedKey ~= "" then
    keyBox.Text = savedKey
    infoText.Text = "🔍 ตรวจสอบคีย์เดิม..."
    btnCheck.Text = "กำลังตรวจสอบ..."
    frame.Active = false

    local ok, data = checkKey(savedKey, hwid)
    if ok and data.remaining and data.remaining > 0 then
        getgenv().MyKey = savedKey
        getgenv().XEK_Loaded = true
        startCountdown(data.remaining)
        loadMainScript(savedKey)
    else
        clearAllData()
        infoText.Text = "⚠️ คีย์หมดอายุหรือไม่ถูกต้อง\nกรุณาใส่คีย์ใหม่"
        btnCheck.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
        frame.Active = true
    end
end

-- กดปุ่มตรวจสอบ
btnCheck.MouseButton1Click:Connect(function()
    local inputKey = keyBox.Text:gsub("%s+", "")
    if inputKey == "" then return end

    infoText.Text = "🔍 กำลังตรวจสอบ..."
    btnCheck.Text = "รอสักครู่..."
    frame.Active = false

    local ok, data = checkKey(inputKey, hwid)
    if ok and data.remaining and data.remaining > 0 then
        getgenv().MyKey = inputKey
        getgenv().XEK_Loaded = true
        -- บันทึกลงเครื่อง
        if writefile then
            pcall(function() writefile(KEY_FILE, inputKey) end)
            saveState(data.remaining)
        end
        startCountdown(data.remaining)
        loadMainScript(inputKey)
    else
        infoText.Text = "❌ คีย์ไม่ถูกต้อง/หมดอายุ\nรับคีย์ใหม่ที่ดิสคอร์ด"
        btnCheck.Text = "✨ เช็คคีย์และเริ่มใช้งาน"
        frame.Active = true
    end
end)

-- ปุ่มดิสคอร์ด
btnDiscord.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_INVITE)
    btnDiscord.Text = "✅ คัดลอกลิงค์แล้ว!"
    task.delay(2, function() btnDiscord.Text = "🔑 เข้า Discord ขอคีย์" end)
end)

-- ปิด
btnClose.MouseButton1Click:Connect(clearAllData)

-- เปิดแอนิเมชั่น
frame.Size = UDim2.new(0,0,0,0)
TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,340,0,250)}):Play()
