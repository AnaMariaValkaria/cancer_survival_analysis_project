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


# Verificando se não há nenhum óbito anterior ao diagnóstico
# Comparação entre data de diagnóstico e data de óbito
sum(
  dados_ovario$data_obito > dados_ovario$data_diagnostico,
  na.rm = TRUE  #Ignora os valores ausentes!
) #Datas de óbito > Datas do Diagnóstico

sum(
  dados_ovario$data_obito == dados_ovario$data_diagnostico,
  na.rm = TRUE
) #Datas do óbito == Datas do Diagnóstico

sum(
  dados_ovario$data_obito < dados_ovario$data_diagnostico,
  na.rm = TRUE
) #Datas do óbito < Datas do Diagnóstico


# Existe algum paciente se o último contato foi registrado antes do diagnóstico?
# Comparação entre data do diagnóstico e a data do último contato
sum(
  dados_ovario$data_ultimo_contato<dados_ovario$data_diagnostico,
  na.rm = TRUE
) #Datas do último contato < datas do diagnóstico

sum(
  dados_ovario$data_ultimo_contato==dados_ovario$data_diagnostico,
  na.rm = TRUE
) #Datas do último contato == datas do diagnóstico

sum(
  dados_ovario$data_ultimo_contato>dados_ovario$data_diagnostico,
  na.rm = TRUE
) #Datas do último contato > datas do diagnóstico


# Vizualizando os 21 casos de data de último contato < data do diagnóstico
# Salvando numa variável para exportar
inconsistencias <- dados_ovario[
  !is.na(dados_ovario$data_ultimo_contato) &
  dados_ovario$data_ultimo_contato < dados_ovario$data_diagnostico,
  c(
    "Código do Paciente",
    "Nome do RCBP",
    "Status Vital",
    "data_diagnostico",
    "data_ultimo_contato",
    "data_obito"
  )
]

# Vendo se tá tudo certo:
View(inconsistencias)
nrow(inconsistencias)
colSums(is.na(inconsistencias))

# Exportando...
write.csv2(inconsistencias,"inconsistencias_ovario.csv",row.names = FALSE)

inconsistencias$dias_diagnostico_ultimo_contato <-
  as.numeric(
    inconsistencias$data_ultimo_contato -
      inconsistencias$data_diagnostico
  )
inconsistencias[, c(
  "Código do Paciente",
  "data_diagnostico",
  "data_ultimo_contato",
  "dias_diagnostico_ultimo_contato",
  "data_obito"
)]

# Quantos dos 21 casos tem data de óbito?
table(
  is.na(inconsistencias$data_obito)
)  #A data do óito é vazio? SIM=TRUE


# Analizando os 9 casos com data de óbito dos 21 casos anteriores
inconsistencias[
  !is.na(inconsistencias$data_obito),
  c(
    "Código do Paciente",
    "Nome do RCBP",
    "Status Vital",
    "data_diagnostico",
    "data_ultimo_contato",
    "data_obito"
  )
]

inconsistencias$dias_diagnostico_obito <-
  as.numeric(
    inconsistencias$data_obito -
      inconsistencias$data_diagnostico
  )
inconsistencias[
  !is.na(inconsistencias$data_obito),
  c(
    "Código do Paciente",
    "data_diagnostico",
    "data_obito",
    "dias_diagnostico_obito"
  )
]


# Investigando os 12 pacientes que não possuem data de óbito dos 21 casos anteriores
inconsistencias[
  is.na(inconsistencias$data_obito),
  c(
    "Código do Paciente",
    "Nome do RCBP",
    "Status Vital",
    "data_diagnostico",
    "data_ultimo_contato",
    "data_obito"
  )
]

table(
  inconsistencias[
    is.na(inconsistencias$data_obito),
    "Status Vital"
  ],
  useNA = "ifany"
)
inconsistencias[
  is.na(inconsistencias$data_obito) &
    inconsistencias$`Status Vital` == "VIVO",
  c(
    "Código do Paciente",
    "Status Vital",
    "data_diagnostico",
    "data_ultimo_contato"
  )
]

inconsistencias[
  is.na(inconsistencias$data_obito) &
    inconsistencias$`Status Vital` == "SEM INFORMAÇÃO",
  c(
    "Código do Paciente",
    "Status Vital",
    "data_diagnostico",
    "data_ultimo_contato"
  )
]


# Procurando datas ausentes em data_diagnostico
sum(is.na(dados_ovario$data_diagnostico))

# Procurando data de óbito antes da data do diagnóstico
sum(
  dados_ovario$data_obito<dados_ovario$data_diagnostico,
  na.rm = TRUE
)

# Procurando por óbito no mesmo dia do diagnóstico
sum(
  dados_ovario$data_obito==dados_ovario$data_diagnostico,
  na.rm = TRUE
)

# Procurando por data de óbito depois da data do diagnóstico
sum(
  dados_ovario$data_obito>dados_ovario$data_diagnostico,
  na.rm = TRUE
)

# Último contato posterior ao diagnóstico
sum(
  dados_ovario$data_ultimo_contato >
    dados_ovario$data_diagnostico,
  na.rm = TRUE
)

# Óbito anterior ao último contato
sum(
  dados_ovario$data_obito<dados_ovario$data_ultimo_contato,
  na.rm = TRUE
)

