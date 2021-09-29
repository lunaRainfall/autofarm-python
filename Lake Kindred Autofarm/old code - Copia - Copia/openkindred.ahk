;Sleeps for a random period of time within entered range
randsleep(minTime, maxTime)
{
	sleepTime = 0
	random, sleepTime, minTime, maxTime
	sleep sleepTime
}

;Clicks a random location in the screen within entered range
randclick(minX, maxX, minY, maxY)
{
	random xpos, %minX%, %maxX%
	random ypos, %minY%, %maxY%
	click %xpos%, %ypos%
}

run https://www.gaiaonline.com/pets/lite
sleep 500
winactivate
loading := true
while (loading = true)
{
	loading := true
	while (loading = true)
	{
		imagesearch, foundX, foundY, 900, 300, 1300, 600, *30 mainscreen.png
		if (foundX != "")
		{
			randclick(1085, 1160, 470, 440)
			randsleep(600, 1200)
			randclick(750, 840, 380, 300)
			loading := false
		}
	}
	sleep 200
	run TreeKillerMeat.ahk
}