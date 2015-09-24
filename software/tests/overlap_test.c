#include <stdio.h>
#include "../constants.h"

int check_overlap(unsigned char* wall, unsigned char* bin_img){
	
	/*
	*	Check for overlap between bin_img and wall
	*/
	int i;
	for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	    if (wall[i] & bin_img[i]) return 1;
	}	
	return 0;
	/*
	*	return true/false
	*/
}

int percentage_overlap(unsigned char* wall, unsigned char* bin_img)
{
    int pixels_overlapping = 0;
    int i;
    unsigned int bit;
    for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	for (bit = 1; bit <= 128; bit = bit << 1) {
	    if (wall[i] & bin_img[i] & bit) pixels_overlapping++;
	}
    }
    return (100*pixels_overlapping) / (BINARY_IMAGE_SIZE * 8.0);
}

int main(int argc, char *argv[])
{
    unsigned char wall1[WALL_SIZE];
    unsigned char bin_img1[BINARY_IMAGE_SIZE];

    int i;
    for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	wall1[i] = 255;
	bin_img1[i] = 1;
    }
    //bin_img1[480] = 1;

    int ok = percentage_overlap(wall1, bin_img1);
    printf("overlap: %d\n", ok);
}


