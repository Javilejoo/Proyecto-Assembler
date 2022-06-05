.data
.balign 4

rojo: .int 8                @@ GPIO OUT pin 8 led roja
rojo2: .int 10              @@ GPIO OUT pin 10 led roja 2
azul: .int 12               @@ GPIO OUT pin 12 led azul
azul2: .int 16              @@ GPIO OUT pin 16 led azul 2
verde: .int 18              @@ GPIO OUT pin 18 led verde
verde2: .int 22             @@ GPIO OUT pin 22 led verde2
blanco: .int 24             @@ GPIO OUT pin 24  blanco
blanco2: .int 26            @@ GPIO OUT pin 26 led blano 2
amarillo: .int 28           @@ GPIO OUT pin 28 Ganador 1
amarillo2: .int 32          @@ GPIO OUT pin 32 Ganador 2
jugador1:.int 33            @@ GPIO OUT pin 33 botonestado1
jugador2:.int 36            @@ GPIO OUT pin 36 botonestado2
botonReset:.int 38          @@ GPIO OUT pin 38 boton reset --> estado3
botonNuevo:.int 40          @@ GPIO OUT pin 40 boton Nuevo --> estado4
delayMs: .int 1000          @@ Tiempo del Led
i: .int 0                   @@ contador de ciclo
INPUT = 0                   @@ apagado
OUTPUT = 1	                @@ Encendido 

ErrMsg:	 .asciz	"El sistema no esta funcionando...\n"

.text
.global 	main
.extern 	printf
.extern 	wiringPi
.extern 	pinMode
.extern 	digitalWrite
.extern 	delay

main:   
    push {ip, lr}		    @@ Push return address + dummy register

    bl wiringPiSetupPhys    @@ Llamado a la subrutina setup de WiringPiPhys
    mov	r1,#-1		        
    cmp	r0, r1					
    bne	init					
    ldr	r0, =ErrMsg		@@CARGAMOS MENSAJE DE ERROR		
    bl printf										
    b exit				    @@ En caso de que no se ha podido iniciar

init:                       @@Instanciar todos los leds, botones, sensores
    ldr r0, = jugador1				@ coloca el #pin wiringpi a r0
	ldr r0, [r0]					@ Carga la variable en r0
	mov r1, #INPUT					@ configuraión como entrada INPUT = 0
	bl pinMode						@ Configurar funcion de wiringPi

	ldr r0, = jugador2			    @ coloca el #pin wiringpi a r0
	ldr r0, [r0]					@ Carga la variable en r0
	mov r1, #INPUT					@ lo configuracion como entrada INPUT = 0
	bl pinMode						@ Configurar funcion de wiringPi

    ldr r0, = botonReset			@ coloca el #pin wiringpi a r0
	ldr r0, [r0]					@ Carga la variable en r0
	mov r1, #INPUT					@ lo configuracion como entrada INPUT = 0
	bl pinMode						@ Configurar funcion de wiringPi

    ldr r0, = botonNuevo			@ coloca el #pin wiringpi a r0
	ldr r0, [r0]					@ Carga la variable en r0
	mov r1, #INPUT					@ lo configuracion como entrada INPUT = 0
	bl pinMode						@ Configurar funcion de wiringPi

    ldr r0,=rojo            @@ Pin a utilizar
    ldr r0,[r0]	            @@asignamos valor a r0
    mov	r1, #OUTPUT		    @@ Asignacion de señal de salida	
    bl	pinMode	            @@ Llamado a la subrutina que coloca la senial

    ldr r0,=rojo2           @@ Pin a utilizar
    ldr r0,[r0]             @@asignamos valor a r0
    mov	r1, #OUTPUT	        @@ Asignacion de señal de salida
    bl	pinMode	            @@ llamado a la subrutina que coloca la senial

    ldr r0,=azul            @@ Pin a utilizar
    ldr r0,[r0]			    @@asignamos valor a r0
    mov	r1, #OUTPUT	        @@ Asignacion de señal de salida
    bl	pinMode	            @@ llamado a la subrutina que coloca la senial

    ldr r0,=azul2           @@ Pin a utilizar
    ldr r0,[r0]			    @@asignamos valor a r0
    mov	r1, #OUTPUT	        @@ Asignacion de señal de salida
    bl	pinMode	            @@ llamado a la subrutina que coloca la senial

    ldr r0,=verde           @@ Pin a utilizar
    ldr r0,[r0]			    @@asignamos valor a r0
    mov	r1, #OUTPUT	        @@ Asignacion de señal de salida
    bl	pinMode	            @@ llamado a la subrutina que coloca la senial

    ldr r0,=verde2          @@ Pin a utilizar
    ldr r0,[r0]			    @@asignamos valor a r0
    mov	r1, #OUTPUT	        @@ Asignacion de señal de salida
    bl	pinMode	            @@ llamado a la subrutina que coloca la senial

    ldr r0,=blanco          @@Pin a utilizar
    ldr r0,[r0]             @@asignamos valor a r0
    mov r1, #OUTPUT         @@Asignacion de Salida
    bl pinMode              @@llamando ala subrutina que coloca la senial

    ldr r0,=blanco2         @@ Pin a utilizar
    ldr r0,[r0]             @@asignamos valor a r0
    mov r1, #OUTPUT         @@Asignacion de Salida
    bl pinMode              @@llamando ala subrutina que coloca la senial

    ldr r0,=amarillo        @@ Pin a utilizar
    ldr r0,[r0]             @@asignamos valor a r0
    mov r1, #OUTPUT         @@Asignacion de Salida
    bl pinMode              @@llamando ala subrutina que coloca la senial
    
    ldr r0,=amarillo2       @@ Pin a utilizar
    ldr r0,[r0]             @@asignamos valor a r0
    mov r1, #OUTPUT         @@Asignacion de Salida
    bl pinMode              @@llamando ala subrutina que coloca la senial

    

