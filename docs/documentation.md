# RagdollClass Documentation
 This is the documentation for RagdollClass API.
 
 If you want examples on how to use RagdollClass, and replicate it properly, go to [examples!](https://github.com/aku-e/RagdollClass/blob/master/docs/examples)

 - Disclaimer: I do not document functions that aren't intended to be used outside of the RagdollClass module, as these can/probably will change. Please do not rely on them.

## Constructors
 ``RagdollClass.new(Character: Player.Character, Seed: number)``
 - returns RagdollClass. You call the methods on the returned object. The seed argument is optional.

## Properties
 ``RagdollClass.Seed``
 - The seed used for the randomness ragdoll. This is mainly intended to be used when you are replicating ragdolls, to make them not de-sync due to the randomness.

## Methods
 ``RagdollClass:SetRagdollEnabled(Enabled: Boolean)``
 - This sets if the ragdoll is enabled or not. If Enabled is true, you'll ragdoll (if you aren't already ragdolling) or if it is false, it disables the ragdoll.
 
 ``RagdollClass:ResetFriction()``
 - This resets the friction of your limbs. This is mainly used by :SetRagdollEnabled(), however feel free to use it.
 Why this exists is because the ragdoll alters how much friction certain limbs have, so we need to reset it once the ragdoll is done.
 
 ``RagdollClass:ReduceFriction()``
 - This reduces the friction, mainly used by :SetRagdollEnabled()
 This exists to reduce the friction of limbs during a ragdoll.

 ``RagdollClass:Destroy()``
 - Destroys the RagdollClass object. Use this when either your character has died or you're done using the ragdoll.

## Functions
 ``RagdollClass.DisableMotors(Character: Player.Character)``
 - This is needed for client-sided ragdolls, as there's a weird bug which means you need to disable the motors on the server too, before being able to properly do a ragdoll on the client. See [ClientRagdolls ServerRagdollHandler code.](https://github.com/aku-e/RagdollClass/tree/master/docs/examples/ClientRagdolls/ServerRagdollHandler.lua)