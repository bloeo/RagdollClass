--[[ Variables ]]--

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local ContextActionService = game:GetService("ContextActionService");

-- References
local client = Players.LocalPlayer;
local ragdollRemote = ReplicatedStorage:WaitForChild("RagdollRemote");
local currentCamera = workspace.CurrentCamera;

-- require RagdollClass
local RagdollClass = require(ReplicatedStorage:WaitForChild("RagdollClass"));

-- Configurations
local ragdollKeybind = Enum.KeyCode.R;

-- Other variables
local ragdolls = {};
local clientRagdoll;
local head;
local humanoid;
local ragdollEnabled = false;

--[[ Functions ]]--

-- The callback that is gonna be used by ContextActionService, when the user presses the ragdoll keybind.
local function handleAction(_, userInputState)
	-- Check if the userInputState is in the begin state, as we only want the ragdoll toggling when the user initially presses the ragdoll keybind.
	if userInputState == Enum.UserInputState.Begin then
		-- Make the ragdollEnabled variable toggle.
		ragdollEnabled = not ragdollEnabled;

		-- I recommend setting the camera subject to the head when the ragdoll is enabled.
		if head and ragdollEnabled then
			currentCamera.CameraSubject = head;
		elseif humanoid and not ragdollEnabled then
			currentCamera.CameraSubject = humanoid;
		end
		-- We can safely assume that the RagdollClass object exists, as the action can only be binded when the character spawns in, which is when the ragdoll gets created.
		clientRagdoll:SetRagdollEnabled(ragdollEnabled);
		-- Tell the server, "Hey, the ragdoll is in this state!", so that they can replicate that information to other clients, to show that we are in this state.
		-- We also replicate the ragdoll seed, in order to make the random velocity result the same.
		ragdollRemote:FireServer(ragdollEnabled, RagdollClass.Seed);
	end;
end;

-- We need this function to setup the ragdoll when the character spawns, and to remove the ragdoll when they die, to not cause any memory leaks.
-- It's also used to bind the actions.
local function onCharacterAdded(character)
	-- Wait for the humanoid, it's not always available when the character gets added.
	humanoid = character:WaitForChild("Humanoid");
	head = character:FindFirstChild("Head");
	-- Create a new ragdoll class, and set the ragdoll variable to it.
	-- We need to set the ragdoll variable outside of this scope, so that the handleAction function can access it.
	clientRagdoll = RagdollClass.new(character);
	-- Bind the ragdoll action, so that we can detect when the user presses the ragdoll keybind, and then enable/disable the ragdoll.
	ContextActionService:BindAction("Ragdoll", handleAction, true, ragdollKeybind);
	-- Connect to humanoid.Died
	humanoid.Died:Connect(function()
		-- Unbind the ragdoll action, to not get any unintended errors outputted when the user tries to ragdoll when they are not alive.
		ContextActionService:UnbindAction("Ragdoll");

		-- Destroy the ragdoll class to not cause a memory leak
		clientRagdoll:Destroy();

		-- Set variables to nil, so there are no references to stuff that is no longer in use.
		clientRagdoll = nil;
		head = nil;
		humanoid = nil;

		-- Set ragdollEnabled to false, so that the next time the user presses the ragdoll keybind (when the character spawns in again)
		-- handleAction doesn't think that the ragdoll is enabled and then tries to disable it.
		ragdollEnabled = false;
	end);
end;

-- Everything is copied from  ServerRagdolls ClientRagdollHandler example, until this part. This is where we handle other people's ragdolls.

-- We pretty much have the same logic as the ServerRagdolls/ServerRagdollHandler example here.
-- We handle players leaving along with players wanting to ragdoll the same way in the ServerRagdolls/ServerRagdollHandler example.
function onClientEvent(ragdollPlayer, enabled, seed)
	-- ServerRagdollHandler uses :FireAllClients() (we are not exempt from that), so we make sure that the ragdollPlayer isn't the current client.
	if ragdollPlayer == client then
		return
	end;

	local ragdoll = ragdolls[ragdollPlayer];
	if enabled then
		-- We check if the ragdoll exists already, which if true probably means they died and got a new character.
		-- If true we destroy that ragdoll, and replace it with a new one.
		if ragdoll then
			ragdoll:Destroy()
		end
		
		ragdoll = RagdollClass.new(ragdollPlayer.Character, seed);
		ragdoll:SetRagdollEnabled(true);
		-- We set the player key in the ragdolls table to be our ragdoll class, so once the ragdoll player client wants to disable their ragdoll state, 
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
function onPlayerRemoving(player)
	-- Check if this player has a ragdoll on this client
	local ragdoll = ragdolls[player]
	if ragdoll then
		-- destroy it if it is there.
		ragdoll:Destroy()
		ragdolls[player] = nil
	end
end;

--[[ Connections ]]--

client.CharacterAdded:Connect(onCharacterAdded);
ragdollRemote.OnClientEvent:Connect(onClientEvent);
Players.PlayerRemoving:Connect(onPlayerRemoving);