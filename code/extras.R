#Preparando o ambiente de trabalho
setwd("/Users/pedroblayaluz/Dropbox/Science/desafio")
require(ggplot2)
require(ggpubr)
require(tidyverse)
require(viridis)
dados_totais <- read_csv('data/dados_totais.csv')

#Ajeitar o factor mes
dados_totais$mes <- as.factor(dados_totais$mes)
dados_totais <- dados_totais %>%
  mutate(mes = fct_relevel(mes,'6','7','8','9','10','11','12','1')) 
levels(dados_totais$mes) <- c('jun','jul','ago','set','out','nov','dez','jan')

#Criar fator dia da semana
dados_totais$dia <- as.factor(weekdays(dados_totais$data))
levels(dados_totais$dia) <- c('sex','seg','sab','dom','qui','ter','qua')
dados_totais <- dados_totais %>%
  mutate(dia = fct_relevel(dia,'dom','seg','ter','qua','qui','sex','sab')) 

#Adicionando feriados
dados_totais$feriado <- '0'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '07-09')] <- '7set'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '12-10')] <- '12out'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '02-11')] <- '2nov'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '15-11')] <- '15nov'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '25-12')] <- 'natal'
dados_totais$feriado[which(format(dados_totais$data,'%d-%m') == '31-12')] <- 'anonv'
dados_totais$feriado <- as.factor(dados_totais$feriado)
dados_totais <- dados_totais %>%
  mutate(feriado = fct_relevel(feriado,'0','7set','12out','2nov','15nov',
                           'natal','anonv')) 

#GRAFICOS POR VARIAVEL
#Variavel preco
precodia <- dados_totais %>%
  group_by(dia) %>%
  summarise(m_preco=mean(preco,na.rm=T),
            sd = sd(preco, na.rm = TRUE),
            n = sum(!is.na(preco)),
            upper_limit = m_preco + sd/sqrt(n),
            lower_limit = m_preco - sd/sqrt(n)) %>%
  ggplot(aes(x=dia,y=m_preco)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(dia)), linetype=1, color='chartreuse') +
  labs(x='dia da semana',y='Preços') +
  theme_minimal()
precomes <- dados_totais %>%
  group_by(mes) %>%
  summarise(m_preco=mean(preco,na.rm=T),
            sd = sd(preco, na.rm = TRUE),
            n = sum(!is.na(preco)),
            upper_limit = m_preco + sd/sqrt(n),
            lower_limit = m_preco - sd/sqrt(n)) %>%
  ggplot(aes(x=mes,y=m_preco)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(mes)), linetype=1, color='aquamarine3') +
  labs(x='mês',y='') +
  theme_minimal()
precoferiado <- dados_totais %>%
  group_by(feriado) %>%
  summarise(m_preco=mean(preco,na.rm=T),
            sd = sd(preco, na.rm = TRUE),
            n = sum(!is.na(preco)),
            upper_limit = m_preco + sd/sqrt(n),
            lower_limit = m_preco - sd/sqrt(n),
            dia=first(dia)) %>%
  ggplot(aes(x=feriado,y=m_preco)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(feriado)), linetype=1, color='chocolate') +
  geom_text(aes(angle=45,y=550,label=dia),stat='unique', alpha=0.3) +
  labs(x='feriados',y='') +
  theme_minimal()
precos <- ggarrange(precodia,precomes,precoferiado,ncol=3)

#Variavel faturamento
faturamentodia <- dados_totais %>%
  group_by(dia) %>%
  summarise(m_faturamento=mean(faturamento,na.rm=T),
            sd = sd(faturamento, na.rm = TRUE),
            n = sum(!is.na(faturamento)),
            upper_limit = m_faturamento + sd/sqrt(n),
            lower_limit = m_faturamento - sd/sqrt(n)) %>% 
  ggplot(aes(x=dia,y=m_faturamento)) + 
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(dia)), linetype=1,color='chartreuse') +
  labs(x='dia da semana',y='Faturamento') +
  theme_minimal()
faturamentomes <- dados_totais %>%
  group_by(mes) %>%
  summarise(m_faturamento=mean(faturamento,na.rm=T),
            sd = sd(faturamento, na.rm = TRUE),
            n = sum(!is.na(faturamento)),
            upper_limit = m_faturamento + sd/sqrt(n),
            lower_limit = m_faturamento - sd/sqrt(n)) %>%
  ggplot(aes(x=mes,y=m_faturamento)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(mes)), linetype=1, color='aquamarine3') +
  labs(x='mês',y='') +
  theme_minimal()
