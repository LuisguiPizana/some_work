#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 30 14:18:48 2020

@author: luisguillermopizana
"""
# Importamos paquetes necesarios

import pandas as pd
import datetime as dt
import os  #create new directories
import pandas_datareader.data as web
import bs4 as bs
import pickle
import requests




#Función para encontrar tickers de un índice
#in: sitio web en el que debe de buscar la información
#   direccion   
#   nombre del archivo
#out: 
# Crea un archivo pickle con los tickers
# Regresa una lista con tickers como string

# Por ahora lee la información de un sitio wikipedia (mira linea 35) como el siguiente:
# https://en.wikipedia.org/wiki/List_of_S%26P_600_companies

# Ejemplo de directory en donde se guardarán los tickers
# /Users/luisguillermopizana/Desktop/Python/Python + Finance/Ticker pickles 

#ESTA FUNCIÓN YA ES FUNCIONAL
#Solamente sirve para sp600

def save_tickers(url, directory,name,ticker_col):
    resp = requests.get(url)
    if not os.path.exists(directory):
        os.makedirs(directory) 
    #un objeto Response que tiene la información de un 
    soup = bs.BeautifulSoup(resp.text, "lxml")
    # encontramos la tabla en el html (objeto soup especifico a wikipedia)
    table = soup.find("table",{"class":"wikitable sortable"})
    # lista vacía para ir agregando los tickers
    tickers = [] 
    # HTML tr = table row; td = table cell
    rows = table.findAll('tr')[1:]
    for row in rows: #para cada columna de la tabla
        # selecciona el texto de todas las celdas
        ticker = row.findAll("td")[ticker_col].text 
        print(ticker)
        # agregar texto de row a lista tickers
        tickers.append(ticker.rstrip("\n"))
    # guardamos como pickle la lista de tickers
    with open(directory+'/'+name,"wb") as pick: # Aqui se selecciona la dirección y nombre del pickle
        pickle.dump(tickers,pick)    
    print(tickers)
    return tickers



#Función para descargar la información de las acciones dados los tickers:
#in: directory_csv = dirección de carpeta para los archivos csv´s
#    name = pickle con los tickers de las acciones del indice

#out: empty
#     realiza un procedimiento para guardar la infomración de las acciones
#     en el directorio corresondiente
    

# /Users/luisguillermopizana/Desktop/Python/Python + Finance/Ticker pickles

#    nombre del pickle buscado (indice de acciones)

# ESTA FUNCIÓN YA ES FUNCIONAL
    
#Esta función vuelve a descargar toda la información de las acciones. 


def get_data_from_yahoo(directory_csv, pickle_path):
    # Vemos si existe el pickle con los tickers
    if os.path.exists(pickle_path):
        # llama a la función save_sp600_tickers() ^
        with open(pickle_path,"rb") as pick:
            tickers = pickle.load(pick)
    else:
        # si existe lo abrimos
        print('No existe el ticker')
    # revisa si esta el folder (en realidad revisa si la direción existe)
    if not os.path.exists(directory_csv):
        os.makedirs(directory_csv)        # si no crea el folder
     
    # seleccionamos fecha de inicio y fin para información
    start = dt.datetime(2010,1,1)
    end = dt.datetime(2021,3,9)
    
    #Para cada acción (ticker) descarga y guarda la información
    for ticker in tickers:
        print(ticker) # si no existe el archivo de información
        try:
            # Si se puede crear un dataFrame con la información -> crearlo
            df = web.DataReader(ticker,"yahoo",start,end)
        except Exception:
            # Si no se puede -> la información no esta en yahoo
                print ('not in yahoo')
        else:
            # crea un archivo csv con dirección: stock_dfs/ticker.csv 
            # ticker.csv es el nombre del archivo en la dirección
            df.to_csv(directory_csv+'/{}.csv'.format(ticker))
    return




# Función para leer un cierto indice de información y realizar un dataFrame
# con la columna deseada. El indice del dataFrame obtenido son las fechas.
# 

#in: pickle_path = dirección del pickle (incluye nombre) del pickle buscado
#    columna = columna sobre la cual se hace la dataFrame final
#    index = columna que se utilizará como indice en común



def compile_data(pickle_path,csv_path, result_path, columna, index):
    # abrimos el archivo pickle como f ( nota: puede ser file)
    with open(pickle_path,"rb") as pick:
        tickers = pickle.load(pick)
        
    # Creamos una data frame vacía
    main_df = pd.DataFrame()
    
    # enumerate(tickers) entrega una tupla con un ticker por numero natural
    for count, ticker in enumerate(tickers):
        try:
            # intenta hacer un csv con la info de una acción 
            df = pd.read_csv(csv_path+'/{}.csv'.format(ticker))
        except Exception:
            print("Stock not available")
        else:
            # Tomo una columna que me interesa y tiro las demas
            
            # El indice van a ser las fechas
            df.set_index(index, inplace=True)
            # A la columna de interes le pongo el nombre del ticker
            df.rename(columns = {"Adj Close": ticker},inplace = True)
            
            # Agrego la columna 
            if main_df.empty:
                main_df = df[ticker]
            else:
                # Agrego la columna al df general con columnas del estilo de distintas acciones
                # main_df+df, manteniendo el indice de ambas, usando una unión de indices (no inner = intersección)
                main_df = pd.merge(main_df,df[ticker],left_index = True, right_index = True, how="outer")
            
            # lleva la cuenta de cuantas veces se esta haciendo esto e imprime cada 10    
            if count %10 == 0:
                print(count)
    main_df = main_df.fillna(0)
    print(main_df.head())
    main_df.to_csv(result_path)
    return main_df






