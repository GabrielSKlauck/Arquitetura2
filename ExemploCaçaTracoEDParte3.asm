org 100h

INCLUDE "emu8086.inc"

TAMANHO EQU 32

org 100h

                             





DEFINE_GET_STRING
DEFINE_PRINT_STRING

    ;MOV DI, OFFSET PALAVRA
    MOV DX, TAMANHO + 1
    CALL GET_STRING
    
    ;PARA IR PARA PROXIMA POSICAO DO VETOR, FACA ADD BX,2
    
    MOV CX,0
    MOV BX,CX                           
    
    MOSTRA:
    CALL PULA_LINHA 
    MOV SI, OFFSET PROCURANDO
    CALL PRINT_STRING
     
    
    MOV SI,PONTEIRO_PALAVRAS[BX] ;PASSA A PALAVRA DO VETOR
    PUSH SI                             ; NA POSICAO 0 PARA SI
    CALL PRINT_STRING
    CALL PULA_LINHA
    
     
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
                                 
                                 
    CALL PULA_LINHA                                  
    CALL PROCURA_ESQUERDA_DIREITA
    
      

PROCURA_ESQUERDA_DIREITA:
    PUSHF  
    PUSH DX 
    
    
    
PROCURANDO_ESQUERDA_DIREITA_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
       
    CMP DL, 0
    JE  ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA 
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_ED

    
IMPRIMIR_TRACO_ED:
    
    MOV AH,2 
    MOV DL, [BX]
    INT 21H
    CMP DL, '@'
    JE PULA 
    INC BX
    MOV DL,[BX]
    CMP DL, 0
    JE FIM_PROCURA_ESQUERDA_DIREITA
    MOV DL, [SI]
    
                            
    PUSH BX
    MOV BX, CX
    MOV SI,PONTEIRO_PALAVRAS[BX]
    POP BX
    INC DI
    JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS
    
IGUAL_PARCIAL_PROCURANDO_ESQUERDA_DIREITA_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    INC SI
    INC DI 
    INC BX
    INC BP ; BP SERA CONTADOR     
    
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DH, DL
    JNE RETORNA_TRACO_BACKSPACE_PUSH
             
    JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS   
    
RETORNA_TRACO_BACKSPACE_PUSH:
    PUSH BP
    JMP RETORNA_TRACO_BACKSPACE
    
RETORNA_TRACO_BACKSPACE:
    CMP DL, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    CMP BP, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    
    MOV AH, 2
    MOV DL, 08
    INT 21H  
    DEC BP    
    CMP BP, 0
    JE RETORNA_TRACO_POP
    JMP RETORNA_TRACO_BACKSPACE 
    
RETORNA_TRACO_POP:
    POP BP
    JMP RETORNA_TRACO
    
RETORNA_TRACO: 
    CMP DL, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    CMP BP, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS
    
    MOV AH, 2
    MOV DL, '-' 
    INT 21H
    DEC BP
    
    DEC SI 
    
    CMP BP, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    
    JMP RETORNA_TRACO
    
ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA: 
    CALL IMPRECAO
    
IMPRECAO:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H 
    INC BX 
    INC SI
    CMP DL, 0
    JE RESTO_IMPRECAO
    JMP IMPRECAO
RET
  
    
RESTO_IMPRECAO:
    MOV AH,2
    MOV DL,[BX]
    INT 21H
    CMP DL, '@'
    JE PULA_FIM 
    INC BX
    MOV DL,[BX]
    CMP DL, 0
    JE FIM_PROCURA_ESQUERDA_DIREITA 
    JMP RESTO_IMPRECAO
           
    
NAO_ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
    
FIM_PROCURA_ESQUERDA_DIREITA:
    POP DX
    POPF
    RET 
 
PULA_LINHA:                      
    pushf
    push ax
    push dx
    MOV AH,2
    MOV DL,13        
    INT 21H
    MOV AH,2
    MOV DL,10
    INT 21H
    pop dx        
    pop ax
    popf
    RET   

PULA_FIM:
CALL PULA_LINHA
INC BX
JMP RESTO_IMPRECAO
RET
    
PULA:
CALL PULA_LINHA
INC BX
JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
RET
  
          

;PROCURA BAIXO CIMA


PALAVRA DB TAMANHO DUP(" "),0  

                                                       
;use qualquer marcador                                                          
;fixo 10x40



PONTEIRO_PALAVRAS DW P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14,P15,P16,P17,P18,P19,P20,P21,P22,P23,P24,P25,P26,P27,P28

P0  DB "ADMINISTRACAO",0
P1  DB "AMBULATORIO",0
P2  DB "ANDADOR",0
P3  DB "CAMA",0
P4  DB "CAPELA",0
P5  DB "COPEIRO",0
P6  DB "ELETROCARDIOGRAMA",0
P7  DB "ELEVADOR",0
P8  DB "EMERGENCIA",0
P9  DB "FARMACIA",0
P10 DB "INJECAO",0
P11 DB "LABORATORIO",0
P12 DB "LANCHONETE",0
P13 DB "MACA",0
P14 DB "MULETA",0
P15 DB "PACIENTE",0
P16 DB "PARTO",0
P17 DB "POLTRONA",0
P18 DB "PRONTOSOCORRO",0
P19 DB "PSICOLOGO",0
P20 DB "RECEITA",0
P21 DB "RECEPCIONISTA",0
P22 DB "TELEFONE",0
P23 DB "TOMOGRAFIA",0
P24 DB "TRANSFUSAODESANGUE",0
P25 DB "VELORIO",0
P26 DB "VISITANTE",0
P27 DB "OBITO",0 
P28 DB 0  ; INDICADOR DE FIM DE PALAVRAS...TEM QUE PROCURAR
     
         DB 0,"#$$$$$$$$$$$$$$$$$$$$@" 
INICIO_A DB   "!DIDOADMINISTRACAOYIT@"
         DB   "!OACARTSINIMDAMLEATLE@"
         DB   "!FETPRONTOSOCORROEOEL@",0
         DB   "!TOUTITDTSOIEPOOOOMTE@"
         DB   "!DAEGANDADORSSNVBMORF@"
         DB   "!EAMTNLGEVREEIMIIAGOO@",0
         DB   "!ETEBEAORIEPOCAETIRCN@"
         DB   "!REASUNSOFRLAOVTONAAE@"
         DB   "!ELLVOLOEISAELDNFJFRV@"
         DB   "!CUSAMTAHDRINOEAAEIDP@"
         DB   "!EMRHDMETCOOIGTTRCAIO@"
         DB   "!PCAIAOAMONALOMIMAJOL@"
         DB   "!CAICDDSAERASEOSAOEGT@"
         DB   "!IPCSSCERIRILUVICASRR@"
         DB   "!OEAIIMEETOGOMFVIRTAO@"
         DB   "!NLAUECESGPDEEUSAADMN@"
         DB   "!IADDENISUAMSNTSNMNAA@"
         DB   "!SETIRRTLARSQCCCEAERA@"
         DB   "!TMTSANAETTCERAIACRAO@"
INICIO_B DB   "!AARMASMRGOOTGIEAARTT@"
         DB   "*********************#",0

           
         DB 0,"#$$$$$$$$$$$$$$$$$$$$@"
TRACO    DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "!--------------------@"
         DB   "**********************#",0 
          
NAO_ACHADO DB "NAO ACHADO",0 
PROCURANDO DB "PROCURANDO PALAVRA ", 0
E DD 0
F DD 0


RET
