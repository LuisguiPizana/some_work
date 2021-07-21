#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 12 13:59:58 2020

@author: luisguillermopizana
"""

#Selenium imports here
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver import ActionChains
import time


#Other imports here
import os
import wget

driver = webdriver.Chrome("/Applications/chromedriver")
driver.get("https://www.instagram.com/")

username = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "input[name='username']")))

password = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "input[name='password']")))
                         
username.clear()
password.clear()

username.send_keys("xhindomx")     
password.send_keys("Epifania123")

log_in = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.CSS_SELECTOR, "button[type = 'submit']"))).click()

not_now = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Not Now')]"))).click()

not_now2 = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, "//button[contains(text(), 'Not Now')]"))).click()

driver.get("https://www.instagram.com/xhindomx/")


lenOfPage = driver.execute_script("window.scrollTo(0, document.body.scrollHeight);var lenOfPage = document.body.scrollHeight;return lenOfPage;")




driver.execute_script("window.scrollTo(0,4000);")
match = False

images = []

while(match==False):
    lastCount = lenOfPage
    time.sleep(3)
    aux = driver.find_elements_by_tag_name('img')
    for image in aux:
        aux1 = image.get_attribute('src')
        if aux1 not in images:
            images.append(aux1)
    lenOfPage = driver.execute_script("window.scrollTo(0, document.body.scrollHeight);var lenOfPage = document.body.scrollHeight;return lenOfPage;")
    if lastCount == lenOfPage:
        match = True



#Se vuelve a descargar después de hacer el load. Solo guarda las imagenes cargadas.


path = os.getcwd()
path = os.path.join(path, "Xhindó_feed")

try:
    os.mkdir(path)
except:
    print("Ya existe el folder")


counter = 1
for image in images:
    save_as = os.path.join(path, "Xhindó_feed_"+str(counter)+".jpg")
    wget.download(image,save_as)
    counter += 1


    
"""

SECCIÓN DE BUSQUEDA. NO FUNCIONA EL COMANDO SEND_KEYS(KEYS.ENTER)

searchbox = WebDriverWait(driver,10).until(EC.element_to_be_clickable((By.XPATH, "//input[@placeholder = 'Search']")))

searchbox.clear()

keyword = "xhindomx"

searchbox.send_keys(keyword)

driver.implicitly_wait(3)

searchbox.send_keys(Keys.ENTER)

searchbox.send_keys(Keys.ENTER)

"""











