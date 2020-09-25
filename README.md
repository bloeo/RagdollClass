# RagdollClass
 A class that allows you to create togglable ragdolls with ease.

## How to use
 Install Rojo if you don't have it already (https://rojo.space)
 Clone this repository to your directory of choice, now navigate to the directory using your terminal of choice, and type in "rojo serve".
 In Roblox Studio now press connect in the rojo plugin (specify port if necessary).
 You should now see the RagdollClass module in ReplicatedStorage. 

## Documentation
 I'll quickly mention that it's up to you to handle creating ragdolls on the server and the client.
 You cannot just require RagdollClass on the client and call :Enable(), and expect it to work.
 In the examples folder, there's two examples on how to handle it.
 Server-sided bodies and client-sided bodies.
 
 [Documentation] (https://github.com/aku-e/RagdollClass/blob/master/docs/documentation.md)

## Credits
 Most of the actual ragdolling code was created by Quenty, with minor edits by me.
 The maid class was also created by Quenty.
 You can find the original links for them in the source files.