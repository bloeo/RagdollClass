# Server Ragdolls
 Server-sided ragdolls are ones that everyone sees as the same, and run on the server. 

 These are more ideal for FPS games, as you want everyone to see that the ragdolls are the exactly same,
 so that you cannot abuse the client bodies difference.

 Unfortunately, they come with a few drawbacks:

 - They are not very smooth, they appear slightly choppy on Roblox. I do not know why this happens. (The original client sees a smooth ragdoll)
 - They hurt the server performance in large amounts.


 - DISCLAIMER: Please, please only use the code as an example, and when working on your implementation make it more secure using sanity checks.

## How to setup the example

 First, create a local script which should be parented to ``StarterPlayer.StarterPlayerScripts``.
 This will be our client-sided handler, so feel free to call it anything you want.

 Copy paste the code from [ClientRagdollHandler.lua](https://github.com/aku-e/RagdollClass/blob/master/docs/examples/ServerRagdolls/ClientRagdollHandler.lua) and paste it in the newly created local script.

 After that, create a server script, and parent it to ``ServerScriptService`` (it does not matter that much where you parent the server script, however ServerScriptService is intended for storing server scripts as implied by the name).

 Copy paste the code from [ServerRagdollHandler.lua](https://github.com/aku-e/RagdollClass/blob/master/docs/examples/ServerRagdolls/ServerRagdollHandler.lua) and paste it into the server script.

 The example should now be setup, and you can now observe how it functions.

 I'd love to do an example for client ragdolls, however there's some weird bugs I do not know how to counter.
 If you want to implement client ragdolls, please do because you're able to. This is only an example.