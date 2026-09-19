# Análise dos Dados

Temos 207.434 observações de 37 variáveis. Sendo elas:

 [1] "Código do Paciente"
 [2] "Nome do RCBP"
 [3] "Sexo"
 [4] "Data de Nascimento"
 [5] "Idade"
 [6] "Raca/Cor"
 [7] "Nacionalidade"
 [8] "Naturalidade Estado"
 [9] "Naturalidade"
[10] "Grau de Instrução"
[11] "Estado Civil"
[12] "Código Profissão"
[13] "Nome Profissão"
[14] "Estado Endereço"
[15] "Cidade Endereço"
[16] "Descrição da Topografia"
[17] "Código da Topografia"
[18] "Descrição da Morfologia"
[19] "Código da Morfologia"
[20] "Descrição da Doenca"
[21] "Código da Doenca"
[22] "Descrição da Doenca Infantil"
[23] "Código da Doenca Infantil"
[24] "Descrição da Doenca Adulto Jovem"
[25] "Código da Doenca Adulto Jovem"
[26] "Indicador de Caso Raro"
[27] "Meio de Diagnostico"
[28] "Extensão"
[29] "Lateralidade"
[30] "Estadiamento"
[31] "TNM"
[32] "Status Vital"
[33] "Tipo do Obito"
[34] "Data do Óbito"
[35] "Data de Último Contato"
[36] "Data de Diagnostico"
[37] "Metástase à distância"

Na base Minas Gerais, existem 2.473 registros com topografia descrita como "OVARIO, SOE" e código de topografia C569.

Dos 2.473 registros de câncer de ovário identificados pela topografia C569, 2.391 (96,7%) são provenientes do RCBP de Belo Horizonte e 82 (3,3%) do RCBP de Poços de Caldas.

Quantos desses 2.473 possuem informação suficiente para calcular o tempo de sobrevivência e definir evento/censura?


> # Data do diagnóstico
> table(dados_ovario$`Data de Diagnostico`=="",useNA = "ifany")

FALSE
 2473

 Isso significa que os 2.473 casos de ovário possuem uma data de diagnóstico preenchida.


> # Data do óbito
> table(dados_ovario$`Data do Óbito`=="",useNA = "ifany")

FALSE  TRUE
 1418  1055

 Portanto:

1.418 têm data de óbito;
1.055 estão sem data de óbito.


> # Data de último contato
> table(dados_ovario$`Data de Último Contato`=="",useNA="ifany")

FALSE  TRUE
 1392  1081

 Temos:

1.392 com data de último contato;
1.081 sem data de último contato.


> # Tabela Status Vital e Data do óbito
> table(
+   dados_ovario$`Status Vital`,
+   dados_ovario$`Data do Óbito`=="",
+   #A data do óbito é igual a vazio? TRUE=vazio
+   useNA = "ifany"
+ )

                 FALSE TRUE
                   579  338
  MORTO            761    0
  SEM INFORMAÇÃO    72  212
  VIVO               6  505


- Em VIVO temos 505 registros sem data de óbito. E 6 com data de óbito????
- Em SEM INFORMAÇÃO temos 212 pacientes sem data ed óbito. E 72 com data de óbito???
- Em MORTES temos 0 sem data de óbito e 761 com data de óbito. Todos os mortos estão com suas datas.
- Em BRANCO temos 338 sem data de óbito. E 579 com data de óbito? Então porque está em branco o Status Vital?

O que significa o branco em Status Vital? Já que os registros sem informação estão como 'SEM INFORMAÇÃO'! O sem informação é perda de contato? Como pode ser perda de contato se alguns tem data de óbito? Então, desistiram do tratamento?????

IR ATRÁS DA DOCUMENTAÇÃO.


