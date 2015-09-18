/*
*	I'm not sure if threading is even possible on the board without using multiple cores?
*	For now I'll assume that threading is not worth it and go with this as a "Master class".
*/
#include <time.h>
#include <stdlib.h>
#include <stdbool.h>

#include "image_cleanup.h"
#include "overlap_detect.h"

#define WALLCOUNT 3
#define SCALING_FACTOR 10

//wall size in bytes
#define WALL_SIZE 6*480/SCALING_FACTOR



/*
*	Wall data strucure: Draw until 1st column, start again at 2nd column and draw until 3rd column ... 
*	one wall = 8 * 6 * 480 * SCALING_FACTOR bits
*	---------------- 255,	255,	255,	255,	255,	255
*	---------------- 255,	255,	255,	255,	255,	255
*	-----o-o-o------ 5,		6,		7,		8,		9,		10
*	------ooo------- 6,		9,		255,	255,	255,	255
*	-------o-------- 7,		8,		255,	255,	255,	255
*	------o-o------- 6,		7,		8,		9		255,	255
*
*	With this scaling factor the size of the walls will be 2304 bits.
*	This is probably only worth it if can afford to and want to go with higher resolution wall images,
* 	otherwise we might as well go with a 64*48 bit array which would result in 3072 bit images, 
*	if we dont use the entire width of the screen for walls we'll save even less memory.
*/

char* init_walls();

int main(void)
{
	char* wall_sets = init_walls();
	
	char* bin_img = malloc(640*480/8);

	time_t t;
	int curr_wall;
	bool fail;
	
	clock_t end_timer;
	clock_t time_now;
	srand((unsigned) time(&t));
	
	while(1){
		/*
		* Display some starting screen between walls and before first one?
		*/
		
		
		curr_wall = rand() % WALLCOUNT;
		
		/*
		*	send wall image to hardware
		*/
		
		// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		/*	
		*	Wait x seconds before checking for overlap. Display a countdown timer every second?
		*/
		// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		
		
		// ---------------------------------------------------------------
		/*
		* 	Alternative approach, check for overlaps during "downtime" to have real time feedback on
		*	fail och passing state
		*/
		time_now = clock();
		
		/*
		*	The exact timings might have to be adjusted depending on how long it takes to generate the 
		*	binary image	
		*/
		end_timer = clock() + 300000000; // 3 sec delay with 100Mhz clock, 
		
		while(time_now < end_timer){
			unsigned char display_time = ((end_timer - time_now) / 100000000) +1; // countdown timer to be displayed
			
			bool fail = check_overlap(&wall_sets[curr_wall*WALL_SIZE], bin_img);
			
			
		/*
		*	Send fail and display_time to HW to indicate passing or failing state and time remaining.
		*/
			time_now = clock(); // updating the timer
		}
		// ---------------------------------------------------------------
		
		bool fail = check_overlap(&wall_sets[curr_wall*WALL_SIZE], bin_img);
		
		/*
		*		send result and timer(0) to HW (display "FAIL!" || "PASS!" image stored in hw?)
		*		probably add a delay here as well.
		*/
		
	}
	
	
}

char* init_walls(void){
	char* walls = calloc(WALLCOUNT*WALL_SIZE, sizeof(char));
	
	// Create walls
	return walls;
}

