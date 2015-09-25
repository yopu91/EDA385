/*
*	I'm not sure if threading is even possible on the board without using multiple cores?
*	For now I'll assume that threading is not worth it and go with this as a "Master class".
*/
#include <time.h>
#include <stdlib.h>
#include <stdbool.h>

#include "image_cleanup.h"
#include "overlap_detect.h"
////////////////////////////////////////////////////////
#include "xuartlite_l.h"
#include "xparameters.h"
#include "xtmrctr.h"
////////////////////////////////////////////////////////
#define TMRCTR_DEVICE_ID	XPAR_TMRCTR_0_DEVICE_ID
#define TIMER_COUNTER_0	 0

#define WALLCOUNT 3
#define SCALING_FACTOR 10

//wall size in bytes
#define WALL_SIZE 6*480/SCALING_FACTOR
#define BINARY_IMAGE_SIZE 640*480/8
// Timing shizzle
/*
int Status;
	u32 Value1;
	u32 Value2;
	XTmrCtr TimerCounter;
	XTmrCtr *TmrCtrInstancePtr = &TimerCounter;
	Status = XTmrCtr_Initialize(TmrCtrInstancePtr, TMRCTR_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_COUNTER_0,
			XTC_AUTO_RELOAD_OPTION);

	Value1 = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);

	XTmrCtr_Start(TmrCtrInstancePtr, TIMER_COUNTER_0);
	//--- divide here
	Value2 = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);

	XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_COUNTER_0, 0);
	xil_printf("cycles: %d\n", Value2 - Value1);
*/






/*
*	Wall data strucure: Draw until 1st column, start again at 2nd column and draw until 3rd column ...
*	one wall = 8 * 6 * 480 / SCALING_FACTOR bits
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

unsigned char* init_walls();

int main(void)
{

	int Status;
		u32 time_now;
		u32 end_timer;
		XTmrCtr TimerCounter;
		XTmrCtr *TmrCtrInstancePtr = &TimerCounter;
		Status = XTmrCtr_Initialize(TmrCtrInstancePtr, TMRCTR_DEVICE_ID);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}
		XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_COUNTER_0,
				XTC_AUTO_RELOAD_OPTION);

	/*
	*	Protocol for sending data to HW
	*	bit#	0-23 Necessary padding?			0-1								2								3-6								7
	*															"Special Image"		Wall Available		Timer to display	 Pass/Fail
	*	If the Wall Available bit it set, the protocol message is followed by the wall image
	*/

	/*
	*	"Special images"
	*	11000000	-	Startscreen
	*/


	unsigned char protocol = 192; // 11000000
	putfsl(protocol, 0);

	unsigned int* wall_sets = init_walls();

	unsigned char bin_img[BINARY_IMAGE_SIZE];

	time_t t;
	int curr_wall;
	bool fail;

	//what seed to use? maybe use the binary camera image somehow?
//	srand((unsigned) time(&t));

	while(1){
		/*
		* Create a 2 second delay between walls
		*/
		time_now = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);
		end_timer = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0) + 200000000;
		XTmrCtr_Start(TmrCtrInstancePtr, TIMER_COUNTER_0);

		//busy wait, how to fix?
		while(time_now < end_timer){
			time_now = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);
		}
		XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_COUNTER_0, 0);

		curr_wall_index = rand() % WALLCOUNT;

		/*
		*	send wall image to hardware
		*/
		protocol = 38;			// 00100110
		putfsl(protocol, 0);
		curr_wall = &(wall_sets+curr_wall_index*WALL_SIZE);
		for(int i = 0; i<WALL_SIZE/4, i++){
			putfsl(curr_wall+i, 0);
		}


		/*
		*	The exact timings might have to be adjusted depending on how long it takes to generate the
		*	binary image
		*/

		/*	Timer for non-board
		end_timer = clock() + 300000000; // 3 sec delay with 100Mhz clock,
		*/

		/*	Timer for board
		*/
		time_now = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);
		end_timer = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0) + 300000000;
		XTmrCtr_Start(TmrCtrInstancePtr, TIMER_COUNTER_0);
		while(time_now < end_timer){
			unsigned char display_time = ((end_timer - time_now) / 100000000) + 1; // countdown timer to be displayed
			bool fail = check_overlap(&wall_sets[curr_wall*WALL_SIZE], bin_img);
		/*
		*	Send fail and display_time to HW to indicate passing or failing state and time remaining.
		*/
		protocol = (display_time << 1) | fail;	 // 000TTTTF
		putfsl(protocol, 0);
		/*	Timer for non-board
			time_now = clock(); // updating the timer
		*/

		/*	Timer for board
		*/
			time_now = XTmrCtr_GetValue(TmrCtrInstancePtr, TIMER_COUNTER_0);
		}
		XTmrCtr_SetOptions(TmrCtrInstancePtr, TIMER_COUNTER_0, 0);
		// ---------------------------------------------------------------

		bool fail = check_overlap(&wall_sets[curr_wall*WALL_SIZE], bin_img);

		/*
		*		send result and timer(0) to HW (display "FAIL!" || "PASS!" image stored in hw?)
		*		probably add a delay here as well.
		*/
		protocol = 0 | fail;
		putfsl(protocol, 0);
	}


}

unsigned int* init_walls(void){
	unsigned int* walls = calloc(WALLCOUNT*WALL_SIZE, sizeof(unsigned char));

	// Create walls
	return walls;
}
