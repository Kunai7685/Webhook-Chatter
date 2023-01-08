local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

url = [[1061549745291677776/8LrZSU-b3n-v96jpvebzS_4p0MU4WAkyjjCpSvnMKxkY3cCJ164gUQqUcLZVlwiTUtNF]]
local cat_profile_generator = "https://api.thecatapi.com/v1/images/search?ref=morioh.com&utm_source=morioh.com"
local random_profile_tables = "https://raw.githubusercontent.com/Kunai7685/Webhook-Chatter/main/Profiles.json"

local ProfileList
do
	local Result = HttpService:JSONDecode(game:HttpGet(random_profile_tables))
	ProfileList = Result.Profiles
end

local MessageRequested = {}

function sendMessage()
	if MessageRequested[1] then
		local msg, player, profileNum = MessageRequested[1].msg,MessageRequested[1].plr,MessageRequested[1].pfp
		local payload = {
			["username"] = player.Name.." (@"..player.DisplayName..")";
			["avatar_url"] = ProfileList[profileNum];
			["content"] = msg;
		}

		local headers = {
			["content-type"] = "application/json"
		}

		local request_body_encoded = HttpService:JSONEncode(payload)
		local request_payload = {Url="https://discord.com/api/webhooks/"..url, Body=request_body_encoded, Method="POST", Headers=headers}
		http_request(request_payload)
		table.remove(MessageRequested, 1)
	end
end

local function PlayerAdded(player)
	local ProfileNum = math.random(1,#ProfileList)
	player.Chatted:Connect(function(message)
		table.insert(MessageRequested, {
			["msg"]=message,
			["plr"]=player, 
			["pfp"]=ProfileNum
		})
	end)
end

Players.PlayerAdded:Connect(PlayerAdded)

for i,v in pairs(Players:GetPlayers()) do
	local ProfileNum = math.random(1,#ProfileList)
	v.Chatted:Connect(function(message)
		local Player = v
		table.insert(MessageRequested, {
			["msg"]=message,
			["plr"]=Player, 
			["pfp"]=ProfileNum
		})
	end)
end

while true do wait(1)
	sendMessage()
end
