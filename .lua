-- Services
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

-- ตั้งค่า
local enableConsoleNotifications = false
local webhookUrl = 'ใส่คีตรงนี้'

-- ฟังก์ชัน console
local function consoleNotification(msg)
    if enableConsoleNotifications then
        print(msg)
    end
end

-- ฟังก์ชันตรวจ executor
local function getExecutorName()
    if syn then return "Synapse X"
    elseif secure_load and is_protosmasher_caller then return "ProtoSmasher"
    elseif fluxus then return "Fluxus"
    elseif getexecutorname then return getexecutorname()
    elseif KRNL_LOADED then return "KRNL"
    elseif pebc_execute then return "Script-Ware"
    elseif Cryptic then return "Cryptic"
    elseif Trigon then return "Trigon"
    elseif VegaX then return "Vega X"
    elseif Codex then return "Codex"
    elseif ArceusX then return "Arceus X"
    elseif DELTA then return "DELTA"
    elseif illusion then return "Illusion"
    elseif Cubix then return "Cubix"
    elseif Nebula then return "Nebula"
    elseif Subzero then return "Subzero (FLUXUS REBRANDED)"
    elseif Evon then return "Evon"
    elseif ReveliX then return "ReveliX"
    elseif RIFT then return "RIFT"
    elseif Alysse then return "Alysse"
    else return "Unknown Executor"
    end
end

-- ฟังก์ชันส่ง HTTP
local function safeHttpRequest(data)
    local success, result = pcall(function()
        return http and http.request(data)
    end)
    if not success then
        warn("HTTP Request ล้มเหลว: ", result)
    end
    return success
end

-- ฟังก์ชันส่ง embed แรก (ชื่อเกม)
local function sendInitEmbed(placeName)
    local embed = {
        title = "เริ่มต้นการบันทึกข้อความบน " .. placeName .. " ที่ " .. os.date("%m/%d/%y ที่เวลา %X"),
        description = "🔥🎮 ขอต้อนรับเข้าสู่ระบบบันทึกข้อมูล 🚀🌟\n**ประเภทสคริปต์: พรีเมี่ยม (Premium)**"
    }

    safeHttpRequest({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({
            embeds = {embed},
            content = ""
        })
    })
end

-- ฟังก์ชันส่งข้อมูลผู้เล่น
local function logPlayerInfo(player)
    local display = player.DisplayName
    local username = player.Name
    local userid = player.UserId
    local age = player.AccountAge
    local ping = math.floor(player:GetNetworkPing() * 1000)
    local executor = getExecutorName()

    local message = {
        description = 
            "🎮 ชื่อเล่น (DisplayName): **" .. display .. "**" ..
            "\n🧑‍💻 ชื่อจริง (Username): **" .. username .. "**" ..
            "\n🆔 User ID: **" .. userid .. "**" ..
            "\n👴 อายุบัญชี: **" .. age .. " วัน**" ..
            "\n📡 Ping: **" .. ping .. " ms**" ..
            "\n🖥️ Executor: **" .. executor .. "**" ..
            "\n💎 ประเภทสคริปต์: **พรีเมี่ยม (Premium)**",
        footer = { text = "⏰ เวลา: " .. os.date("%m/%d/%y ที่เวลา %X") }
    }

    safeHttpRequest({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode({
            embeds = {message},
            content = ""
        })
    })

    consoleNotification("✅ ส่งข้อมูลผู้เล่น: " .. display)
end

-- เริ่มต้นระบบ
local success, placeInfo = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
if success and placeInfo and placeInfo.Name then
    sendInitEmbed(placeInfo.Name)
end

-- ส่งข้อมูลผู้เล่น
if Players.LocalPlayer then
    logPlayerInfo(Players.LocalPlayer)
else
    warn("ไม่พบ Players.LocalPlayer")
end
