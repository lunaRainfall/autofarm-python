import cv2
import numpy as np
import pyautogui

conf = 0.9
itemSelect = False

for x in range(100):
    print(x)
    itemSelect = True
    while(itemSelect):
        foundCoords = pyautogui.locateCenterOnScreen('buyhealth.PNG', confidence=0.98)
        if(foundCoords != None):
            pyautogui.click(foundCoords, clicks=1, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
            while(itemSelect):
                foundCoords = pyautogui.locateCenterOnScreen('buyconfirm.PNG', confidence=conf)
                if(foundCoords != None):
                    pyautogui.click(foundCoords, clicks=1, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                    while(itemSelect):
                        foundCoords = pyautogui.locateCenterOnScreen('ok.PNG', confidence=conf)
                        if(foundCoords != None):
                            pyautogui.click(foundCoords, clicks=1, interval=0.2, duration=0.2, tween=pyautogui.easeOutQuad)
                            itemSelect = False

