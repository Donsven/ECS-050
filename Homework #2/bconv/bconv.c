//
//  main.c
//  bconv
//
//  Created by Nelson Lee on 10/19/23.
//

#include <stdio.h>
#include <string.h>
#include <math.h>


//I have no clue why hex letter input doesn't work here
void convertUnsigned(int num, int baseFrom, int baseTo) {
    char converted[32];
    int index = 0;
    
    // Convert the number from base 'baseFrom' to base 10
    int base10Num = 0;
    int power = 1;
    int originalNum = num;
    
    while (num > 0) {
        int digit = num % 10;
        base10Num += digit * power;
        power *= baseFrom;
        num /= 10;
    }
    if (originalNum == 0) {
        printf("0\n");
        return;
    }

    // Convert the base 10 number to the desired base 'baseTo'
    while (base10Num > 0) {
        int digit = base10Num % baseTo;
        converted[index++] = digit < 10 ? digit + '0' : digit - 10 + 'A';
        base10Num /= baseTo;
    }

    // Print the result in reverse order
    for (int i = index - 1; i >= 0; i--) {
        printf("%c", converted[i]);
    }
    printf("\n");
}


void convertSigned(int num) {
    if (num < 0) {
        unsigned int absNum = (unsigned int)(-num);
        unsigned int signMagnitude = absNum | 0x80000000;
        printf("%08X\n", signMagnitude);

           
        unsigned int twosComplement = ~absNum + 1;
        printf("%08X\n", twosComplement);
    } else {
        printf("%08X\n", num);
        printf("%08X\n", num);
    }
}

//For some reason all the cases work except for the large negative floating point number
void convertFloat(float num) {
    if (num == 0.0) {
        printf("0 E0\n");
        return;
    }
    
    int sign = (num < 0) ? -1 : 1;
    num = fabsf(num);
    
    int exponent = 0;
    float mantissa = num;
    
    while (mantissa >= 2.0) {
        mantissa /= 2.0;
        exponent++;
    }
    
    while (mantissa < 1.0) {
        mantissa *= 2.0;
        exponent--;
    }
    
    printf("%c1.", (sign == -1) ? '-' : ' ');
    mantissa -= 1.0;
    
    for (int i = 0; i < 23; i++) {
        mantissa *= 2.0;
        int bit = (int)mantissa;
        printf("%d", bit);
        mantissa -= bit;
    }
    
    //shift exponent to remove padding 0's, this was super important!!
    char exponentBinary[9];
        int shift = 7;
        int count = 0;

        while (shift >= 0) {
            int bit = (exponent >> shift) & 1;
            if (bit || count > 0) {
                exponentBinary[count++] = bit + '0';
            }
            shift--;
        }

        exponentBinary[count] = '\0';

        printf(" E%s\n", exponentBinary);
}

int main(int argc, char *argv[]) {
    
    if (argc != 2) {
            printf("Usage: %s <conversion_type>\n", argv[0]);
            return 1;
        }

        if (strcmp(argv[1], "unsigned") == 0) {
            // Conversion for unsigned integers
            unsigned int num;
            int baseFrom, baseTo;
            scanf("%u", &num);
            scanf("%d", &baseFrom);
            scanf("%d", &baseTo);
            convertUnsigned(num, baseFrom, baseTo);
        } else if (strcmp(argv[1], "signed") == 0) {
            // Conversion for signed integers
            int num;
            scanf("%d", &num);
            convertSigned(num);
        }else if (strcmp(argv[1], "float") == 0) {
            // Conversion for floating-point numbers
            float num;
            scanf("%f", &num);
            convertFloat(num);
        }
    return 0;
}

