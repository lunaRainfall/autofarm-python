import cv2
import numpy as np
import pyautogui
import time

stageSelect = True
kinSelect = False
tryFlee = False
battleLoop = False
waitingMove = True
antibotWins = 0
antibotLosses = 0
wonBattles = 0
fledEncounters = 0

conf = 0.9
#print("waiting input to start!")
#input()

def attack():
    ##input()
    foundCoords = pyautogui.locateCenterOnScreen('moveready.PNG', confidence=conf)
    pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
    foundCoords = pyautogui.locateCenterOnScreen('meatattack.PNG', confidence=conf)
    pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)

while(True):

    while(stageSelect):
        print("looking for stage5")
        foundCoords = pyautogui.locateCenterOnScreen('stage5.PNG', confidence=conf)
        if(foundCoords != None):
            print("found stage5!")
            while(stageSelect):
                print("looking for startbattle")
                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                foundCoords = pyautogui.locateCenterOnScreen('startbattle.png', confidence=conf)
                if(foundCoords != None):
                    print("found startbattle!")
                    pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                    stageSelect = False
                    kinSelect = True
                    print("stageSelect is", stageSelect)
                else: 
                    print("stageSelect is", stageSelect)
        else:
            print("stage5 not found, keep looking")

    while(kinSelect):
        print("looking for watermeat")
        foundCoords = pyautogui.locateCenterOnScreen('selectmeat.PNG', confidence=conf)
        if(foundCoords != None):
            print('found watermeat!')
            pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
            kinSelect = False
            print("checking for tree")
            foundCoords = pyautogui.locateCenterOnScreen('tree.PNG', confidence=conf)
            if(foundCoords != None):
                battleLoop = True
                waitingMove = True
                print("commencing battle")
            else:
                tryFlee = True

    while(tryFlee):
        print("looking for the flee button")
        foundCoords = pyautogui.locateCenterOnScreen('flee.PNG', confidence=conf)
        if(foundCoords != None):
            pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
        print("looking for stage5")
        foundCoords = pyautogui.locateCenterOnScreen('stage5.PNG', confidence=conf)
        if(foundCoords != None):
            print("found stage5, returning to stageSelect")
            fledEncounters = fledEncounters + 1
            tryFlee = False
            stageSelect = True

    while(battleLoop):
        while(waitingMove):
            print('looking for moveready')
            foundCoords = pyautogui.locateCenterOnScreen('moveready.PNG', confidence=0.99) #this confidence check must be very precise
            if(foundCoords != None):
                print('move ready!')
                waitingMove = False
            print("looking for exitbattle")
            foundCoords = pyautogui.locateCenterOnScreen('exitbattle.PNG', confidence=conf)
            if(foundCoords != None):
                print("battle is over!")
                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                waitingMove = False
                battleLoop = False
                stageSelect = True
                wonBattles = wonBattles + 1
            print('looking for avatar')
            foundCoords = pyautogui.locateCenterOnScreen('avatar.PNG', confidence=conf)
            if(foundCoords != None):
                print('antibot engaged!')
                antibot = True
                verifyAttempts = 0
                while(antibot):
                    print(verifyAttempts, "attempts so far")
                    foundCoords = pyautogui.locateCenterOnScreen('loading.PNG', confidence=conf)
                    print('looking for the loading screen')
                    if (foundCoords == None):
                        print('loading screen not found, looking for exit')
                        foundCoords = pyautogui.locateCenterOnScreen('exitbattle.PNG', confidence=conf)
                        if(foundCoords != None):
                            print('hey it worked!')
                            pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                            antibotWins = antibotWins + 1
                            wonBattles = wonBattles + 1
                            antibot = False
                            waitingMove = False
                            battleLoop = False
                            stageSelect = True
                        else:
                            foundCoords = pyautogui.locateCenterOnScreen('avatar.PNG', confidence=conf)
                            if(verifyAttempts == 2):
                                print('script failed 2 times, this requires human assistance!')
                                antibotLosses = antibotLosses + 1
                                input()
                            else:
                                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                                pyautogui.moveRel(0, 25, duration = 0.1, tween=pyautogui.easeOutQuad) 
                                pyautogui.click(clicks=2)
                                verifyAttempts = verifyAttempts + 1
                                time.sleep(1)

        #these nested statements will check for the following states in order: battle over, poisoned, lethal, low health. If no statement is true, then Watermeat just attacks
        if(battleLoop):
            print("looking for poison status")
            foundCoords = pyautogui.locateCenterOnScreen('poisoned.PNG', confidence=conf)
            if(foundCoords != None):
                print('watermeat is poisoned and should be cured!')
                foundCoords = pyautogui.locateCenterOnScreen('items.PNG', confidence=conf)
                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                foundCoords = pyautogui.locateCenterOnScreen('antidote.PNG', confidence=0.7)
                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                foundCoords = pyautogui.locateCenterOnScreen('use.PNG', confidence=conf)
                pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                waitingMove = True
            else:
                print("looking for lethal range")
                foundCoords = pyautogui.locateCenterOnScreen('meatlethalrange.PNG', confidence=0.97)
                if(foundCoords != None):
                    print('watermeat has lethal and should attack!')
                    attack()
                    waitingMove = True
                else:
                    print("looking for low health range")
                    foundCoords = pyautogui.locateCenterOnScreen('meatlowhealth.PNG', confidence=conf)
                    if(foundCoords != None):
                        print('watermeat is low and should be healed!')
                        foundCoords = pyautogui.locateCenterOnScreen('items.PNG', confidence=conf)
                        pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                        foundCoords = pyautogui.locateCenterOnScreen('maxpotion.PNG', confidence=0.97)
                        pyautogui.click(foundCoords, clicks=3, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                        foundCoords = pyautogui.locateCenterOnScreen('use.PNG', confidence=conf)
                        pyautogui.click(foundCoords, clicks=2, interval=0.3, duration=0.2, tween=pyautogui.easeOutQuad)
                        waitingMove = True
                    else:
                        print('not poisoned, presenting lethal or low health, attack!')
                        attack()
                        waitingMove = True



    print("we've beat the antibot", antibotWins, "times, required assistance on", antibotLosses)
    print(fledEncounters, "encounters fled,", wonBattles, "trees defeated so far")