> # Tabela de Status Vital e Data do Último Contato
> table(
+   dados_ovario$`Status Vital`,
+   dados_ovario$`Data de Último Contato`=="",
+   #A data do último contato é igual a vazio? TRUE=vazio
+   useNA="ifany"
+ )

                 FALSE TRUE
                     0  917
  MORTO            727   34
  SEM INFORMAÇÃO   158  126
  VIVO             507    4

- Os em BRANCO todos não tem último contato. Já sabemos o que são os BRANCO, perda de contato.
- Os de MORTE tem 34 casos de perda de contato. Então como sabe a morte?
- Os SEM INFORMAÇÃO temos 126 de perda do último contato. E 158 não.
- Do VIVO só 4 perdas do último contato.


> # Quando não existe o último contato, existe óbito?
> # Data de Último Contato x Data do Obito
> table(
+   dados_ovario$`Data de Último Contato`=="",
+   dados_ovario$`Data do Óbito`=="",
+   #A data do óbito é igua a vazio? TRUE=vazio
+   useNA = "ifany"
+ )

        FALSE TRUE
  FALSE   746  646
  TRUE    672  409

1. 746
Tem data de último contato + data de óbito.
São registros em que temos as duas informações.

2. 646
Tem data de último contato, mas não tem data de óbito.
Aqui existe uma informação de acompanhamento, mas não há data de óbito registrada.

3. 672
Não tem data de último contato, mas tem data de óbito.
Aqui está a resposta para aquela sua pergunta anterior:
“Como sabe que morreu se não tem último contato?”
Porque existe data de óbito. O último contato não precisa necessariamente estar preenchido para existir um registro de óbito.

4. 409
Não tem data de último contato nem data de óbito.

Esse é o grupo que merece nossa maior atenção.


2.473/2.473 têm data de diagnóstico.
1.418/2.473 têm data de óbito e 1.055 não têm.
1.392/2.473 têm data de último contato e 1.081 não têm.


