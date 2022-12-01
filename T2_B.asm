org 100h

INCLUDE "emu8086.inc"

TAMANHO EQU 32

org 100h

DEFINE_GET_STRING
DEFINE_PRINT_STRING

    MOV DI, OFFSET PALAVRA
    MOV DX, TAMANHO + 1
    CALL GET_STRING
   
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO                             
                                 
    CALL PULA_LINHA                                  
    ;CALL PROCURA_ESQUERDA_DIREITA 
    DE:
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
    
    CALL PULA_LINHA
   ; CALL PROCURANDO_DIREITA_ESQUERDA
    
    CB:
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
    
    CALL PULA_LINHA
    CALL PROCURA_CIMA_BAIXO
    
    BC:
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
    
    CALL PULA_LINHA
   ; CALL PROCURA_BAIXO_CIMA
    
    SE:
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
    
    CALL PULA_LINHA
    CALL PROCURA_SUP_ESQUERDA 
    
    ID:
    MOV SI, OFFSET PALAVRA
    MOV DI, OFFSET INICIO_A
    MOV BX, OFFSET TRACO
    
    CALL PULA_LINHA
    CALL PROCURA_INF_DIREITA  

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
    JE PULA_ED 
    INC BX
    MOV DL,[BX]
    CMP DL, 0
    JE FIM_PROCURA_ESQUERDA_DIREITA
    MOV DL, [SI]
                             
    MOV SI, OFFSET PALAVRA
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
    JNE RETORNA_TRACO_BACKSPACE_PUSH_ED
             
    JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS   
    
RETORNA_TRACO_BACKSPACE_PUSH_ED:
    PUSH BP
    JMP RETORNA_TRACO_BACKSPACE_ED
    
RETORNA_TRACO_BACKSPACE_ED:
    CMP DL, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    CMP BP, 0
    JE PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
    
    MOV AH, 2
    MOV DL, 08
    INT 21H  
    DEC BP    
    CMP BP, 0
    JE RETORNA_TRACO_POP_ED
    JMP RETORNA_TRACO_BACKSPACE_ED 
    
RETORNA_TRACO_POP_ED:
    POP BP
    JMP RETORNA_TRACO_ED
    
RETORNA_TRACO_ED: 
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
    
    JMP RETORNA_TRACO_ED
    
ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA: 
    CALL IMPRECAO_ED 
      
IMPRECAO_ED:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H 
    INC BX 
    INC SI
    CMP DL, 0
    JE RESTO_IMPRECAO_ED
    JMP IMPRECAO_ED
RET
  
    
RESTO_IMPRECAO_ED:
    MOV AH,2
    MOV DL,[BX]
    INT 21H
    CMP DL, '@'
    JE PULA_FIM_ED 
    INC BX
    MOV DL,[BX]
    CMP DL, 0 
    
    JE FIM_PROCURA_ESQUERDA_DIREITA 
    JMP RESTO_IMPRECAO_ED
           
    
NAO_ACHOU_SUBSTRING_PROCURA_ESQUERDA_DIREITA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_ESQUERDA_DIREITA:
    POP DX
    POPF
    JMP DE  

PULA_ED:
CALL PULA_LINHA
INC BX
JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
RET
    
 PULA_FIM_ED:
CALL PULA_LINHA
INC BX
JMP RESTO_IMPRECAO_ED
RET
   
    
    ; DA DIREITA PARA A ESQUERDA
    
PROCURANDO_DIREITA_ESQUERDA:
    PUSHF
    PUSH DX
    
PROCURANDO_DIREITA_ESQUERDA_IR_FINAL_PALAVRA:
    MOV DL, [SI]
    CMP DL, 0
    JE CHEGOU
    INC SI
    INC LENGHT  
    JMP PROCURANDO_DIREITA_ESQUERDA_IR_FINAL_PALAVRA

    
CHEGOU:
    DEC SI
    DEC LENGHT
    PUSH SI
    JMP PROCURANDO_DIREITA_ESQUERDA_IGUAIS
    
PROCURANDO_DIREITA_ESQUERDA_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    
    CMP BP, LENGHT
    JE  ACHOU_SUBSTRING_PROCURA_DIREITA_ESQUERDA 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_DIREITA_ESQUERDA 
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_DE 
    
