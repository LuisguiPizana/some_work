#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Mar  9 21:25:37 2021

@author: luisguillermopizana
"""

import pandas as pd
import datetime as dt
import os  #create new directories
import pandas_datareader.data as web
import bs4 as bs
import pickle
import requests

# Importar originales

import data_colection as dc
import ganancia_potencial as gp


#Main

#S&P 600

ticker_path = '/Users/luisguillermopizana/Desktop/Python/Python + Finance/Ticker pickles'


sp_small_caps_url = 'https://en.wikipedia.org/wiki/List_of_S%26P_600_companies'


pickle_name = 'sp_600.pickle'
csv_name = 'sp_600.csv'
csv_path = '/Users/luisguillermopizana/Desktop/Python/Python + Finance/stocks sp600'

#sp_small_caps = dc.save_tickers(sp_small_caps_url, ticker_path,pickle_name)


#Directorio para guardar información de sp600




info_dir = '/Users/luisguillermopizana/Desktop/Python/Python + Finance/stocks sp600'

#dc.get_data_from_yahoo(info_dir,ticker_path+'/'+pickle_name)


#Compilamos la información y hacemos una dataFrame que nos interese

index = 'Date'
adj_close = 'Adj Close'
result_path = '/Users/luisguillermopizana/Desktop/Python'
result_path = result_path+'/Python + Finance/dfs sp600/sp600_joined_adjclose.csv'
#adj_close = dc.compile_data(ticker_path+'/'+pickle_name, csv_path, result_path, adj_close, index)



#Ganancias potenciales
adj_close = pd.read_csv(result_path, index_col = index)

adj_close = adj_close.fillna(-999)

cambios = gp.calcula_desc(adj_close,'2021-03-02','2021-03-09')

mejores = gp.selecciona_mejores(cambios,1.2)

print(mejores)

mejores.to_csv('mejores_provisionales.csv')




#S&P 500
"""
sp_five = 'https://en.wikipedia.org/wiki/List_of_S%26P_500_companies'
pickle_name = 'sp_500.pickle'
csv_name = 'sp_500.csv'
csv_path = '/Users/luisguillermopizana/Desktop/Python/Python + Finance/stocks sp500'
csv_path2 = '/Users/luisguillermopizana/Desktop/Python/Python + Finance/Ticker pickles'
adj_close = 'Adj Close'

index = 'Date'
adj_close = 'Adj Close'
result_path = '/Users/luisguillermopizana/Desktop/Python'
result_path = result_path+'/Python + Finance/dfs sp500/sp500_joined_adjclose.csv'


#sp_five_hundred = dc.save_tickers(sp_five, ticker_path, pickle_name, 0)

#dc.get_data_from_yahoo(csv_path,csv_path2+'/'+pickle_name)

adj_close2 = dc.compile_data(csv_path2+'/'+pickle_name, csv_path, result_path, adj_close, index)

adj_close2 = gp.crecimiento_en_periodo(adj_close2,'2019-06-03','2020-01-31')

adj_close2 = adj_close2.fillna(-999)

cambios = gp.calcula_desc(adj_close2,'2020-01-02','2020-12-29')

mejores = gp.selecciona_mejores(cambios,1.5)

print(mejores)

mejores.to_csv('mejores_provisionales_sp500.csv')
"""