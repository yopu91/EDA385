#include <stdbool.h>
#include "image_cleanup.h"
#include "constants.h"

bool check_overlap(char* wall, char* bin_img){
	
	clean_img(bin_img);
	
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
	/*
	*	return true/false
	*/
}