try:								@ Activacion de Switch de entrada
	
	@@Sensor fotocelda
	ldr r0, =jugador1				@ carga dirección de pin
	ldr r0, [r0]					@ Carga la variable en r0
	bl  digitalRead					@ escribe 1 en pin para activar puerto GPIO, en modo de lectura
	cmp r0,#1
	beq On							@ funcion de encendido del led
	
	@@Sensor magnetico
    ldr r0, = jugador2				@ carga dirección de pin
	ldr r0, [r0]					@ Carga la variable en r0
	bl digitalRead					@ escribe 1 en pin para activar puerto GPIO, en modo de lectura
	cmp r0,#1						@ se realiza una comparación
	beq Off							@ funcion de apagado del led
	
	@@Boton1
    ldr r0, =botonReset				@ carga dirección de pin
	ldr r0, [r0]					@ Carga la variable en r0
	bl  digitalRead					@ escribe 1 en pin para activar puerto GPIO, en modo de lectura
	cmp r0,#1
	beq reset                       @@funcino de reset

    @@ Vaciar el registro 5 para poder ejecutarlo nuevamente
    ldr r5, =i              @@ Declaramos el contador en el registro no.5
    ldr r5, [r5]            @@cargamis el contador el r5
    
    @@Boton2
    ldr r0, =botonNuevo				@ carga dirección de pin
	ldr r0, [r0]					@ Carga la variable en r0
	bl  digitalRead					@ escribe 1 en pin para activar puerto GPIO, en modo de lectura
	cmp r0,#1
	beq nuevo                       @@funcino de Nuevo
    bl try