faturamentoferiado <- dados_totais %>%
  group_by(feriado) %>%
  summarise(m_faturamento=mean(faturamento,na.rm=T),
            sd = sd(faturamento, na.rm = TRUE),
            n = sum(!is.na(faturamento)),
            upper_limit = m_faturamento + sd/sqrt(n),
            lower_limit = m_faturamento - sd/sqrt(n),
            dia=first(dia)) %>%
  ggplot(aes(x=feriado,y=m_faturamento)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(feriado)), linetype=1,color='chocolate') +
  geom_text(aes(angle=45,y=300,label=dia),stat='unique', alpha=0.3) +
  labs(x='feriados',y='Taxa de ocupação') +
  theme_minimal()
faturamentos <- ggarrange(faturamentodia,faturamentomes,faturamentoferiado,ncol=3)
#Variavel taxa de ocupacao
ocupacaodia <- dados_totais %>%
  group_by(dia,id) %>%
  summarise(taxa=sum(ocupado)/length(ocupado)) %>%
  summarise(m_taxa=mean(taxa),
            sd = sd(taxa, na.rm = TRUE),
            n = sum(!is.na(taxa)),
            upper_limit = m_taxa + sd/sqrt(n),
            lower_limit = m_taxa - sd/sqrt(n)) %>%
  ggplot(aes(x=dia, y=m_taxa)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(dia)), linetype=1, color='chartreuse') +
  labs(x='dia',y='Taxa de ocupação') +
  theme_minimal()
ocupacaomes <- dados_totais %>%
  group_by(mes,id) %>%
  summarise(taxa=sum(ocupado)/length(ocupado)) %>%
  summarise(m_taxa=mean(taxa),
            sd = sd(taxa, na.rm = TRUE),
            n = sum(!is.na(taxa)),
            upper_limit = m_taxa + sd/sqrt(n),
            lower_limit = m_taxa - sd/sqrt(n)) %>%
  ggplot(aes(x=mes, y=m_taxa)) +
  geom_errorbar(aes(ymax=upper_limit, ymin=lower_limit), width=0.25,alpha=0.5, linetype=2) + 
  geom_point(shape=21) + geom_line(aes(x=as.numeric(mes)), linetype=1, color='aquamarine3') +
  labs(x='dia',y='Taxa de ocupação') +
  theme_minimal()
ocupacoes <- ggarrange(ocupacaodia,ocupacaomes,ggplot()+ theme_void(), nrow=1)
#Juntando num unico objeto
graficos_por_variavel <- ggarrange(precos,faturamentos, ocupacoes,ncol=1)


#GRAFICOS MULTIVARIAVEL
#Mensal
grafico_mensal <- dados_totais %>%
  group_by(mes,id) %>%
  summarise(taxa=sum(ocupado)/length(ocupado),
            faturamento=mean(faturamento)) %>%
  ggplot(aes(x=mes, y=faturamento)) +
  geom_jitter(aes(color=taxa), size=1,alpha=0.5) +
  theme_minimal() + 
  theme(legend.direction = 'horizontal', legend.key.height =unit(0.1,'cm')) +
  scale_y_continuous(limits=c(0,5000)) + scale_color_gradient(low='red',high='green') +
  labs(x='mês',color='taxa de ocupação      ')
#Semanal
grafico_semanal <- dados_totais %>%
  group_by(dia,id) %>%
  summarise(taxa=sum(ocupado)/length(ocupado),
            faturamento=mean(faturamento)) %>%
  ggplot(aes(x=dia, y=faturamento)) +
  geom_jitter(aes(color=taxa), size=1,alpha=0.5) +
  theme_minimal() +
  scale_y_continuous(limits=c(0,5000))+
  scale_color_gradient(low='red',high='green', limits=c(0,1)) +
  labs(x='dia da semana',y='')

#Juntando num unico objeto
graficos_multivariaveis <- ggarrange(ggarrange(ggplot() + theme_void(),
                                               as_ggplot(get_legend(grafico_mensal)),
                                               nrow=2),
                                     ggarrange(grafico_semanal + theme(legend.position = 'none'),
                                               grafico_mensal + theme(legend.position = 'none'),
                                               ncol=2),
                                     nrow=2, heights=c(1,18))

#DISTRIBUICAO DOS PRECOS
distribuicao_precos <- dados_totais %>% ggplot(aes(x=preco)) +
  geom_area(aes(y = ..count..), stat = "bin", alpha=0.5,
            bins=100,color='black',fill='lightseagreen') +
  scale_x_continuous(n.breaks=10) + theme_minimal() + labs(y='quantidade',x='preço')

#TODOS OS GRAFICOS:
graficos_temporais
graficos_multivariaveis
distribuicao_precos

#REGRESSAO LINEAR
dados_modelo <- dados_totais %>% filter(!preco %in% NA) %>%
  filter(!preco %in% 0)
summary(lm(log(preco) ~ mes + feriado + dia, data=dados_modelo))