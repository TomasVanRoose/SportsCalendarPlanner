//
//  population.c
//  GeneticCalendarPlanner
//
//  Created by Tomas Van Roose on 07/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

#include "population.h"

#include <stdlib.h>
#include <math.h>
#include <limits.h>

void shuffle(int *array, int n) {
    
    if (n > 1) {
        int i;
        for (i = 0; i < n - 1; i++) {
            int j = i + rand() / (RAND_MAX / (n - i) + 1);
            int t = array[j];
            array[j] = array[i];
            array[i] = t;
        }
    }
}

void choose_random(int *chosen, int size, int *array, int arraySize)
{
    
    shuffle(array, arraySize);
    
    for (int i = 0; i < size; i++) {
        chosen[i] = array[i];
    }
}


int* generate_random_population(int **playable_dates, int *playable_date_sizes, int team_size) {
    
    int population_size = team_size * (team_size - 1);
    int *population = calloc(population_size, sizeof(int));
    
    for (int i = 0; i < team_size; i++) {
        choose_random((population + (i * (team_size - 1))), team_size - 1, playable_dates[i], playable_date_sizes[i]);
    }
    
    return population;
}

double fitness(int *population, int population_size, int team_size, int prefered_days_consecutive, int prefered_days_return) {
    
    
    double fitness;
    
    // check for every game how far the closest game is
    for (int i = 0; i < population_size; i++) {
        
        int date = population[i];
        int least_days = INT_MAX;
        
        for (int j = 0; j < team_size - 1; j++) {
            
            int other_date;
            
            if (j < (i % (team_size - 1))) {
                other_date = population[(j * (team_size - 1)) + (i / (team_size -1))];
            } else {
                other_date = population[j * (team_size - 1)];
            }
            
            int days_between = abs(date - other_date);
            
            if (days_between < least_days) {
                least_days = days_between;
            }
        }
        
        if (least_days < prefered_days_consecutive) {
            fitness += pow((double)least_days / (double)prefered_days_consecutive * 100, 2);
        } else {
            fitness += 9900 + (((double)least_days / (double)prefered_days_consecutive) * 100);
        }
    }
    
    return fitness;
}


void mutate(float chance, int *population, int population_size, int **playable_dates, int *playable_date_sizes, int team_size) {
    
    int treshold = chance * 1000;
    
    for (int i = 0; i < team_size; i++) {
        if (arc4random_uniform(1000) <= treshold) {
            choose_random((population + (i * (team_size - 1))), team_size - 1, playable_dates[i], playable_date_sizes[i]);
        }
    }
    
}


