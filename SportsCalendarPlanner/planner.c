//
//  planner.c
//  GeneticCalendarPlanner
//
//  Created by Tomas Van Roose on 07/09/16.
//  Copyright © 2016 Tomas Van Roose. All rights reserved.
//

#include <stdlib.h>
#include <time.h>

#include "planner.h"
#include "population.h"

#define SIMULATION_SIZE 500
#define MUTATION_CHANCE 0.01


#define GENERATION_SIZE 1000
#define TOURNAMENT_SIZE 2



void print_array(int *array, int size) {
    
    for (int i = 0; i < size - 1; i++) {
        printf("%d\t", array[i]);
    }
    printf("%d\n", array[size - 1]);
}

void print_population(int *population, int team_size) {
    
    for (int i = 0; i < team_size; i++) {
        printf("Team %d:\n", i);
        print_array((population + (i * (team_size - 1))), team_size - 1);
    }
    printf("\n");
}

int index_of_tournament_selection_winner(int tournament_size, double *array, int array_size) {
    
    int index = - 1;
    
    for (int i = 0; i < tournament_size; i++) {
        int random_index = arc4random_uniform(array_size);
        
        if (index == -1 || array[random_index] > array[index]) {
            index = random_index;
        }
    }
    
    return index;
}

int index_of_max_element(double *array, int array_size) {
    
    int index = 0;
    
    for (int i = 0; i < array_size; i++) {
        if (array[i] > array[index]) {
            index = i;
        }
    }
    
    return index;
}


int* plan_calendar(int **playable_dates_per_team, int *playable_date_sizes, int team_size, int prefered_days_between_consecutives, int prefered_days_between_returns) {
    
    srand((uint)time(NULL));
    
    // one population will always be n(n-1) games
    int population_size = team_size * (team_size - 1);
    
    // initialize generation
    int *generation[2 * GENERATION_SIZE];
    double generation_fitness[2 * GENERATION_SIZE];
    
    for (int i = 0; i < GENERATION_SIZE; i++) {
    
        int *random_population = generate_random_population(playable_dates_per_team, playable_date_sizes, team_size);
        generation_fitness[i] = fitness(random_population, population_size, team_size, prefered_days_between_consecutives, prefered_days_between_returns);
        generation[i] = random_population;
    }
    
    for (int i = GENERATION_SIZE; i < GENERATION_SIZE*2; i++) {
        generation[i] = calloc(population_size, sizeof(int));
    }
    
    int index_of_fittest = 0;
    
    for (int k = 0; k < SIMULATION_SIZE; k++) {
        
        int amount_of_children = 0;
        
        while (amount_of_children < GENERATION_SIZE) {
            
            int *first_child = generation[amount_of_children + GENERATION_SIZE];
            int *second_child = generation[amount_of_children + GENERATION_SIZE + 1];
            
            int father_index = index_of_tournament_selection_winner(TOURNAMENT_SIZE, generation_fitness, GENERATION_SIZE);
            int mother_index = index_of_tournament_selection_winner(TOURNAMENT_SIZE, generation_fitness, GENERATION_SIZE);
            
            one_point_crossover(first_child, second_child, generation[father_index], generation[mother_index], population_size, team_size);
            
            mutate(MUTATION_CHANCE, first_child, population_size, playable_dates_per_team, playable_date_sizes, team_size);
            mutate(MUTATION_CHANCE, second_child, population_size, playable_dates_per_team, playable_date_sizes, team_size);

            generation_fitness[amount_of_children + GENERATION_SIZE] = fitness(first_child, population_size, team_size, prefered_days_between_consecutives, prefered_days_between_returns);
            
            amount_of_children++;
            
            generation_fitness[amount_of_children + GENERATION_SIZE] = fitness(second_child, population_size, team_size, prefered_days_between_consecutives, prefered_days_between_returns);
            
            amount_of_children++;
        }
        
        index_of_fittest = index_of_max_element(generation_fitness, GENERATION_SIZE * 2);
        
        // Keep best fit always for next generation
        int *tmp = generation[index_of_fittest];
        int fittmp = generation_fitness[index_of_fittest];
        generation[index_of_fittest] = generation[0];
        generation_fitness[index_of_fittest] = generation_fitness[0];
        generation[0] = tmp;
        generation_fitness[0] = fittmp;
        
        
        // pick survivors and move them to the first GEN_SIZE spot
        for (int i = 1; i < GENERATION_SIZE; i++) {
            
            int survivor_index = index_of_tournament_selection_winner(TOURNAMENT_SIZE, (generation_fitness + i), (GENERATION_SIZE*2) - i) + i;
            
            int *tmp_survivor = generation[survivor_index];
            int tmp_fitness = generation_fitness[survivor_index];
            
            generation[survivor_index] = generation[i];
            generation_fitness[survivor_index] = generation_fitness[i];
            
            generation[i] = tmp_survivor;
            generation_fitness[i] = tmp_fitness;
            
        }
        
        printf("Generation %d:\t%d\t%f\n", k, index_of_fittest, generation_fitness[0]);
                
    }
    
    fitness(generation[0], population_size, team_size, prefered_days_between_consecutives, prefered_days_between_returns);
    
    for (int i = 1; i < 2*GENERATION_SIZE; i++) {
        free(generation[i]);
        
    }
    
    return generation[0];
    
}






