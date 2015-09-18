#include <stdbool.h>
#include "image_cleanup.h"

bool check_overlap(char* wall, char* bin_img){
	
	clean_img(bin_img);
	
	/*
	*	Check for overlap between bin_img and wall
	*/
	int i;
	int end = strlen(bin_img);
	for (i = 0; i < end; i++) {
	    if (*wall & *bin_img) return true;
	    wall++;
	    bin++;
	}	
	return false;
	/*
	*	return true/false
	*/
}
