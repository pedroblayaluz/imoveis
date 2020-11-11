#Preparando o espaco de trabalho
import pandas as pd
import numpy as np
dados_totais = pd.read_csv('data/dados_totais.csv')

#Qual ID teve o maior faturamento?
#ID 83547, com um faturamento total de R$745.000
df_faturamento_total = dados_totais.groupby(['id'])\
                                   .faturamento.sum()\
                                   .reset_index(name='faturamento_total')\
                                   .sort_values(by='faturamento_total',ascending=False)
df_faturamento_total.iloc[0:1]


#Qual ID teve o menor faturamento?
  #As seguintes IDs tiveram um faturamento igual a zero
faturamento_zero = df_faturamento_total['faturamento_total']==0
df_faturamento_total[faturamento_zero][['id']]
df_faturamento_total[faturamento_zero][['id']]\.astype(str).id.str.cat(sep=', ')

#Qual a média de faturamento das IDs?
  #A planilha completa com o faturamento mensal médio por ID está disponível no objeto `id_medias`:
mensal = dados_totais.groupby(["id",'mes'])\
                      .faturamento.sum().reset_index()\
                      .groupby(['id'])['faturamento'].mean()\
                      .reset_index(name='faturamento mensal')
diario = dados_totais.groupby(["id"])\
                      .faturamento.mean()\
                      .reset_index(name='faturamento diário')
id_medias = pd.concat([mensal,diario.iloc[:,1:]],axis=1)
id_medias

#Qual mês apresentou o maior (e o menor) faturamento médio?
  #Janeiro apresentou o maior faturamento médio (R$ 8470) e julho apresentou o menor (R$ 452)
dados_totais.groupby(["id",'mes'])\
                      .faturamento.sum().reset_index()\
                      .groupby(['mes'])['faturamento'].mean()\
                      .reset_index(name='faturamento medio')

#Qual a média de taxa de ocupação para Janeiro? e para Outubro?
#A taxa de ocupacão média para Janeiro é de 55% e para Outubro de 23%. 
taxa_ocupacao = dados_totais.groupby(['id', 'mes'])[['ocupado']]\
                            .agg(['sum','count']).reset_index()
taxa_ocupacao.columns = taxa_ocupacao.columns.map(''.join)
taxa_ocupacao['taxa'] = taxa_ocupacao.ocupadosum / taxa_ocupacao.ocupadocount
ocupacao_media = taxa_ocupacao.groupby('mes')['taxa']\
                              .mean().reset_index()
ocupacao_media[(ocupacao_media.mes == 1) | (ocupacao_media.mes == 10)]