> # Comparação entre data de diagnóstico e data de óbito
> sum(
+   dados_ovario$data_obito > dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas de óbito > Data do Diagnóstico
[1] 962
> sum(
+   dados_ovario$data_obito == dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas do óbito == Datas do Diagnóstico
[1] 456
> sum(
+   dados_ovario$data_obito < dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas do óbito < Datas do Diagnóstico
[1] 0

Todos os óbitos possuem uma relação cronológica válida com a data de diagnóstico.



# Existe algum paciente se o último contato foi registrado antes do diagnóstico?
> # Comparação entre data do diagnóstico e a data do último contato
> sum(
+   dados_ovario$data_ultimo_contato<dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas do último contato < datas do diagnóstico
[1] 21
> sum(
+   dados_ovario$data_ultimo_contato==dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas do último contato == datas do diagnóstico
[1] 750
> sum(
+   dados_ovario$data_ultimo_contato>dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ ) #Datas do último contato > datas do diagnóstico
[1] 621

- 21 pacientes apresentam uma data de último contato anterior à data de diagnóstico! Inconsistência cronológica!

em todos os 21, o último contato está exatamente 1 dia antes do diagnóstico;
portanto, não parece haver uma variedade aleatória de datas inconsistentes;
em 9 casos, há data de óbito;
em 12 casos, a data de óbito está ausente;
e, nos casos com óbito, em vários deles o óbito coincide exatamente com a data de diagnóstico.
não encontramos nenhum caso em que o último contato esteja vários dias ou meses antes: todos apresentam exatamente −1 dia.

O fato de a data de último contato ser 1 dia antes do diagnóstico não impede necessariamente a análise de sobrevivência quando existe uma data de óbito posterior.

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

Dos 9 pacientes:

8 casos tiveram diagnóstico e óbito no mesmo dia → 0 dias;
1 caso teve óbito 106 dias após o diagnóstico;
nenhum teve óbito antes do diagnóstico.


> # Investigando os 12 pacientes que não possuem data de óbito dos 21 casos anteriores
> inconsistencias[
+   is.na(inconsistencias$data_obito),
+   c(
+     "Código do Paciente",
+     "Nome do RCBP",
+     "Status Vital",
+     "data_diagnostico",
+     "data_ultimo_contato",
+     "data_obito"
+   )
+ ]
       Código do Paciente        Nome do RCBP   Status Vital
72894              857988 RCBP BELO HORIZONTE SEM INFORMAÇÃO
94602              992843 RCBP BELO HORIZONTE SEM INFORMAÇÃO
97764             1048598 RCBP BELO HORIZONTE SEM INFORMAÇÃO
99406             1043245 RCBP BELO HORIZONTE SEM INFORMAÇÃO
99417             1043820 RCBP BELO HORIZONTE SEM INFORMAÇÃO
101801            1035034 RCBP BELO HORIZONTE SEM INFORMAÇÃO
103854            1042391 RCBP BELO HORIZONTE SEM INFORMAÇÃO
110465            1106329 RCBP BELO HORIZONTE SEM INFORMAÇÃO
112789            1118471 RCBP BELO HORIZONTE           VIVO
114219            1116416 RCBP BELO HORIZONTE SEM INFORMAÇÃO
117597            1151733 RCBP BELO HORIZONTE           VIVO
122956            1155617 RCBP BELO HORIZONTE           VIVO
       data_diagnostico data_ultimo_contato data_obito
72894        2009-11-26          2009-11-25       <NA>
94602        2011-01-15          2011-01-14       <NA>
97764        2012-12-26          2012-12-25       <NA>
99406        2012-02-16          2012-02-15       <NA>
99417        2012-02-25          2012-02-24       <NA>
101801       2012-12-26          2012-12-25       <NA>
103854       2012-02-01          2012-01-31       <NA>
110465       2013-02-05          2013-02-04       <NA>
112789       2013-11-25          2013-11-24       <NA>
114219       2013-11-12          2013-11-11       <NA>
117597       2014-01-02          2014-01-01       <NA>
122956       2014-01-22          2014-01-21       <NA>

Dos 12:

9 têm Status Vital = SEM INFORMAÇÃO;
3 têm Status Vital = VIVO;
todos têm o último contato exatamente 1 dia antes do diagnóstico.

| Situação                   | Nº casos | Padrão                                    |
| -------------------------- | -------: | ----------------------------------------- |
| Com óbito                  |        9 | 8 com diagnóstico = óbito; 1 com 106 dias |
| Sem óbito + VIVO           |        3 | último contato = diagnóstico − 1 dia      |
| Sem óbito + SEM INFORMAÇÃO |        9 | último contato = diagnóstico − 1 dia      |
| **Total**                  |   **21** | **todos = −1 dia no último contato**      |


Temos um achado objetivo:

Em 21 de 2.473 pacientes com câncer de ovário, a Data de Último Contato é exatamente um dia anterior à Data de Diagnóstico.

E sabemos que:

9 desses 21 possuem data de óbito;
8 morreram na própria data do diagnóstico;
1 morreu 106 dias depois;
3 estão classificados como VIVO;
9 estão como SEM INFORMAÇÃO;
nenhum dos 9 óbitos ocorreu antes do diagnóstico.


> # Procurando datas ausentes em data_diagnostico
> sum(is.na(dados_ovario$data_diagnostico))
[1] 0

> # Procurando data de óbito antes da data do diagnóstico
> sum(
+   dados_ovario$data_obito<dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ )
[1] 0

# Procurando por óbito no mesmo dia do diagnóstico
> sum(
+   dados_ovario$data_obito==dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ )
[1] 456

Isso representa:

$$ \frac{456}{1418}\times100 \approx 32,2\% $$

Ou seja, entre os 1.418 pacientes com data de óbito registrada, cerca de 32,2% tiveram diagnóstico e óbito registrados no mesmo dia.

# Procurando por data de óbito depois da data do diagnóstico
> sum(
+   dados_ovario$data_obito>dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ )
[1] 962


962 pacientes tiveram óbito após o diagnóstico;
456 pacientes tiveram óbito no mesmo dia do diagnóstico;
0 pacientes tiveram óbito antes do diagnóstico.

Como 962 + 456 = 1.418, isso fecha exatamente com o número de pacientes que possuem data de óbito.

> # Último contato posterior ao diagnóstico
> sum(
+   dados_ovario$data_ultimo_contato >
+     dados_ovario$data_diagnostico,
+   na.rm = TRUE
+ )
[1] 621

| Relação entre as datas                   | Nº de pacientes |
| ---------------------------------------- | --------------: |
| Último contato **antes** do diagnóstico  |          **21** |
| Último contato **igual** ao diagnóstico  |         **750** |
| Último contato **depois** do diagnóstico |         **621** |
| **Total com último contato**             |       **1.392** |


> # Óbito anterior ao último contato
> sum(
+   dados_ovario$data_obito<dados_ovario$data_ultimo_contato,
+   na.rm = TRUE
+ )
[1] 2
> inconsistencia2<-dados_ovario[
+   !is.na(dados_ovario$data_obito) &
+     !is.na(dados_ovario$data_ultimo_contato) &
+     dados_ovario$data_obito < dados_ovario$data_ultimo_contato,
+   c(
+     "Código do Paciente",
+     "Status Vital",
+     "data_diagnostico",
+     "data_obito",
+     "data_ultimo_contato",
+     "Tipo do Obito"
+   )
+ ];inconsistencia2
       Código do Paciente Status Vital data_diagnostico data_obito
169636            1446276        MORTO       2018-05-17 2021-09-16
181146            1311436        MORTO       2017-12-07 2018-01-26
       data_ultimo_contato Tipo do Obito
169636          2021-09-19        CÂNCER
181146          2018-02-15        CÂNCER

Foram identificados 2 registros (0,08%) nos quais a data de último contato é posterior à data de óbito. Ambos apresentam status vital "MORTO" e tipo de óbito "CÂNCER".


O que já fechamos na auditoria

Temos:

2.473 pacientes com câncer de ovário;
2.473 com data de diagnóstico;
761 com Status Vital = MORTO e data de óbito → candidatos a evento = 1;
501 com Status Vital = VIVO, sem óbito e com último contato → candidatos a censura = 0;
1.201 registros com situação ambígua (SEM INFORMAÇÃO ou status vazio), que não devemos classificar artificialmente;
nenhuma data de óbito anterior ao diagnóstico.

Então, para a análise principal, temos potencialmente:

761+501=1262 pacientes

# Script 02-survival-analysis.R

> # Quem são os 3 casos com
> # data final < data diagnóstico ?
> dados_sobrevida[
+   dados_sobrevida$tempo<0,
+   c(
+     "Código do Paciente",
+     "Status Vital",
+     "data_diagnostico",
+     "data_obito",
+     "data_ultimo_contato",
+     "evento",
+     "data_final",
+     "tempo"
+   )
+ ]
       Código do Paciente Status Vital
112789            1118471         VIVO
117597            1151733         VIVO
122956            1155617         VIVO
       data_diagnostico data_obito
112789       2013-11-25       <NA>
117597       2014-01-02       <NA>
122956       2014-01-22       <NA>
       data_ultimo_contato evento data_final tempo
112789          2013-11-24      0 2013-11-24    -1
117597          2014-01-01      0 2014-01-01    -1
122956          2014-01-21      0 2014-01-21    -1

Pacientes classificados como vivos foram censurados na data do último contato; entretanto, três registros apresentaram data de último contato anterior à data do diagnóstico e foram excluídos da análise de sobrevivência por inconsistência temporal.

Isso deixará:
1.262 − 3 = 1.259 pacientes
com:
761 óbitos (evento = 1)
498 censurados (evento = 0)