On:									@ funcion de encendido de led controlado por la fotocelda
    @@ Prender el led estado 1
    ldr r0,= amarillo               @@Asignacion de pin a utilizar
    ldr r0,[r0]                     @@cargar la variable en r0
    mov r1,#1                       @@Asignamos en valor de encendido
    bl digitalWrite
    @@ mantener apagado estado 2
    ldr r0,= amarillo2              @@Asignacion de pin a utilizar
    ldr r0,[r0]                     @@cargamos variable en r0
    mov r1,#0                       @@Asignamos estado de apagado
    bl digitalWrite

    ldr r0,= delayMs                @@el tiempo asignado que estara encendido r0
    ldr r0,[r0]                     @@asignamos la led 
    bl delay

	@@ Prender el primer led
    ldr r0,= rojo                   @@pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#1                       @@encendemos el pin
    bl digitalWrite
    
    @@ Mantener encendido el primer led
    ldr r0,= delayMs                @@el tiempo asignado que estara encendido r0
    ldr r0,[r0]                     @@asignamos la led 
    bl delay
    
    @@ Prender segundo led
    ldr r0,= rojo2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor
    mov r1,#1                       @@encendemos
    bl digitalWrite
    
    @@ Mantener encendido el segundo led
    ldr r0,= delayMs                @@tiempo a estar encendido
    ldr r0,[r0]
    bl delay

    @@ Prender el tercer led
    ldr r0,= azul                       @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite
    
    @@ Mantener encendido el tercer led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    @@ Prender el cuarto led
    ldr r0,= azul2                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite
    
    @@ Mantener encendido el cuarto led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    @@ Prender el quinto led
    ldr r0,= verde                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite
    
    @@ Mantener encendido el quinto led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    @@ Mantener encendido el sexto led
    ldr r0,= verde2                     @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite
    
    @@ Mantener encendido el sexto led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    ldr r0,= blanco                 @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#1                       @@encendemos
    bl digitalWrite

    @@ Mantener encendido el septimo led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    ldr r0,= blanco2                    @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    @@ Mantener encendido el octavo led
    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    ldr r0,= delayMs                @@el tiempo asignado que estara encendido r0
    ldr r0,[r0]                     @@asignamos la led 
    bl delay

    @@ Fin estado 1
    ldr r0,= amarillo                    @@ pin a utilizar
    ldr r0,[r0]                          @@asignamos valor a r0
    mov r1,#0                            @@apagamos
    bl digitalWrite
    bl try



Off:								@ funcion de apagado del led controlado por el sensor magnetico
    @@ mantener apagado estado 1
    ldr r0,= amarillo               @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    @@ Prender el led estado 2
    ldr r0,= amarillo2
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#1                       @@Encendemos
    bl digitalWrite

    ldr r0,= delayMs                @@el tiempo asignado que estara encendido r0
    ldr r0,[r0]                     @@asignamos la led 
    bl delay

    ldr r0,= amarillo2                  @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1
    bl digitalWrite

    @@ Mantener encendido el  led de estado
    ldr r0,= delayMs
    ldr r0,[r0]                         @@asignamos valor a r0
    bl delay
    
    @@ Apagar primer led
    ldr r0,= blanco2                    @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@apagamos
    bl digitalWrite
    
    @@ Mantener encendido el segundo led
    ldr r0,= delayMs
    ldr r0,[r0]                         @@asignamos valor a r0
    bl delay

    @@ apagar 
    ldr r0,= blanco                 @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    
    @@ Mantener encendido el tercer led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay
    
    @@ apagar 
    ldr r0,= verde2                 @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    
    @@ Mantener encendido el cuarto led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay
    
    @@ apagar 
    ldr r0,= verde                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    
    @@ Mantener encendido el quinto led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay
    
    @@ apagar 
    ldr r0,= azul2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    
    @@ Mantener encendido el sexto led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay
    
    @@ apagar 
    ldr r0,= azul                   @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    @@ Mantener encendido el septimo led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay
    
    @@ apagar 
    ldr r0,= rojo2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay

    @@ apagar 
    ldr r0,= rojo                   @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= delayMs                @@el tiempo asignado que estara encendido r0
    ldr r0,[r0]                     @@asignamos la led 
    bl delay

    @@ Mantener encendido el octavo led
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay

    @@ fin  estado 2
    ldr r0,= amarillo2                  @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@apagamos
    bl digitalWrite
    bl try
    
