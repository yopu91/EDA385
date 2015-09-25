#include <stdbool.h>
#include "image_cleanup.h"
#include "constants.h"

bool check_overlap(unsigned int* wall, unsigned int* bin_img){
	
	clean_img(bin_img);
	
	/*
	*	Check for overlap between bin_img and wall
	*/
	int i;
	for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	    if (wall[i] & bin_img[i]) return 1;
	}	
	return 0;
}


int percentage_overlap(unsigned int *wall, unsigned int *bin_img) {

    clean_img(bin_img);
    int pixels_overlapping = 0;
    int i;
    unsigned int bit;
    for (i = 0; i < BINARY_IMAGE_SIZE; i++) {
	for (bit = 1; bit <= (1 << 32); bit = bit << 1) {
	    if (wall[i] & bin_img[i] & bit) pixels_overlapping++;
	}
    }
    return (100*pixels_overlapping) / (BINARY_IMAGE_SIZE * 8.0);
}

