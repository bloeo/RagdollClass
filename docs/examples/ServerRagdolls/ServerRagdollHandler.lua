--[[ Variables ]]--

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");

-- Create the RemoteEvent, so that the clients can communicate to us when they want the ragdoll
local ragdollRemote = Instance.new("RemoteEvent");
ragdollRemote.Name = "RagdollRemote";
ragdollRemote.Parent = ReplicatedStorage;

-- Require RagdollClass
local RagdollClass = require(ReplicatedStorage:WaitForChild("RagdollClass"));

-- Other variables
local ragdolls = {};

--[[ Functions ]]--

local function onServerEvent(ragdollPlayer, enabled, seed)
	local ragdoll = ragdolls[ragdollPlayer];
	if enabled then
		-- We check if the ragdoll exists already, which if true probably means they died and got a new character.
		-- If true we destroy that ragdoll, and replace it with a new one.
		if ragdoll then
			ragdoll:Destroy()
		end
		
		ragdoll = RagdollClass.new(ragdollPlayer.Character, seed);
		ragdoll:SetRagdollEnabled(true);
		-- We set the player key in the ragdolls table to be our ragdoll class, so once the client wants to disable their ragdoll state, 
		-- we can find the associated RagdollClass object.
		-- Why we are doing it in a table is because there can be multiple players, so we need to properly handle that.
		ragdolls[ragdollPlayer] = ragdoll;
	else
		if ragdoll then
			-- If we destroy the ragdoll, the actual ragdoll also disables.
			-- We destroy it as we do not want it lying around in the memory forever, say if an user doesn't ragdoll for 20 minutes.
			ragdoll:Destroy();
			ragdolls[ragdollPlayer] = nil;
		end;
	end;
end;

-- If an user leaves when they are ragdolled, we need to destroy their ragdoll to not cause a memory leak.
local function onPlayerRemoving(player)
	local ragdoll = ragdolls[player]
	if ragdoll then
		ragdoll:Destroy()
		ragdolls[player] = nil
	end
end;

--[[ Connections ]]--

ragdollRemote.OnServerEvent:Connect(onServerEvent);
Players.PlayerRemoving:Connect(onPlayerRemoving);