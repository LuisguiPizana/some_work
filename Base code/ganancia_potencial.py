#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 31 17:18:10 2020

@author: luisguillermopizana
"""
import pandas as pd


def calcula_desc(df,inicio,fin):
    ratio = {}
    for elem in list(df):
        print(df.loc[inicio,elem])
        try:
            dif = df.loc[inicio,elem]/df.loc[fin,elem]
        except Exception:
            print("Stock not available")
        else:
            ratio[elem]=dif
    dataframe = pd.DataFrame(ratio,index = [0])
    return dataframe

#Esta función busca eliminar las acciones que disminuyeron su valor en 
#el periodo establecido

#ES FUNCIONAL pero se podría establecer un cierto crecimiento

def crecimiento_en_periodo(df,inicio,fin):
    for elem in list(df):
        if (df.loc[inicio,elem] > df.loc[fin,elem]):
            df = df.drop(elem, axis = 1)
    return df



def selecciona_mejores(cambios_df,param):
    aux = cambios_df
    for elem in list(cambios_df):
        if aux.loc[0,elem] < param:
            aux = aux.drop(elem,axis=1)
    return aux