reset: 					            @@ Controlado por el Boton1

    @@ mantener apagado estado 1
    ldr r0,= amarillo               @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#1                       @@Encendemos
    bl digitalWrite

    @@ Prender el led estado 2
    ldr r0,= amarillo2
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#1                       @@Encendemos
    bl digitalWrite

    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    ldr r0,= rojo                   @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    
    ldr r0,= rojo2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= azul                   @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= azul2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= verde                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= verde2                 @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= blanco                 @@ pin a utilizar   
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= blanco2                @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= delayMs
    ldr r0,[r0]
    bl delay

    @@ mantener apagado estado 1
    ldr r0,= amarillo               @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    @@ Prender el led estado 2
    ldr r0,= amarillo2
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite
    bl try

nuevo:                              @@ Controlador del Boton2
    cmp r5, #6			    @@ Repetir el ciclo 10 veces
    bgt try			        @@ Salir del ciclo

	@@ Prender el primer led
    ldr r0,= rojo                       @@pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos el pin
    bl digitalWrite
    
    @@ Prender el tercer led
    ldr r0,= azul                       @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    @@ Prender el quinto led
    ldr r0,= verde                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    ldr r0,= blanco                     @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    ldr r0,= amarillo                    @@ pin a utilizar
    ldr r0,[r0]                          @@asignamos valor a r0
    mov r1,#1                            @@apagamos
    bl digitalWrite

    @@ Apagar segundo led
    ldr r0,= rojo2                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor
    mov r1,#0                           @@encendemos
    bl digitalWrite

    @@ Apagar el cuarto led
    ldr r0,= azul2                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    @@ Apagar el sexto led
    ldr r0,= verde2                     @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    ldr r0,= blanco2                    @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    ldr r0,= amarillo2                   @@ pin a utilizar
    ldr r0,[r0]                          @@asignamos valor a r0
    mov r1,#0                            @@apagamos
    bl digitalWrite

    @@Relentizar los leds
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay

    @@ Apagar el primer led
    ldr r0,= rojo                       @@pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos el pin
    bl digitalWrite
    
    @@ Apagar el tercer led
    ldr r0,= azul                       @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    @@ Apagar el quinto led
    ldr r0,= verde                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    ldr r0,= blanco                     @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#0                           @@encendemos
    bl digitalWrite

    ldr r0,= amarillo                    @@ pin a utilizar
    ldr r0,[r0]                          @@asignamos valor a r0
    mov r1,#0                            @@apagamos
    bl digitalWrite

    @@ Prender segundo led
    ldr r0,= rojo2                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor
    mov r1,#1                           @@encendemos
    bl digitalWrite

    @@ Prender el cuarto led
    ldr r0,= azul2                      @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    @@ Prender el sexto led
    ldr r0,= verde2                     @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    ldr r0,= blanco2                    @@ pin a utilizar
    ldr r0,[r0]                         @@asignamos valor a r0
    mov r1,#1                           @@encendemos
    bl digitalWrite

    ldr r0,= amarillo2                   @@ pin a utilizar
    ldr r0,[r0]                          @@asignamos valor a r0
    mov r1,#1                            @@apagamos
    bl digitalWrite

    @@Relentizar los leds
    ldr r0,= delayMs
    ldr r0,[r0]                     @@asignamos valor a r0
    bl delay

    add r5, #1			    @@ sumar uno al ciclo
    b nuevo			        @@ Retornar al ciclo

exit:
    @@ APAGAMOS LOS LEDS
    ldr r0,=rojo                    @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite	

    ldr r0,= rojo2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= azul                   @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= azul2                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= verde                  @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0,= verde2                 @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0, = blanco                @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite

    ldr r0, = blanco2               @@ pin a utilizar
    ldr r0,[r0]                     @@asignamos valor a r0
    mov r1,#0                       @@apagamos
    bl digitalWrite	

done:	
    bl reset                    @@llamamos a funcion de reset
    pop 	{ip, pc}			@ pop return address into pc
