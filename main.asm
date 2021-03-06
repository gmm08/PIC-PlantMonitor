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
 movlw B'00000110'	    
 movwf TRISA 
 movlw B'00000110'
 movwf ANSELA		    ;RA1 and RA2 set to Analog input
 movlw B'00000010'
 movwf TRISC		    ;Set bit 1 as input, rest are outputs
 movlw 0x24
 movwf WDTCON		    ;Set WDT to 256s intervals, WDT is turned OFF
 banksel SSP1CON1
 movlw 0x21
 movwf SSP1CON1		    ;Set SPI mode with Fosc/16 sck
 
 banksel PIR1
 clrf PIR1		    ;Clear SPI and ADC Interrupt flag
 banksel PIE1
 movlw B'01001000'	    
 movwf PIE1		    ;Enable SPI and ADC interrupt
 banksel INTCON
 movlw B'01000000'
 movwf INTCON		    ;Enable Peripheral Interrupt

 banksel ADCON0
 movlw B'00000100'	    ;Channel set to AN1, ADC is disabled
 movwf ADCON0
 banksel ADCON1
 movlw B'01110000'	    ;Left justified result, Frc osc selected, Vdd Vss references selected
 movwf ADCON1
 
Loop:
    
    ;TO DO
    
    ;read ADC and sleep until conversion is finished
    banksel ADCON0
    bsf ADCON0,0	    ;ADC is enabled
    bsf ADCON0,1	    ;Conversion started
    sleep
    movlw 0x00		    
    movwf FSR0L		    ;Load low byte of FSR0
    movlw 0x20
    movwf FSR0H		    ;Load high byte of FSR0
    movf ADRESH,W	    ;Conversion result moved to w
    movwi FSR0++	    ;Move W to Indirect Adressing Register
    
    ;send data
    
    ;Go to sleep
    
    
 GOTO Loop                          ; loop forever

Send:
 
 
    END