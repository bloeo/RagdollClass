--[[ Variables ]]--

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

-- require RagdollClass
local RagdollClass = require(ReplicatedStorage:WaitForChild("RagdollClass"));

-- Create the RemoteEvent, so that the clients can communicate to us when they want the ragdoll
local ragdollRemote = Instance.new("RemoteEvent");
ragdollRemote.Name = "RagdollRemote";
ragdollRemote.Parent = ReplicatedStorage;

-- Other Variables
local ragdollPlayerMotors = {};

--[[ Functions ]]--

local function onServerEvent(ragdollPlayer, enabled, ...)
	-- This is not very secure, in an actual game please secure it.
	-- We are pretty much a "middle-man" where a client sends a request to the server, server disables/enables motors to prevent replication, 
	-- then the servers sends a request to all the other clients.
	if enabled then
		ragdollPlayerMotors[ragdollPlayer] = RagdollClass.DisableMotors(ragdollPlayer.Character);
	else
		local motors = ragdollPlayerMotors[ragdollPlayer];
		if motors then
			for _, motor in pairs(motors) do
				motor.Enabled = true;
			end;
			ragdollPlayerMotors[ragdollPlayer] = nil;
		end;
	end;
	ragdollRemote:FireAllClients(ragdollPlayer, enabled, ...);
end;

local function onPlayerRemoving(player)
	local motors = ragdollPlayerMotors[player];
	if not motors then
		return;
	end;
	ragdollPlayerMotors[player] = nil;
end;

--[[ Connections ]]--

ragdollRemote.OnServerEvent:Connect(onServerEvent);
Players.PlayerRemoving:Connect(onPlayerRemoving);