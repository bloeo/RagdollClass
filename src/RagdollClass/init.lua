--[[
	Name: RagdollClass
	Author: guidable

	Source: https://github.com/aku-e/RagdollClass
	License: https://github.com/aku-e/RagdollClass/blob/master/LICENSE.md

	Creation date: 2020/09/25
--]]

local RagdollClass = {};
RagdollClass.__index = RagdollClass;

local RunService = game:GetService("RunService")

local Maid = require(script.Maid);
local RagdollRigging = require(script.RagdollRigging);
-- Configure ragdoll settings in configuration.
local Configuration = require(script.Configuration);
-- @@ Constructors
function RagdollClass.new(character: Player.Character)
	local self = setmetatable({
		character = character;
		maid = Maid.new();
		enabled = false;
	}, RagdollClass);
	self:initializeClass();
	return self;
end;

-- @@ Private Methods
function RagdollClass:initializeClass()
	local humanoid = self.character:FindFirstChildWhichIsA("Humanoid");
	local humanoidRootPart = self.character:FindFirstChild("HumanoidRootPart");

	assert(humanoid, "Humanoid does not exist in the provided character");
	assert(humanoidRootPart, "HumanoidRootPart does not exist in the provided character");

	self.humanoid = humanoid;
	self.humanoidRootPart = humanoidRootPart;
	-- This state in specific causes some issues when recovering from an ragdoll, so we disable it for the duration of the RagdollClass existance.
	-- When you call :Destroy() it'll re-enable it.
	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
end;

-- @@ Methods
function RagdollClass:SetRagdollEnabled(enabled: boolean)
	assert(enabled ~= self.enabled, "ragdoll is already in that state you're trying to set it to");
	self.enabled = enabled;
	if enabled then
		-- I took some stuff from Ragdollable.lua by Quenty
		-- Here's the link to it: https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Server/Ragdoll/Classes/Ragdollable.lua
		local character = self.character;
		local humanoid = self.humanoid;
		local humanoidRootPart = self.humanoidRootPart;

		local animator = humanoid:FindFirstChildWhichIsA("Animator");
		local rigType = humanoid.RigType;

		humanoid.BreakJointsOnDeath = false;
		humanoid.AutoRotate = false;
		humanoid:ChangeState(Enum.HumanoidStateType.Physics);

		RagdollRigging.createRagdollJoints(character, rigType);
		local motors = RagdollRigging.disableMotors(character, rigType);

		if animator then
			animator:ApplyJointVelocities(motors);
		end;

		for _, animationTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
			-- I'm using a thousandth of the second instead of 0 because there's a bug where if it is 0 it freezes poses?
			-- Read the developer hub for more information: https://developer.roblox.com/en-us/api-reference/function/AnimationTrack/Stop
			animationTrack:Stop(0.001);
		end;

		local maxRandomVelocity = Configuration.MaxRandomVelocity
		local randomObject = Random.new(os.clock() * 1000 + (humanoidRootPart.Velocity + humanoidRootPart.Position + humanoidRootPart.Orientation).Magnitude * 100000);
		for _, basePart in pairs(character:GetDescendants()) do
			if basePart:IsA("BasePart") then
				local limb = humanoid:GetLimb(basePart);
				if limb ~= Enum.Limb.Unknown then
					local randomVelocity = Vector3.new(
						randomObject:NextNumber(-maxRandomVelocity.X, maxRandomVelocity.X),
						randomObject:NextNumber(-maxRandomVelocity.Y, maxRandomVelocity.Y),
						randomObject:NextNumber(-maxRandomVelocity.Z, maxRandomVelocity.Z)
					);
					basePart.Velocity = basePart.Velocity + humanoidRootPart.CFrame:VectorToWorldSpace(randomVelocity);
				end;
			end;
		end;

		self:ReduceFriction();

		-- Some extra support for the replication.
		-- For the server-side ragdolls what essentially happens is ragdoll player creates a ragdollclass on their client, then sends a signal to the server.
		-- the server creates an ragdoll on their side, which means now the server-sided ragdoll constraints will replicate to the client.
		-- I edited the ragdoll rigging a little bit so that it puts "Server" in front of the server ragdoll constraints names, 
		-- so that we can easily know if a ragdoll constraint is a server one or a client one.
		if RunService:IsClient() then
			self.maid:GiveTask(character.DescendantAdded:Connect(function(descendant)
				if descendant:IsA("BallSocketConstraint") and (descendant.Name:find("Server")) == 1 then
					descendant.Enabled = false;
				end;
			end));
		end;

		self.maid:GiveTask(humanoid.AnimationPlayed:Connect(function(animationTrack)
			animationTrack:Stop(0.001);
		end));

		-- Prevent animation transform loop?
		-- Took this from Quenty's ragdoll utils (https://github.com/Quenty/NevermoreEngine/blob/version2/Modules/Shared/Ragdoll/RagdollUtils.lua)
		-- This is quite specific to R15
		local lowerTorso = character:FindFirstChild("LowerTorso");
		if lowerTorso then
			local root = lowerTorso:FindFirstChild("Root");
			if root then
				local lastTransform = root.Transform;
				self.maid:GiveTask(RunService.Stepped:Connect(function()
					root.Transform = lastTransform;
				end));
			end;
		end;

		self.maid:GiveTask(humanoid.StateChanged:Connect(function(_, newState)
			if newState ~= Enum.HumanoidStateType.Physics and newState ~= Enum.HumanoidStateType.Dead then
				humanoid:ChangeState(Enum.HumanoidStateType.Physics);
			end;
		end));

		self.maid:GiveTask(function()
			RagdollRigging.removeRagdollJoints(character);
			for _, motor in pairs(motors) do
				motor.Enabled = true;
			end;

			self:ResetFriction();

			humanoid.BreakJointsOnDeath = true;
			humanoid.AutoRotate = true;

			humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics);
		end);
	else
		self.maid:Destroy();
	end;
