#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;This will farm Sycamortes with minimal user input. Version 2.0 brings a code overhaul to fix common issues and ensure consistency.

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

;Finds a battle from the Map, then selects Pumperilla from the first slot
findbattle()
{
	waitingselect := true
	randclick(1020, 1040, 215, 260)
	randsleep(100, 200)
	randclick(1020, 1040, 215, 260)
	randsleep(200, 300)
	randclick(760, 860, 385, 410)
	randsleep(100, 200)
	randclick(760, 860, 385, 410)
	while (waitingselect = true)
	{
		;msgbox, "entered inbattle while loop" %waitingselect%
		imagesearch, foundX, foundY, 0, 0, 500, 205, selectpump.png
		if(foundX != "")
		{
			randclick(420, 425, 135, 185)
			randsleep(200, 400)
			waitingselect := false
		}
		;else msgbox, "not found yet"
	}
}

;Flees from the battle (Needs testing)
fleebattle()
{
	inbattle := true
	;msgbox, "should flee!"
	while (inbattle = true)
	{
		imagesearch, foundX, foundY, 0, 0, 1100, 600, *60 flee.png
		if(foundX != "")
		{
			randclick(975, 1000, 500, 515)
			randsleep(500, 750)
			;msgbox, "stopping for testing purposes"
		}
		imagesearch, foundX, foundY, 0, 0, 1020, 475, *60 fleesucessful.png
		;msgbox, %foundX%
		if(foundX != "")
		{
			inbattle = false
			;msgbox, "loop broken!"
		}
	}
}

;Uses Pumperilla's damaging move
attack()
{
	randclick(600, 615, 505, 480)
	randsleep(200, 350)
	randclick(650, 850, 320, 330)
}

;Uses Pumperilla's healing move
heal()
{
	randclick(600, 615, 505, 480)
	randsleep(200, 350)
	randclick(650, 850, 360, 350)
}

;Uses an Antidote
curepoison()
{
	randclick(885, 900, 520, 480)
	randsleep(500, 1000)
	randclick(770, 820, 270, 220)
	randsleep(500, 1000)
	randclick(910, 1000, 400, 385)
	randsleep(100, 200)
	randclick(910, 1000, 400, 385)
	sleep 1000
}

;Alerts the human behind this to actually solve the antibot verification
antibot()
{
	imagesearch, foundX, foundY, 0, 0, 1000, 600, *10 antibot.png
	if(foundX != "")
	{
		antibot := true
		while(antibot = true)
		{
			SoundPlay, *48
			sleep, 1000
			imagesearch, foundX, foundY, 0, 0, 1000, 600, *10 antibot.png
			if(foundX = "")
			{
				antibot = false
				randsleep(200, 300)
			}	
		}
	}
}

;Holds the thread until the move is ready, if the battle hasn't ended it returns false
waitmove()
{
	while(true)
	{
		imagesearch foundX, foundY, 0, 0, 700, 700, *30 movewait.png
		if(foundX != "")
		{
			;msgbox, "Still waiting, will sleep and try again"
			sleep 250
		}
		else
		{
			imagesearch foundX, foundY, 0, 0, 700, 700, *30 moveready.png
			if(foundX != "")
			{
				;msgbox, "Not waiting and move is ready"
				return true
			}
			else
			{
				;msgbox, "Not waiting but move is not ready, battle has ended"
				return false
			}
		}
	}
}

;-----===-----===-----===-----
;Code starts below
;-----===-----===-----===-----
winrestore, ahk_class MozillaWindowClass
winactivate
sleep 500
while (true)
{
	findbattle()
	;msgbox, "If it's a tree, start the battle routine"
	imagesearch, foundX, foundY, 1100, 130, 1180, 210, *10 tree.png
	;foundX = "success"
	if(foundX != "")
	{
		inbattle := true
		randsleep(1000, 1200)
		;msgbox, "Sycamorte found, inbattle is true"
		while(inbattle = true)
		{
			moveready := waitmove()
			if(moveready = true)
			{
				;msgbox, "If the waitmove function returns true, then the battle is ongoing"
				;msgbox, "First, check for poison"
				imagesearch, foundX, foundY, 0, 0, 600, 600, *20 poisoned.png
				if(foundX != "")
				{
					curepoison()
					randsleep(1000, 1200)
				}
			
				;msgbox, "Second, check for lethal"
				imagesearch, foundX, foundY, 900, 150, 1100, 185, *20 pumplethalrange.png
				if(foundX != "")
				{
					attack()
				}
				else
				{
					;msgbox, "Third, if enemy is not in lethal range, proceed to check for low health"
					imagesearch, foundX, foundY, 0, 0, 750, 400, *10 pumplowhealth.png
					if(foundX != "")
					{
						heal()
					}
					else
					{
						;msgbox, "Fourth, if enemy is not in lethal range and health is not low, proceed to attack"
						attack()
					}
				}
			}
			else
			{
				;msgbox, "If the waitmove function does not return true, then the battle has ended somehow"
				;msgbox, "First, check for victory"
				imagesearch, foundX, foundY, 0, 0, 1000, 500, *40 battlewon.png
				if(foundX != "")
				{
					randclick(677, 784, 474, 497)
					randsleep(200, 400)
				}
				else
				{
					;msgbox, "Second, if the battle hasn't ended well, check for a loss screen"
					imagesearch, foundX, foundY, 0, 0, 1000, 600, *40 battlelost.png
					if(foundX != "")
					{
						randclick(818, 923, 398, 420)
						randsleep(200, 400)
					}
					else
					{
						;msgbox, "Third, if no win/lose screen is available, then check for the antibot"
						imagesearch, foundX, foundY, 0, 0, 1000, 600, *10 antibot.png
						if(foundX != "")
						{
							antibot()
						}
						else
						{
							;soundplay *16
							;msgbox, "Fourth, if something else happened, stop the script and show this message"
						}
					}
				}
			}
			imagesearch, foundX, foundY, 0, 0, 1020, 475, *60 fleesucessful.png
			if(foundX != "")
			{
				inbattle = false
			}
			;msgbox, "Turn has ended! inbattle is: " %inbattle%
		}
	}
	else
	{
		;msgbox, "If it's not a tree, then flee"
		fleebattle()
	}
}
