IMPRIMIR_TRACO_DE:
    
    MOV AH,2 
    MOV DL, [BX]
    INT 21H
    CMP DL, '@'
    JE PULA_DE 
    INC BX
    MOV DL,[BX]
    CMP DL, 0
    JE FIM_PROCURA_DIREITA_ESQUERDA
    MOV DL, [SI]                          
    POP SI
    PUSH SI
    INC DI
    JMP PROCURANDO_DIREITA_ESQUERDA_IGUAIS  
    
IGUAL_PARCIAL_PROCURANDO_DIREITA_ESQUERDA_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    DEC SI
    INC DI 
    INC BX
    INC BP ; BP SERA CONTADOR
    
    CMP BP, LENGHT
    JE  ACHOU_SUBSTRING_PROCURA_DIREITA_ESQUERDA   
    
    MOV DL, [SI]
    MOV DH, [DI]
    CMP DH, DL
    JNE RETORNA_TRACO_BACKSPACE_PUSH_DE
             
    JMP PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    
RETORNA_TRACO_BACKSPACE_PUSH_DE:
    PUSH BP
    JMP RETORNA_TRACO_BACKSPACE_DE
    
RETORNA_TRACO_BACKSPACE_DE:
    CMP DL, 0
    JE PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    CMP BP, 0
    JE PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    
    MOV AH, 2
    MOV DL, 08
    INT 21H  
    DEC BP    
    CMP BP, 0
    JE RETORNA_TRACO_POP_DE
    JMP RETORNA_TRACO_BACKSPACE_DE  

RETORNA_TRACO_POP_DE:
    POP BP
    JMP RETORNA_TRACO_DE
    
RETORNA_TRACO_DE: 
    CMP DL, 0
    JE PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    CMP BP, 0
    JE PROCURANDO_DIREITA_ESQUERDA_IGUAIS
    
    MOV AH, 2
    MOV DL, '-' 
    INT 21H
    DEC BP
    
    INC SI 
    
    CMP BP, 0
    JE PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
    
    JMP RETORNA_TRACO_DE        

ACHOU_SUBSTRING_PROCURA_DIREITA_ESQUERDA: 
    CALL IMPRECAO_DE 
      
IMPRECAO_DE:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H 
    INC BX 
    DEC SI
    CMP BP, LENGHT
    JE RESTO_IMPRECAO_DE
    JMP IMPRECAO_DE
RET
  
    
RESTO_IMPRECAO_DE:
    MOV AH,2
    MOV DL,[BX]
    INT 21H
    CMP DL, '@'
    JE PULA_FIM_DE 
    INC BX
    MOV DL,[BX]
    CMP DL, 0 
    
    JE FIM_PROCURA_DIREITA_ESQUERDA 
    JMP RESTO_IMPRECAO_DE

NAO_ACHOU_SUBSTRING_PROCURA_DIREITA_ESQUERDA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_DIREITA_ESQUERDA:
    POP DX
    POPF
    JMP CB
    RET 
    
IR_FINAL_PALAVRA_DE:
    MOV DL, [SI]
    CMP DL, 0
    JE CHEGOU_2_DE
    INC SI
    JMP IR_FINAL_PALAVRA_DE
    
CHEGOU_2_DE:
    DEC SI
    PUSH SI
    RET 
    
     
PULA_FIM_DE:
CALL PULA_LINHA
INC BX
JMP RESTO_IMPRECAO_DE
RET  

PULA_DE:
CALL PULA_LINHA
INC BX
JMP PROCURANDO_DIREITA_ESQUERDA_IGUAIS 
RET

 
   


    
PULA:
CALL PULA_LINHA
INC BX
JMP PROCURANDO_ESQUERDA_DIREITA_IGUAIS 
RET
  
          

;PROCURA CIMA BAIXO   



PROCURA_CIMA_BAIXO:
    PUSHF  
    PUSH DX  
    PUSH BX
    PUSH DI
    
PROCURANDO_CIMA_BAIXO_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    
   ; CMP DL, 0
   ; JE  ACHOU_SUBSTRING_PROCURA_CIMA_BAIXO 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_CIMA_BAIXO
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_CIMA_BAIXO_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_CB
    
IMPRIMIR_TRACO_CB:
    INC CONTADOR 
    MOV DL, 0
    MOV AH,2 
    MOV DL, '-'
    INT 21H
    MOV DL, [BX]
    CMP DL, '*'
    JE PULA_COLUNA_CB 
    CALL PROXIMA_LINHA_CB
     
    ADD BX, 42
    MOV DL,[DI]
    CMP DL, '#'
    JE FIM_PROCURA_CIMA_BAIXO
    MOV DL, [SI]
                             
    MOV SI, OFFSET PALAVRA
    ADD DI, 42
    JMP PROCURANDO_CIMA_BAIXO_IGUAIS
    