inconsistencia2<-dados_ovario[
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_obito < dados_ovario$data_ultimo_contato,
  c(
    "Código do Paciente",
    "Status Vital",
    "data_diagnostico",
    "data_obito",
    "data_ultimo_contato",
    "Tipo do Obito"
  )
];inconsistencia2


# Auditoria sa relação data de óbito e data do último contato
# 1. Óbito antes do último contato
obito_antes_contato <- sum(
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_obito < dados_ovario$data_ultimo_contato
)

# 2. Óbito na mesma data do último contato
obito_igual_contato <- sum(
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_obito == dados_ovario$data_ultimo_contato
)

# 3. Óbito depois do último contato
obito_depois_contato <- sum(
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_obito > dados_ovario$data_ultimo_contato
)

# 4. Óbito e último contato ambos preenchidos
ambas_datas <- sum(
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato)
)

# 5. Mostrar os resultados
data.frame(
  relacao = c(
    "Óbito antes do último contato",
    "Óbito igual ao último contato",
    "Óbito depois do último contato",
    "Óbito e último contato preenchidos"
  ),
  n = c(
    obito_antes_contato,
    obito_igual_contato,
    obito_depois_contato,
    ambas_datas
  )
)


# DIFERENÇA EM DIAS ENTRE ÓBITO E ÚLTIMO CONTATO
dif_obito_contato <- as.numeric(
  dados_ovario$data_ultimo_contato -
    dados_ovario$data_obito
)

summary(
  dif_obito_contato[
    !is.na(dados_ovario$data_obito) &
      !is.na(dados_ovario$data_ultimo_contato)
  ]
)

# CASOS EM QUE ÚLTIMO CONTATO É POSTERIOR AO ÓBITO
dados_ovario[
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_ultimo_contato >
    dados_ovario$data_obito,
  c(
    "Código do Paciente",
    "Nome do RCBP",
    "Status Vital",
    "data_diagnostico",
    "data_obito",
    "data_ultimo_contato",
    "Tipo do Obito"
  )
]

# ============================================================
# INVESTIGAÇÃO DOS 66 CASOS:
# ÚLTIMO CONTATO ANTERIOR AO ÓBITO
# ============================================================

# 1. Criar a diferença em dias:
# positivo = último contato depois do óbito
# zero     = mesma data
# negativo = último contato antes do óbito

dif_obito_contato <- as.numeric(
  dados_ovario$data_ultimo_contato -
    dados_ovario$data_obito
)

# ------------------------------------------------------------
# 2. Resumo apenas dos 66 casos
# ------------------------------------------------------------

summary(
  dif_obito_contato[
    !is.na(dados_ovario$data_obito) &
      !is.na(dados_ovario$data_ultimo_contato) &
      dif_obito_contato < 0
  ]
)

# ------------------------------------------------------------
# 3. Quantos casos existem para cada intervalo de tempo?
# ------------------------------------------------------------

table(
  dif_obito_contato[
    !is.na(dados_ovario$data_obito) &
      !is.na(dados_ovario$data_ultimo_contato) &
      dif_obito_contato < 0
  ]
)

# ------------------------------------------------------------
# 4. Mostrar os 66 casos completos
# ------------------------------------------------------------

inconsistencias3 <- dados_ovario[
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dif_obito_contato < 0,
  c(
    "Código do Paciente",
    "Nome do RCBP",
    "Status Vital",
    "data_diagnostico",
    "data_obito",
    "data_ultimo_contato",
    "Tipo do Obito"
  )
]

inconsistencias3$dias_contato_antes_obito <-
  as.numeric(
    inconsistencias3$data_ultimo_contato -
      inconsistencias3$data_obito
  )

inconsistencias3

# ============================================================
# STATUS VITAL DOS 66 CASOS
# EM QUE O ÚLTIMO CONTATO OCORREU ANTES DO ÓBITO
# ============================================================

table(
  dados_ovario$`Status Vital`[
    !is.na(dados_ovario$data_obito) &
      !is.na(dados_ovario$data_ultimo_contato) &
      dados_ovario$data_ultimo_contato <
      dados_ovario$data_obito
  ],
  useNA = "ifany"
)

# ============================================================
# QUANTOS DOS 66 TAMBÉM ESTÃO ENTRE OS 21 CASOS
# COM ÚLTIMO CONTATO ANTERIOR AO DIAGNÓSTICO?
# ============================================================

sum(
  !is.na(dados_ovario$data_obito) &
    !is.na(dados_ovario$data_ultimo_contato) &
    dados_ovario$data_ultimo_contato <
    dados_ovario$data_diagnostico
)

dados_ovario[
  dados_ovario$`Código do Paciente` %in%
    inconsistencia2$`Código do Paciente`,
]

table(
  format(
    inconsistencias$data_diagnostico,
    "%Y"
  )
)

table(
  format(
    inconsistencia2$data_diagnostico,
    "%Y"
  )
)


# Auditoria para verificar a disponibilidade de se criar o vetor censura
# Status x Data de óbito e último contato
with(
  dados_ovario,
  table(
    `Status Vital`,
    !is.na(data_obito),
    !is.na(data_ultimo_contato)
  )
)

