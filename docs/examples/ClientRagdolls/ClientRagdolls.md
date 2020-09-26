# Client Ragdolls
 Client-sided ragdolls are ragdolls that are done on each client individiually, which means they will appear smooth for everyone.
 Client ragdolls should be used when they are more of a cosmetic effect and cannot affect gameplay, 
 which means they are not appropriate for usage for a FPS game, since the ragdolls are done on each client individually, [the ragdolls might de-sync and give the opposition an unfair advantage, where they can see you through a body, but you cannot.](https://www.youtube.com/watch?v=QgPwtoUqWKo)

 I recommend using client-sided ragdolls when you want silky smooth ragdolls, and when they do not matter to the gameplay too much.
 
 There are a few issues though:
 
 - They might de-sync, which means that each client might see the ragdolls a bit differently. 
   This means they cannot be used for competitive games if they can affect gameplay.
 - They may hurt lower end devices performance, if there are a large amount of ragdolls. How you can fix this is very specific to your game, and there is no real "universal" solution to it.


 - DISCLAIMER: Please, please only use the code as an example, and when working on your implementation make it more secure using sanity checks.

## How to setup the example

 _I pretty much copied the format of "How to setup the example" from ServerRagdolls.md to here lol_ 

 First, create a local script which should be parented to ``StarterPlayer.StarterPlayerScripts``.
 This will be our client-sided handler, so feel free to call it anything you want.

 Copy paste the code from [ClientRagdollHandler.lua](https://github.com/aku-e/RagdollClass/blob/master/docs/examples/ClientRagdolls/ClientRagdollHandler.lua) and paste it in the newly created local script.

 After that, create a server script, and parent it to ``ServerScriptService`` (it does not matter that much where you parent the server script, however ServerScriptService is intended for storing server scripts as implied by the name).

 Copy paste the code from [ServerRagdollHandler.lua](https://github.com/aku-e/RagdollClass/blob/master/docs/examples/ClientRagdolls/ServerRagdollHandler.lua) and paste it into the server script.

 The example should now be setup, and you can now observe how it functions.

 I suggest reading [ServerRagdolls](https://github.com/aku-e/RagdollClass/blob/master/docs/examples/ServerRagdolls/ServerRagdolls.md) if you haven't already.