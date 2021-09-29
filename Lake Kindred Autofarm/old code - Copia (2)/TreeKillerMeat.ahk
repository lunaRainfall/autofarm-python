#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
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

;Finds a battle from the Map, then selects Watermeat from the second slot
findbattle()
{
	;msgbox, "findbattle routine started"
	waitingselect := true
	randclick(905, 915, 270, 280)
	randsleep(100, 200)
	randclick(905, 915, 270, 280)
	randsleep(200, 300)
	randclick(660, 700, 420, 425)
	randsleep(100, 200)
	randclick(660, 700, 420, 425)
	while (waitingselect = true)
	{
		;msgbox, "entered inbattle while loop" %waitingselect%
		imagesearch, foundX, foundY, 0, 0, 500, 500, *60 selectmeat.png
		if(foundX != "")
		{
			randclick(foundX + 10, foundX + 20, foundY + 10, foundY + 20)
			randsleep(200, 400)
			waitingselect := false
		}
		;else msgbox, "not found yet"
	}
}

;Flees from the battle
fleebattle()
{
	inbattle := true
	;msgbox, "should flee!"
	while (inbattle = true)
	{
		imagesearch, foundX, foundY, 0, 0, 1100, 1000, *60 flee.png
		if(foundX != "")
		{
			;msgbox "found flee.png"
			randclick(foundX, foundX + 10, foundY, foundY + 10)
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

;Uses Watermeat's damaging move
attack()
{
	randclick(480, 490, 520, 530)
	randsleep(200, 350)
	randclick(600, 610, 350, 355)
}

;Uses a Full Heal
heal()
{
	randclick(780, 800, 530, 540)
	randsleep(500, 800)
	randclick(530, 540, 260, 270)
	randsleep(100, 200)
	randclick(530, 540, 260, 270)
	randsleep(100, 200)
	randclick(830, 850, 420, 430)
	randsleep(100, 200)
	randclick(830, 850, 420, 430)
}

;Uses an Antidote
curepoison()
{
	randclick(780, 800, 530, 540)
	randsleep(500, 800)
	randclick(680, 690, 260, 270)
	randsleep(100, 200)
	randclick(680, 690, 260, 270)
	randsleep(100, 200)
	randclick(830, 850, 420, 430)
	randsleep(100, 200)
	randclick(830, 850, 420, 430)
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
			SoundPlay, *16
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

;;winrestore, ahk_class MozillaWindowClass
;;winactivate
randsleep (300, 500)
while (true)
{
	findbattle()
	;msgbox, "If it's a tree, start the battle routine"
	imagesearch, foundX, foundY, 0, 0, 1500, 500, *20 tree.png
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
				imagesearch, foundX, foundY, 0, 0, 1000, 500, *40 meatlethalrange.png
				if(foundX != "")
				{
					attack()
				}
				else
				{
					;msgbox, "Third, if enemy is not in lethal range, proceed to check for low health"
					imagesearch, foundX, foundY, 0, 0, 1000, 400, *60 meatlowhealth.png
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
				randsleep(1000, 1200)
				imagesearch, foundX, foundY, 0, 0, 1000, 500, *40 battlewon.png
				if(foundX != "")
				{
					;msgbox "Battle won!"
					randclick(630, 640, 510, 520)
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
