end;

function RagdollClass:ResetFriction()
	local reducedFrictionLimbs = Configuration.ReducedFrictionLimbs;
	for _, basePart in pairs(self.character:GetChildren()) do
		if basePart:IsA("BasePart") and table.find(reducedFrictionLimbs, RagdollClass.GetLastWordFromPascalCase(basePart.Name)) then
			basePart.CustomPhysicalProperties = PhysicalProperties.new(basePart.Material);
		end;
	end;
end;

function RagdollClass:ReduceFriction()
	local reducedFrictionLimbs = Configuration.ReducedFrictionLimbs;
	for _, basePart in pairs(self.character:GetChildren()) do
		if basePart:IsA("BasePart") and table.find(reducedFrictionLimbs, RagdollClass.GetLastWordFromPascalCase(basePart.Name)) then
			local materialPhysicalProperties = PhysicalProperties.new(basePart.Material);
			basePart.CustomPhysicalProperties = PhysicalProperties.new(
				materialPhysicalProperties.Density,
				Configuration.ReducedFriction,
				materialPhysicalProperties.Elasticity,
				Configuration.ReducedFrictionWeight,
				materialPhysicalProperties.ElasticityWeight
			);
		end;
	end;
end;

function RagdollClass:Destroy()
	self.humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true);
	self.maid:Destroy();
end;

-- @@ Functions

-- Copied the function name from EchoReaper's ragdoll module since it was that good :D
-- https://devforum.roblox.com/t/r15-rthro-ragdolls/338580, RagdollLoader --> buildRagdoll --> getLastWordFromPascalCase
-- I also follow the same principles, such as removing trailing numbers.
function RagdollClass.GetLastWordFromPascalCase(text: string)
	text = text:reverse();

	local wordStart = text:find("[%u]");
	local word = text:sub(1, wordStart):reverse();

	word = word:gsub("%d+$", "");
	return word;
end;

return RagdollClass;