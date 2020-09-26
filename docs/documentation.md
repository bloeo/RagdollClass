# RagdollClass Documentation
 This is the documentation for RagdollClass API.
 
 If you want examples on how to use RagdollClass, and replicate it properly, go to [examples!](https://github.com/aku-e/RagdollClass/blob/master/docs/examples)

- Disclaimer: I do not document functions that aren't intended to be used outside of the RagdollClass module, as these can/probably will change. Please do not rely on them.

## Constructors
 ``RagdollClass.new(Character: Player.Character)``
 returns RagdollClass. You call the methods on the returned object.
 
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
