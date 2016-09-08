//
//  population.h
//  GeneticCalendarPlanner
//
//  Created by Tomas Van Roose on 07/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

#ifndef population_h
#define population_h

#include <stdio.h>

int* generate_random_population(int **playable_dates, int *playable_date_sizes, int team_size);

double fitness(int *population, int population_size, int team_size, int prefered_days_consecutive, int prefered_days_return);

void mutate(float chance, int *population, int population_size, int **playable_dates, int *playable_date_sizes, int team_size);

#endif /* population_h */
