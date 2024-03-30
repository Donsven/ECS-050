//
//  wrev.c
//  Homework #0
//
//  Created by Nelson Lee on 10/2/23.
//

#include <stdio.h>
#include <string.h>

void reverse(char *sentence){
    int length = strlen(sentence);
    
    char *first = sentence;
    char *last = sentence + length - 1;
    while (first < last){
        char temp = *first;
        *first = *last;
        *last = temp;
        first++;
        last--;
    }
    
    char *charFirst = sentence;
    char *charLast = sentence;
    
    while(*charLast){
        while(*charLast && *charLast != ' '){
            charLast++;
        }
        
        first = charFirst;
        last = charLast - 1;
        while(first < last){
            char temp = *first;
            *first = *last;
            *last = temp;
            first++;
            last--;
        }
        
        if(*charLast == ' '){
            charFirst = charLast + 1;
            charLast++;
        }else{
            break;
        }
    }
}

int main(){
    char sentence[100];
    
    printf("Please enter a sentence to be reversed: ");
    fgets(sentence, sizeof(sentence), stdin);
    
    sentence[strcspn(sentence, "\n")] = '\0';
    
    reverse(sentence);
    
    printf("Reversed sentence is: %s\n", sentence);
    
    return 0;
}
