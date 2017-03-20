LIST   P=PIC16F1825
#include "p16f1825.inc"

; CONFIG1
; __config 0x2FEC
 __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_SWDTEN & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_ON
; CONFIG2
; __config 0x3EFF
 __CONFIG _CONFIG2, _WRT_OFF & _PLLEN_OFF & _STVREN_ON & _BORV_LO & _LVP_ON


RES_VECT  CODE    0x0000            ; processor reset vector
    GOTO    START                   ; go to beginning of program

Isr:
    
 retfie

MAIN_PROG CODE                      ; let linker place main program

START
 
 banksel OSCCON
 clrf OSCCON		    ;Fosc set to 31kHz
 movlw B'00000010'	    
 movwf TRISC		    ;Set bit 1 as input, rest are outputs
 movlw 0x24
 movwf WDTCON		    ;Set WDT to 256s intervals, WDT is turned OFF
 banksel SSP1CON1
 movlw 0x21
 movwf SSP1CON1		    ;Set SPI mode with Fosc/16 sck
 
 banksel PIR1
 bcf PIR1,3		    ;Clear SPI Interrupt flag
 banksel PIE1
 bsf PIE1,3		    ;Enable SPI interrupt
 banksel INTCON
 bsf INTCON,7		    ;Enable Global Interrupt

Loop:
    
    
 GOTO Loop                          ; loop forever

    END