--// [WEBHOOK LOGGER]
local webhookUrl = ' '--ใส่คีตรงนี้

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
	elseif Subzero then return "Subzero"
	elseif Evon then return "Evon"
	elseif ReveliX then return "ReveliX"
	elseif RIFT then return "RIFT"
	elseif Alysse then return "Alysse"
	else return "Unknown Executor"
	end
end

local function safeHttpRequest(data)
	return SafePcall(request, data)
end

local function sendInitEmbed(placeName)
	local embed = {
		title = "🔥 DarkAdmin เริ่มทำงาน",
		description = 
			"🎮 **เกม:** `" .. placeName .. "`\n" ..
			"⏰ **เวลา:** `" .. os.date("%m/%d/%Y %X") .. "`\n" ..
			"💻 **เวอร์ชัน:** `v" .. DA.VersionDA .. "`",
		color = 16711680
	}
	SafePcall(function()
		safeHttpRequest({
			Url = webhookUrl,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ embeds = {embed} })
		})
	end)
end

local function logPlayerInfo(plr)
	if not plr then return end
	local ping = "N/A"
	SafePcall(function()
		if typeof(plr.GetNetworkPing) == "function" then
			local netPing = plr:GetNetworkPing()
			if typeof(netPing) == "number" then
				ping = math.floor(netPing * 1000) .. " ms"
			end
		end
	end)

	local embed = {
		title = "👤 ผู้ใช้ DarkAdmin",
		description = 
			"🎮 **Display:** `" .. plr.DisplayName .. "`\n" ..
			"🧑‍💻 **Username:** `" .. plr.Name .. "`\n" ..
			"🆔 **ID:** `" .. tostring(plr.UserId) .. "`\n" ..
			"👴 **อายุ:** `" .. plr.AccountAge .. " วัน`\n" ..
			"📡 **Ping:** `" .. ping .. "`\n" ..
			"🖥️ **Executor:** `" .. getExecutorName() .. "`",
		color = 65280,
		footer = { text = os.date("%m/%d/%Y %X") }
	}
	SafePcall(function()
		safeHttpRequest({
			Url = webhookUrl,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode({ embeds = {embed} })
		})
	end)
end

spawn(function()
	local placeName = "Unknown"
	local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
	if success and info and info.Name then placeName = info.Name end
	task.wait(0.5); sendInitEmbed(placeName)
	task.wait(1); if LocalPlayer then logPlayerInfo(LocalPlayer) end
end)
