#================================
# 01 - Initial Data Exploration 
#================================


# Arquivo existe?

file.exists("/home/oraculo/Documentos/UEPB_2026jun28/CLEANDERSON/SURVIVAL/SURVIVAL_PROJECTS/CANCER_PROJECT/DATA/cancer-minas-gerais.csv")

# Detectando a codificação correta
caminho<-("/home/oraculo/Documentos/UEPB_2026jun28/CLEANDERSON/SURVIVAL/SURVIVAL_PROJECTS/CANCER_PROJECT/DATA/cancer-minas-gerais.csv")

# Executa o comando do Linux 'file' para checar o encoding
system(paste("file -i", shQuote(caminho)), intern = TRUE)

# Importando a base
dados_cancer<-read.csv2(
  "/home/oraculo/Documentos/UEPB_2026jun28/CLEANDERSON/SURVIVAL/SURVIVAL_PROJECTS/CANCER_PROJECT/DATA/cancer-minas-gerais.csv",
  check.names = FALSE,
  encoding = "latin1"
)

# Verificando a dimensão:
dim(dados_cancer)

# Conferindo os nomes das colunas:
names(dados_cancer)

# Descobrindo a estrutura das variáveis:
str(dados_cancer)


# Qual código identifica o câncer de ovário?

# Descrição da Doença
table(dados_cancer$`Descrição da Doenca`,useNA = "ifany")

#useNA = "ifany" (Se existir algum): O R só exibirá uma categoria NA no resultado da tabela se houver pelo menos um valor ausente na coluna. Se a coluna estiver 100% preenchida, o NA não aparece na saída.
#useNA = "always" (Sempre): O R exibirá a contagem de NA mesmo se o resultado for 0 (útil quando você precisa confirmar explicitamente que não há dados faltantes).
#useNA = "no" (Padrão do R): O R ignora e esconde totalmente os valores NA, o que pode fazer você achar que a base está completa quando na verdade há dados faltando.

# Código da Doença
table(dados_cancer$`Código da Doenca`,useNA = "ifany")

# Topografia
# É usada para descrever a localização exata e a posição de um orgão, tecido ou lesão no corpo humano.
unique(
  dados_cancer$`Código da Topografia`[
    grepl("OVARIO",dados_cancer$`Descrição da Topografia`,
          ignore.case = TRUE)
  ])
#unique:elimina tdas as duplicatas.
#grep:procura o txt "tal" dentro das col.

table(
  dados_cancer$`Código da Topografia`[
    grepl("OVARIO",dados_cancer$`Descrição da Topografia`)
  ]
)


# Criando uma lista só de câncer de ovário
dados_ovario<-dados_cancer[
  dados_cancer$`Código da Topografia`=="C569",
]
View(dados_ovario)

# Número de obs e variáveis:
dim(dados_ovario)

# Sexo: esperamos que a seleção seja coerente com a localização anatômica estudada.
table(dados_ovario$Sexo,useNA = "ifany")

# Quantos casos na city tal?
# RCBP = Registro de Câncer na Base Populacional (cidade)
table(dados_ovario$`Nome do RCBP`,useNA = "ifany")


# Quantos desses 2.473 possuem informação suficiente para calcular o tempo de sobrevivência e definir evento/censura?
# Analizando:
# Status Vital
# Data de Diagnostico
# Data do Óbito
# Data de Último Contato

table(dados_ovario$`Status Vital`,useNA = "ifany")

# Conferindo os 917 valores em branco
# Mostra os textos escritos em aspas
unique(dados_ovario$`Status Vital`)
# Há algum NA na coluna?
table(is.na(dados_ovario$`Status Vital`))


# ========= # =========
# Verificando as datas
# ========= # =========

# Data do diagnóstico
table(dados_ovario$`Data de Diagnostico`=="",useNA = "ifany")

# Data do óbito
table(dados_ovario$`Data do Óbito`=="",useNA = "ifany")

# Data de último contato
table(dados_ovario$`Data de Último Contato`=="",useNA="ifany")

# Tabela Status Vital e Data do óbito
table(
  dados_ovario$`Status Vital`,
  dados_ovario$`Data do Óbito`=="",
  #A data do óbito é igual a vazio? TRUE=vazio
  useNA = "ifany"
)

# Tabela de Status Vital e Data do Último Contato
table(
  dados_ovario$`Status Vital`,
  dados_ovario$`Data de Último Contato`=="",
  #A data do último contato é igual a vazio? TRUE=vazio
  useNA="ifany"
)

# Quando não existe o último contato, existe óbito?
# Data de Último Contato x Data do Obito
table(
  dados_ovario$`Data de Último Contato`=="",
  dados_ovario$`Data do Óbito`=="",
  #A data do óbito é igua a vazio? TRUE=vazio
  useNA = "ifany"
)

# Status Vital x Último Contato x Óbito
table(
  dados_ovario$`Status Vital`,
  dados_ovario$`Data de Último Contato`=="",
  #A data do último contato é igual a vazio?
  dados_ovario$`Data do Óbito`=="",
  #A data do óbito é igual a vazio?
  useNA="ifany"
)


# Será que existe problemas cronológicos?
# Como data de óbito anterior à data de diagnóstico!
# Criando cópia das datas para analizar.

# Só vizualiza, não cria os objetos.
View(data.frame(
  diagnostico    = as.Date(dados_ovario$`Data de Diagnostico`, format = "%d/%m/%Y"),
  obito          = as.Date(dados_ovario$`Data do Óbito`, format = "%d/%m/%Y"),
  ultimo_contato = as.Date(dados_ovario$`Data de Último Contato`, format = "%d/%m/%Y")
))

# Criando 3 novas colunas em dados_ovário
# Precisa criar os objetos para fazer o sum!
dados_ovario$data_diagnostico <- as.Date(
  dados_ovario$`Data de Diagnostico`,
  format = "%d/%m/%Y"
)

dados_ovario$data_obito <- as.Date(
  dados_ovario$`Data do Óbito`,
  format = "%d/%m/%Y"
)

dados_ovario$data_ultimo_contato <- as.Date(
  dados_ovario$`Data de Último Contato`,
  format = "%d/%m/%Y"
)

# Conferindo os 20 primeiros dados
head(
  dados_ovario[, c(
    'data_diagnostico',
    'data_obito',
    'data_ultimo_contato'
  )],20
)


# Existe data de diagnóstico?
sum(!is.na(dados_ovario$data_diagnostico))
# Não existe data de diagnóstico?
sum(is.na(dados_ovario$data_diagnostico))

# Existe data de óbito?
sum(!is.na(dados_ovario$data_obito))
# Não existe data de óbito?
sum(is.na(dados_ovario$data_obito))

# Existe data de último contato?
sum(!is.na(dados_ovario$data_ultimo_contato))
#Não existe data de último contato?
sum(is.na(dados_ovario$data_ultimo_contato))


# Pegando os sum e colocando tudo em uma tabela
data.frame(
  variavel=c(
    'data_diagnostico',
    'data_de_obito',
    'data_de_ultimo_contato'
  ),
  preenchidas=c(
    sum(!is.na(dados_ovario$data_diagnostico)),
    sum(!is.na(dados_ovario$data_obito)),
    sum(!is.na(dados_ovario$data_ultimo_contato))
  ),
  ausentes=c(
    sum(is.na(dados_ovario$data_diagnostico)),
    sum(is.na(dados_ovario$data_obito)),
    sum(is.na(dados_ovario$data_ultimo_contato))
  )
)
