return {

	-- This is how "random" the ragdoll is.
	-- When the ragdoll is activated, it randomises all the limbs velocities relative to the HumanoidRootPart,
	-- which you can configure using ["MaxRandomVelocity"].
	-- It also accounts for previous velocity, so say the person is walking forwards they are likely to fall forwards.
	-- This exists to give the ragdoll more variety, however feel free to set them to 0 to have no randomness.
	["MaxRandomVelocity"] = Vector3.new(
		10,
		28,
		10
	),

	-- When the ragdoll gets enabled, the code reduces the friction of these limbs.
	-- How we determine a limb is based on the limb name, the last word of it (The detection requires it to be pascal case, which is already the case for Roblox characters).
	["ReducedFrictionLimbs"] = {
		"Arm",
		"Leg",
	},

	-- When the ragdoll gets enabled, the code reduces the friction.
	-- These are the related settings, which you can read more about in https://developer.roblox.com/en-us/api-reference/datatype/PhysicalProperties
	["ReducedFriction"] = 0.15,
	["ReducedFrictionWeight"] = 50,
};