IGUAL_PARCIAL_PROCURANDO_CIMA_BAIXO_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    CALL PROXIMA_LINHA_CB
    INC SI
    ADD DI, 42 
    ADD BX, 42
    INC CONTADOR
   ; INC CONTADOR_2_BP ; PRECISEI QUE BP FOSSE 8BIT     
    
  ;  MOV DL, [SI]
   ; MOV DH, [DI]
   ; CMP DH, DL
  ;  JNE RETORNA_TRACO_BACKSPACE_PUSH_CB
             
    JMP PROCURANDO_CIMA_BAIXO_IGUAIS   
    

    
ACHOU_SUBSTRING_PROCURA_CIMA_BAIXO: 
   ; CALL RESTO_IMPRECAO_CB
      
IMPRECAO_CB:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H
    CALL PROXIMA_LINHA_CB
    INC CONTADOR 
    ADD BX, 42 
    INC SI
    CMP DL, 0
   ; JE RESTO_IMPRECAO_CB
    JMP IMPRECAO_CB
RET
  
           
    
NAO_ACHOU_SUBSTRING_PROCURA_CIMA_BAIXO:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_CIMA_BAIXO:
    POP DX
    POPF
    JMP BC  

PULA_COLUNA_CB:
    POP BX
    INC BX
    PUSH BX 
    MOV DI, BX
  
    CALL CURSOR_PROXIMA_COLUNA_CB
    JMP PROCURANDO_CIMA_BAIXO_IGUAIS 
    RET
    
 PULA_COLUNA_FIM_CB:    
    POP BX
    INC BX
    PUSH BX
    CALL CURSOR_PROXIMA_COLUNA_CB
  ;  JMP RESTO_IMPRECAO_CB
    RET

CURSOR_PROXIMA_COLUNA_CB:
    PUSH BX
    PUSH DI
    MOV AH, 03 ; AH=3/INT10H = GET CURSOR POSITION
    MOV BH, 0
    INT 10H
    SUB DH, CONTADOR 
    INC DH
    MOV AH, 2  ; AH=2/INT10H SET CURSOR POSITION
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    
    POP DI 
    POP BX
    MOV CONTADOR, 0
    RET        
    
PROXIMA_LINHA_CB:
    PUSH BX
    PUSH DI
    MOV AH, 03
    MOV BH, 0
    INT 10H
    
    INC DH
    DEC DL
    MOV AH, 2
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    POP DI
    POP BX
    ret   
    
    
            ;PROCURA BAIXO_CIMA ------------- 



PROCURA_BAIXO_CIMA:
    PUSHF  
    PUSH DX  
    PUSH BX
    PUSH DI
    MOV CONTADOR, 0
    MOV LENGHT, 0
    
PROCURANDO_BAIXO_CIMA_IR_FINAL_PALAVRA:
    MOV DL, [SI]
    CMP DL, 0
    JE CHEGOU_BC
    INC SI
    INC LENGHT  
    JMP PROCURANDO_BAIXO_CIMA_IR_FINAL_PALAVRA

    
CHEGOU_BC:
    DEC SI
    DEC LENGHT
    MOV PUSH_SI, SI
    JMP PROCURANDO_BAIXO_CIMA_IGUAIS
    
PROCURANDO_BAIXO_CIMA_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    
   ; CMP DL, 0
   ; JE  ACHOU_SUBSTRING_PROCURA_BAIXO_CIMA 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_BAIXO_CIMA
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_BAIXO_CIMA_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_BC
    
IMPRIMIR_TRACO_BC:
    INC CONTADOR 
    MOV DL, 0
    MOV AH,2 
    MOV DL, '-'
    INT 21H
    MOV DL, [BX]
    CMP DL, '*'
    JE PULA_COLUNA_BC 
    CALL PROXIMA_LINHA_BC
     
    ADD BX, 42
    MOV DL,[DI]
    CMP DL, '#'
    JE FIM_PROCURA_BAIXO_CIMA
    MOV DL, [SI]
                             
    MOV SI, PUSH_SI
    ADD DI, 42
    JMP PROCURANDO_BAIXO_CIMA_IGUAIS
    
