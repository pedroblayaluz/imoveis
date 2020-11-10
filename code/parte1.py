#Importando bibliotecas necessarias
from openpyxl import load_workbook
import pandas as pd
import numpy as np

#Criando uma matrix com as cores de 'price-info.xlsx'
wb = load_workbook('price-info.xlsx')
sheet = wb['Sheet1']
col_array = []
for line in sheet.iter_rows():
  row_array = []
  for c in line:
      row_array.append(c.fill.bgColor.rgb)
  col_array.append(row_array)
  
#Juntando as informaçoes de cores e precos
#DataFrame com os precos, IDs e datas
prices_df = pd.read_excel('price-info.xlsx')
#DataFrame com as cores e incluir IDs e datas do outro DataFrame
color_df = pd.DataFrame(np.array(col_array),columns=prices_df.columns)
color_df = color_df.iloc[1:,1:].reset_index(drop=True)
color_df = pd.concat([prices_df.iloc[:,0], color_df], axis=1)
#Unir os dois DataFrames
melt_color = pd.melt(color_df, id_vars='Unnamed: 0', var_name='date', value_name='color')
melt_prices = pd.melt(prices_df, id_vars='Unnamed: 0', var_name='date', value_name='price')
prices_colors = pd.concat([melt_color,melt_prices], axis=1)
prices_colors = prices_colors.loc[:,~prices_colors.columns.duplicated()]
#Criar a variavel ocupado a partir da cor (verde=1, outro=0)
dummies = pd.get_dummies(prices_colors.color)
prices_colors = pd.concat([prices_colors,dummies.FF33CCCC], axis=1)
prices_colors.columns = ['id', 'data', 'cor', 'preco', 'ocupado']
#Criar a variavel faturamento multiplicando ocupado e preco
prices_colors['faturamento'] = prices_colors.preco * prices_colors.ocupado

#Criar a planilha contendo a lista de IDs 
prices_colors['mes'] = pd.DatetimeIndex(prices_colors['data']).month
faturamento_mensal = pd.pivot_table(prices_colors, index=["id"], columns=["mes"], values=["faturamento"], aggfunc=np.sum)
faturamento_mensal.columns = ['jan', 'feb', 'jun', 'jul', 'ago','set','out','nov','dez']
faturamento_mensal = faturamento_mensal[['jun','jul','ago','set','out','nov','dez']] #Reordenando e tirando fevereiro por ter poucos dados

#Salvando arquivo
faturamento_mensal.to_csv('data/faturamento_mensal.csv')
prices_colors.to_csv('data/prices_colors.csv')
