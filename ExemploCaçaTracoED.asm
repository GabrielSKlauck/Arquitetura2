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
         DB 0,"#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$@"
INICIO_A DB   "!MSJDFLMIGLOKUELSADKLFJKKLSJDFKLASJDFKJSM@"
         DB   "!AIJDFLKASJDKFLJSADKLFJJKLSJDFKLASJDFKJIA@"
         DB   "!ALGKDFJKLASDJFFMSAJDKLJJSADKLFJLKDSAJGLK@"
         DB   "!ASJUFLKASMIGUELISADKLEUAKLSJDFKLESJMUKJS@"
         DB   "!ALLKELDFASDDJFHGSAJDKUEJSADKLFJLKULEJFLK@"
         DB   "!ASEDELKASJDKFLKUADKLFGLKLSJDFKLASJLEKJSA@"
         DB   "!ALUUDFJKLASDJFEESAJDKILJSADKLFJLKKSUUFLK@"
         DB   "!ASGDFLKASJDKFLLLADKLFMAKLSJDFKLASJDEMGSA@"
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