IGUAL_PARCIAL_PROCURANDO_BAIXO_CIMA_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    CALL PROXIMA_LINHA_BC
    DEC SI
    ADD DI, 42 
    ADD BX, 42
    INC CONTADOR
   ; INC CONTADOR_2_BP ; PRECISEI QUE BP FOSSE 8BIT     
    
  ;  MOV DL, [SI]
   ; MOV DH, [DI]
   ; CMP DH, DL
  ;  JNE RETORNA_TRACO_BACKSPACE_PUSH_BC
             
    JMP PROCURANDO_BAIXO_CIMA_IGUAIS   
    

      
IMPRECAO_BC:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H
    CALL PROXIMA_LINHA_BC
    INC CONTADOR 
    ADD BX, 42 
    INC SI
    JMP IMPRECAO_BC
RET
  
           
    
NAO_ACHOU_SUBSTRING_PROCURA_BAIXO_CIMA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_BAIXO_CIMA:
    POP DX
    POPF
    
    JMP SE 

PULA_COLUNA_BC:
    POP BX
    INC BX
    PUSH BX 
    MOV DI, BX
  
    CALL CURSOR_PROXIMA_COLUNA_BC
    JMP PROCURANDO_BAIXO_CIMA_IGUAIS 
    RET
    
 PULA_COLUNA_FIM_BC:    
    POP BX
    INC BX
    PUSH BX
    CALL CURSOR_PROXIMA_COLUNA_BC
    RET

CURSOR_PROXIMA_COLUNA_BC:
    PUSH BX
    PUSH DI
    MOV AH, 03 ; AH=3/INT10H = GET CURSOR POSITION
    MOV BH, 0
    INT 10H
    SUB DH, CONTADOR 
    INC DH
    MOV AH, 2  ; AH=2/INT10H SET CURSOR POSITION
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    
    POP DI 
    POP BX
    MOV CONTADOR, 0
    RET        
    
PROXIMA_LINHA_BC:
    PUSH BX
    PUSH DI
    MOV AH, 03
    MOV BH, 0
    INT 10H
    
    INC DH
    DEC DL
    MOV AH, 2
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    POP DI
    POP BX
    ret    
    
    
    
   ; DIAGONAL SUPERIOR ESQUERDA
   
   
PROCURA_SUP_ESQUERDA:
    PUSHF  
    PUSH DX  
    PUSH DI
    PUSH BX
    
     
    MOV CONTADOR, 0 
    MOV CONTADOR_COLUNA, 0
    
PROCURANDO_SUP_ESQUERDA_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    
   ; CMP DL, 0
   ; JE  ACHOU_SUBSTRING_PROCURA_SUP_ESQUERDA 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_SUP_ESQUERDA
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_SUP_ESQUERDA_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_SE
    
IMPRIMIR_TRACO_SE:
    INC CONTADOR
    INC CONTADOR_COLUNA 
    MOV DL, 0
    MOV AH,2 
    MOV DL, '-'
    INT 21H
    MOV DL, [BX]
    CMP DL, '*'
    JE PULA_COLUNA_SE
    CALL PROXIMA_LINHA_SE
     
    ADD BX, 43
    MOV DL,[DI]
    CMP DL, '@'
    JE FIM_PROCURA_SUP_ESQUERDA
    MOV DL, [SI]
                             
    MOV SI, OFFSET PALAVRA
    ADD DI, 43
    JMP PROCURANDO_SUP_ESQUERDA_IGUAIS
    
IGUAL_PARCIAL_PROCURANDO_SUP_ESQUERDA_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    CALL PROXIMA_LINHA_SE
    INC SI
    ADD DI, 43 
    ADD BX, 43
    INC CONTADOR
    INC CONTADOR_COLUNA
   ; INC CONTADOR_2_BP ; PRECISEI QUE BP FOSSE 8BIT     
    
  ;  MOV DL, [SI]
   ; MOV DH, [DI]
   ; CMP DH, DL
  ;  JNE RETORNA_TRACO_BACKSPACE_PUSH_SE
             
    JMP PROCURANDO_SUP_ESQUERDA_IGUAIS   
    

    
ACHOU_SUBSTRING_PROCURA_SUP_ESQUERDA: 
   ; CALL RESTO_IMPRECAO_SE
      
