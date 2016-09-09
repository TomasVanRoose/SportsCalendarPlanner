//
//  planner.h
//  GeneticCalendarPlanner
//
//  Created by Tomas Van Roose on 07/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

#ifndef planner_h
#define planner_h

#include <stdio.h>

int* plan_calendar(int **playable_dates_per_team, int *playable_date_sizes, int team_size, int prefered_days_between_returns, int prefered_days_between_consecutives);



#endif /* planner_h */
