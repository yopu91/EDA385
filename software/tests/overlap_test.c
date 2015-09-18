#include <stdio.h>
#include "../constants.h"

int check_overlap(char* wall, char* bin_img){
	
	/*
	*	Check for overlap between bin_img and wall
	*/
	int i;
	for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	    if (*wall & *bin_img) return 1;
	    wall++;
	    bin_img++;
	}	
	return 0;
	/*
	*	return true/false
	*/
}

int main(int argc, char *argv[])
{
    char wall1[WALL_SIZE];
    char bin_img1[BINARY_IMAGE_SIZE];
    
    int i;
    for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	wall1[i] = 255;
	bin_img1[i] = 0;
    }
    //bin_img1[480] = 1;

    int ok = check_overlap(wall1, bin_img1);
    printf("overlap: %d\n", ok);
}