IMPRECAO_SE:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H
    CALL PROXIMA_LINHA_SE
    INC CONTADOR 
    ADD BX, 42 
    INC SI
    CMP DL, 0
   ; JE RESTO_IMPRECAO_SE
    JMP IMPRECAO_SE
RET
  
           
    
NAO_ACHOU_SUBSTRING_PROCURA_SUP_ESQUERDA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_SUP_ESQUERDA:
    POP DX
    POPF
    JMP ID  

PULA_COLUNA_SE:
    POP BX
    INC BX
    PUSH BX 
    MOV DI, BX
  
    CALL CURSOR_PROXIMA_COLUNA_SE
    JMP PROCURANDO_SUP_ESQUERDA_IGUAIS 
    RET
    
 PULA_COLUNA_FIM_SE:    
    POP BX
    INC BX
    PUSH BX
    CALL CURSOR_PROXIMA_COLUNA_SE
  ;  JMP RESTO_IMPRECAO_SE
    RET

CURSOR_PROXIMA_COLUNA_SE:
    PUSH BX
    PUSH DI
    MOV AH, 03 ; AH=3/INT10H = GET CURSOR POSITION
    MOV BH, 0
    INT 10H
    SUB DH, CONTADOR 
    INC DH
    SUB DL, CONTADOR_COLUNA
    INC DL 
    INC DL
    MOV AH, 2  ; AH=2/INT10H SET CURSOR POSITION
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H               ;DH= ROW
                          ;DL= COLUMN
    POP DI 
    POP BX
    MOV CONTADOR, 0
    MOV CONTADOR_COLUNA, 0
    RET        
    
PROXIMA_LINHA_SE:
    PUSH BX
    PUSH DI
    MOV AH, 03
    MOV BH, 0
    INT 10H
    
    INC DH
    ;DEC DL
    MOV AH, 2
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    POP DI
    POP BX
    ret  
    
    
    
    ; DIAGONAL INFERIOR DIREITRA   
    
    PROCURA_INF_DIREITA:
    PUSHF  
    PUSH DX  
    PUSH BX
    PUSH DI
    MOV CONTADOR, 0
    MOV CONTADOR_COLUNA, 0
    MOV PUSH_SI, 0
    
PROCURANDO_INF_DIREITA_IR_FINAL_PALAVRA:
    MOV DL, [SI]
    CMP DL, 0
    JE CHEGOU_ID
    INC SI
    INC LENGHT  
    JMP PROCURANDO_INF_DIREITA_IR_FINAL_PALAVRA

    
CHEGOU_ID:
    DEC SI
    DEC LENGHT
    MOV PUSH_SI, SI
    JMP PROCURANDO_INF_DIREITA_IGUAIS
    
    
PROCURANDO_INF_DIREITA_IGUAIS:
    MOV DL, [SI]
    MOV DH, [DI]
    
   ; CMP DL, 0
   ; JE  ACHOU_SUBSTRING_PROCURA_INF_DIREITA 
    
    CMP DH, 0                                        
    JE  NAO_ACHOU_SUBSTRING_PROCURA_INF_DIREITA
    
    CMP DH,DL
    JE  IGUAL_PARCIAL_PROCURANDO_INF_DIREITA_IGUAIS 
    
    CMP DH, DL
    JNE IMPRIMIR_TRACO_ID
    
IMPRIMIR_TRACO_ID:
    INC CONTADOR
    INC CONTADOR_COLUNA 
    MOV DL, 0
    MOV AH,2 
    MOV DL, '-'
    INT 21H
    MOV DL, [BX]
    CMP DL, '*'
    JE PULA_COLUNA_ID
    CALL PROXIMA_LINHA_ID
     
    ADD BX, 43
    MOV DL,[BX]
    CMP DL, '@'
    JE FIM_PROCURA_INF_DIREITA
    MOV DL, [SI]
                             
    MOV SI, PUSH_SI
    ADD DI, 43
    JMP PROCURANDO_INF_DIREITA_IGUAIS
    
IGUAL_PARCIAL_PROCURANDO_INF_DIREITA_IGUAIS: 
    MOV AH, 2
    MOV DL, [SI]
    INT 21H
    CALL PROXIMA_LINHA_ID
    DEC SI
    ADD DI, 43 
    ADD BX, 43
    INC CONTADOR
    INC CONTADOR_COLUNA
   ; INC CONTADOR_2_BP ; PRECISEI QUE BP FOSSE 8BIT     
    
  ;  MOV DL, [SI]
   ; MOV DH, [DI]
   ; CMP DH, DL
  ;  JNE RETORNA_TRACO_BACKSPACE_PUSH_SE
             
    JMP PROCURANDO_INF_DIREITA_IGUAIS   
    

    
