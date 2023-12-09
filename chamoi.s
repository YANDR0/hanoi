# ALBERTO RENTERIA CAMACHO
# YAEL ALEJANDRO RODRIGUEZ BARRETO

.equ DISCOS 3   	# Cantidad de discos a trabajar
.data
ptr:            	# Direccion para trabajar con discos    10010000
.text

main:
    addi s0 zero DISCOS	# Guardado del numero de discos
    bge zero s0 error   # Error si la cantidad de discos es menor o igual a 0
    addi t0 zero 4	# Obtencion de valor para multiplicar
    mul t1 s0 t0	# Calculo del espacio a necesitar
    addi t1 t1 4        # Calculo del espaciado entre torres
    
    lui s2 %hi(ptr)     # Parte superior de la torre 1
    addi s2 s2 %lo(ptr) # Parte inferior de la torre 1
    add s3 s2 t1        # Direccion de torre 2
    add s4 s3 t1       	# Direccion de torre 3
    
    add t0 zero s0      # Declaracion del indice
    for:        	#for(int i = DISCOS; 0 < i; i --)
        sw t0 0(s2)    		# Creacion de los discos
        addi s2 s2 4    	# Avance en la torre
        addi t0 t0 -1    	# Disminucion del indice
        blt zero t0 for    	# Condicion del ciclo
        
    add a0 s0 zero    	# Declaracion N 
    addi a1 zero 0    	# Declaracion torre origen
    addi a2 zero 1    	# Declaracion torre pivote
    addi a3 zero 2    	# Declaracion torre destino
    
    jal ra chamoy    	# Salto a la funcion Hanoi
    jal zero exit    	# Finalizacion del codigo
    

    
chamoy:
    addi sp sp -20    	# Apartado de memoria - Stack frame
    sw ra 16(sp)    	# Direccion llamada
    sw a0 12(sp)    	# N
    sw a1 8(sp)    	# Origen
    sw a2 4(sp)    	# Pivote
    sw a3 0(sp)    	# Destino
    
    addi t0 zero 1    	# Registro para comparar
    beq a0 t0 casoBase 	# Salto a caso base
    jal ra recUno   	# Primera llamada recursiva
    jal ra lectura      # Obtencion de los datos de esta llamada
    jal ra moverDisco	# Movimiento del disco desde origen a destino
    jal ra recDos    	# Segunda llamada recursiva
    jal zero finChamoy  # Fin de la llamada recursiva y lectura del stack
    

recUno:   
    addi a0 a0 -1    	# Disminucion de N en 1
    add t0 a2 zero 	# Preración de argumentos
    add a2 a3 zero 
    add a3 t0 zero
    jal zero chamoy	# Regreso a funcion principal
     
recDos:
    addi a0 a0 -1    	# Disminucion de N en 1
    add t0 a1 zero 	# Preración de argumentos
    add a1 a2 zero 
    add a2 t0 zero
    jal zero chamoy	# Regreso a funcion principal
    

finChamoy:		
    jal ra lectura	# Llamada a la obtencion de datos
    lw ra 16(sp)	# Obtencion de direccion de llamada
    addi sp sp 20    	# Liberacion del espacio en stack
    jalr zero ra 0    	# Regreso a la anterior llamada
       
lectura:
    lw a0 12(sp)	# Obtencion de N
    lw a1 8(sp)		# Obtencion de origen
    lw a2 4(sp)		# Obtencion de pivote
    lw a3 0(sp)		# Obtencion de destino
    jalr zero ra 0	# Regreso desde su llamada
    

casoBase:
    jal ra moverDisco	# Mover disco desde origen a destino
    jal zero finChamoy	# Obtencion de datos


#Meter en el destino el disco del origen, de a1 a a3
moverDisco:    	
    #Extraccion del disco
    addi t0 zero 0    	# Numero a comparar
    bne a1 t0 16       	# Condicion de salto
    addi s2 s2 -4      	# Movimiento en la torre
    lw t1 0(s2)         # Obtencion del disco
    sw zero 0(s2)      	# Limpieza del espacio
    
    addi t0 zero 1    	# x2 
    bne a1 t0 16        
    addi s3 s3 -4       
    lw t1 0(s3)        
    sw zero 0(s3)        
    
    addi t0 zero 2     	# x3   
    bne a1 t0 16        
    addi s4 s4 -4       
    lw t1 0(s4)        
    sw zero 0(s4)       
    
    # Colocacion del disco
    addi t0 zero 0    	# Numero a comparar
    bne a3 t0 12        # Condicion de salto
    sw t1 0(s2)        	# Guardado del disco
    addi s2 s2 4        # Final de la torre
    
    addi t0 zero 1   	# x2
    bne a3 t0 12     
    sw t1 0(s3)    
    addi s3 s3 4    
    
    addi t0 zero 2    	# x3
    bne a3 t0 12    
    sw t1 0(s4)     
    addi s4 s4 4    
    
    jalr zero ra 0    	# Regreso a donde se llamo
    
error:
exit:
    add zero zero zero	# Final del codigo