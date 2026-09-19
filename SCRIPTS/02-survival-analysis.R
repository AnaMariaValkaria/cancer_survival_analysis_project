# =============================================
# ANÁLISE DE SOBREVIVÊNCIA - CÂNCER DE OVÁRIO
# =============================================


# 1. Carregando o banco já preparado
library(tidyverse)
library(survival)

# Selecionar os casos com classificação inequívoca
dados_sobrevida <- dados_ovario[
  (
    dados_ovario$`Status Vital` == "MORTO" &
      !is.na(dados_ovario$data_obito)
  ) |
    (
      dados_ovario$`Status Vital` == "VIVO" &
        is.na(dados_ovario$data_obito) &
        !is.na(dados_ovario$data_ultimo_contato)
    ),
]

# Conferindo
dim(dados_sobrevida)

table(dados_sobrevida$`Status Vital`)



# 2. Criando os vetores da análise de sobrevivência
# 1 <- evento(MORTE) = data de óbito
# 0 <- censura(VIVO) = sem data de óbito + data do último contato
# tempo = data final - data de início (diagnóstico)
# data final pode ser: data do óbito ou data do último contato

# 2.1 Criando o vetor evento
dados_sobrevida$evento<-ifelse(
  dados_sobrevida$`Status Vital`=="MORTO",
  1,
  0
)

table(dados_sobrevida$evento)



# 2.2 Criando a data final
dados_sobrevida$data_final<-ifelse(
  dados_sobrevida$evento==1,
  dados_sobrevida$data_obito,
  dados_sobrevida$data_ultimo_contato
)  # Sai a data bruta, perde formato Date!

# Convertendo para formato Data
dados_sobrevida$data_final<-as.Date(dados_sobrevida$data_final,origin = "1970-01-01")
View(dados_sobrevida)

head(
  dados_sobrevida[
    ,
    c(
      "Status Vital",
      "data_diagnostico",
      "data_obito",
      "data_ultimo_contato",
      "evento",
      "data_final"
    )
  ]
)



# 2.3 Criando o vetor tempo
#tempo<-as.numeric(data_final-data_diagnostico)
#formato difftime
dados_sobrevida$tempo<-as.numeric(
  dados_sobrevida$data_final - dados_sobrevida$data_diagnostico
)

# Conferindo...
summary(dados_sobrevida$tempo)
sum(dados_sobrevida$tempo<0)
sum(dados_sobrevida$tempo==0)

# Quem são os 3 casos com
# data final < data diagnóstico ?
dados_sobrevida[
  dados_sobrevida$tempo<0,
  c(
    "Código do Paciente",
    "Status Vital",
    "data_diagnostico",
    "data_obito",
    "data_ultimo_contato",
    "evento",
    "data_final",
    "tempo"
  )
]

# REESCREVENDO OS DADOS_SOBREVIDA
dados_sobrevida<-dados_sobrevida[
  dados_sobrevida$tempo >= 0,
]

# Conferindo
dim(dados_sobrevida)
table(dados_sobrevida$evento)
summary(dados_sobrevida$tempo)



# 3. Criar objeto Surv()
#tempo = dias desde o diagnóstico até óbito ou último contato;
#evento = 1 = paciente morreu;
#evento = 0 = paciente foi censurado.
obj_surv<-Surv(
  time = dados_sobrevida$tempo,
  event = dados_sobrevida$evento
);obj_surv

summary(obj_surv)



# 6. Análise descritiva

summary(analise)

# 7. Kaplan-Meier

analise<-surfit(Surv(tempo,status)~1,data=dados_ovario);analise

# 8. Comparações entre grupos

teste_logrank_ovario<-survdiff(Surv(tempo,status)~1,data=dados_ovario);teste_logrank_ovario

# 9. Modelo de Cox

# 10. Avaliação do modelo

