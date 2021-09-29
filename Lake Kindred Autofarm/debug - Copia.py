import cv2
import numpy as np
import pyautogui

stageSelect = True
kinSelect = False
tryFlee = False
battleLoop = True
waitingMove = True
antibot = True
verifyAttempts = 0

conf = 0.9

def attack():
    input()
    foundCoords = pyautogui.locateCenterOnScreen('moveready.PNG', confidence=conf)
    pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
    foundCoords = pyautogui.locateCenterOnScreen('meatattack.PNG', confidence=conf)
    pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)

while(battleLoop):
    while(antibot):
                    print(verifyAttempts, "attempts so far")
                    if(verifyAttempts == 2):
                        print('script failed 2 times, this requires human assistance!')
                        input()
                    else:
                        foundCoords = pyautogui.locateCenterOnScreen('loading.PNG', confidence=conf)
                        print('looking for the loading screen')
                        if (foundCoords == None):
                            print('loading screen not found, attempt starting')
                            input()
                            foundCoords = pyautogui.locateCenterOnScreen('avatar.PNG', confidence=conf)
                            pyautogui.click(foundCoords, clicks=2, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                            pyautogui.moveRel(0, 25, duration = 0.1, tween=pyautogui.easeOutQuad) 
                            pyautogui.click(clicks=2)
                            verifyAttempts = verifyAttempts + 1
                            
                    foundCoords = pyautogui.locateCenterOnScreen('exitbattle.PNG', confidence=conf)
                    if(foundCoords != None):
                        print('hey it worked!')
                        antibot = False
            