ACHOU_SUBSTRING_PROCURA_INF_DIREITA: 
   ; CALL RESTO_IMPRECAO_ID
      
IMPRECAO_ID:
    
    MOV AH,2
    MOV DL,[SI]
    INT 21H
    CALL PROXIMA_LINHA_ID
    INC CONTADOR 
    ADD BX, 42 
    INC SI
    CMP DL, 0
   ; JE RESTO_IMPRECAO_ID
    JMP IMPRECAO_ID
RET
  
           
    
NAO_ACHOU_SUBSTRING_PROCURA_INF_DIREITA:   
    MOV SI, OFFSET NAO_ACHADO
    CALL PRINT_STRING
    
FIM_PROCURA_INF_DIREITA:
    POP DX
    POPF
    
    ;JMP FINAL  

PULA_COLUNA_ID:
    POP BX
    INC BX
    PUSH BX 
    MOV DI, BX
  
    CALL CURSOR_PROXIMA_COLUNA_ID
    JMP PROCURANDO_INF_DIREITA_IGUAIS 
    RET
    
 PULA_COLUNA_FIM_ID:    
    POP BX
    INC BX
    PUSH BX
    CALL CURSOR_PROXIMA_COLUNA_ID
  ;  JMP RESTO_IMPRECAO_ID
    RET

CURSOR_PROXIMA_COLUNA_ID:
    PUSH BX
    PUSH DI
    MOV AH, 03 ; AH=3/INT10H = GET CURSOR POSITION
    MOV BH, 0
    INT 10H
    SUB DH, CONTADOR 
    INC DH
    SUB DL, CONTADOR_COLUNA
    INC DL
    INC DL
    INC DL
    MOV AH, 2  ; AH=2/INT10H SET CURSOR POSITION
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H               ;DH= ROW
                          ;DL= COLUMN
    POP DI 
    POP BX
    MOV CONTADOR, 0
    MOV CONTADOR_COLUNA, 0
    RET        
    
PROXIMA_LINHA_ID:
    PUSH BX
    PUSH DI
    MOV AH, 03
    MOV BH, 0
    INT 10H
    
    INC DH
    ;DEC DL
    MOV AH, 2
    MOV BH, 0
    MOV DL, DL
    MOV DH, DH
    INT 10H
    POP DI
    POP BX
    ret 
    
    
   
    
    
    
    
    
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



PALAVRA DB TAMANHO DUP(" "),0 

LENGHT DW 0
CONTADOR_COLUNA DB 0
CONTADOR_2_BP DB 0 
PUSH_CONTADOR_2_BP DB 0
CONTADOR DB 0
COLUNA DB 0
LINHA DB 0

PUSH_SI DW 0
                                                       
;use qualquer marcador                                                          
;fixo 10x40
         DB 0,"#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@"
INICIO_A DB   "!MSJDMLMIGLOKUELSADKLFJKKLSJDFKLASJDFKJSM@"
         DB   "!AIJDFIKASJDKFLJSADLEUGIMLSJDFKLASJDFKJIA@"
         DB   "!ALGKDFGKMASDJFFMSAJDKLJJSADKLFJLKDSAJGJK@"
         DB   "!ASJUFLKUIMIGUELISADLEUGIMPSJDFKLESJMUKJS@"
         DB   "!ALLKELDFESDDJFHGSAJDKUEJSADKLFJLKULEJFLK@"
         DB   "!ASEDELKAULDKFLKUADKLFGLKLSJDFKLASJLEKJSA@"
         DB   "!ALUUDFJKEASDJFEESAJDKILJSADKLFJLKKSUUFLK@"
         DB   "!ASGDFLKALJDKFLLLADKLFMAKLSJDFKLASJDEMGSA@"
         DB   "!AIIKDFJKLASDJFJKSAJDKFLJSALEUGIMKDSLJFIK@"
INICIO_B DB   "!MSFDFLKASJDKFLJSADKLFJAKLSJDFKLASJDFKJSM@"
         DB   "*****************************************#",0
      
      
         DB 0,"#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@"
TRACO    DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "!----------------------------------------@"
         DB   "*****************************************#",0  
NAO_ACHADO DB "NAO ACHADO",0
RET   