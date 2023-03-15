#!/bin/bash
TIME_LIMIT=90
INSTANCE_DIRECTORY="./test_instances/"
STRATEGY="NeuralNetwork"
RESULT_DIRECTORY="./results/results_test/"
INSTANCE_SEEDS="10000"
DIR_MODELS="../training/models/"


FEATURE_SET="dynamicstatic"
SAMPLESIZE=50
NUMINSTANCES=15
RUNTIMESTRATEGY=3600

declare -A array_learning_iteration
readarray -t lines < "./src/read_in_learning_iteration.txt"
for line in "${lines[@]}"; do
   array_learning_iteration[${line%%=*}]=${line#*=}
done

INSTANCE_SEEDS="10031 10032 10033 10034 10035 10036 10037 10038 10039 10040 10041 10042 10043 10044 10045 10046 10047 10048 10049 10050 10001 10002 10003 10004 10005 10006 10007 10008 10009 10010 10011 10012 10013 10014 10015 10016 10017 10018 10019 10020 10021 10022 10023 10024 10025 10026 10027 10028 10029 10030"

# BASE CASE
ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
sbatch --job-name="tbase" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh



# EXPERIMENT 0 
for STRATEGY in "rolling_horizon" "monte_carlo" "oracle" "greedy" "random" "lazy"
do
	if [[ ${STRATEGY} == "oracle" ]]; then
		TIME_LIMIT=3600
	elif [[ ${STRATEGY} == "monte_carlo" || ${STRATEGY} == "rolling_horizon" ]]; then
    		TIME_LIMIT=600
	else
		TIME_LIMIT=90
	fi
	ITERATION=-1
	sbatch --job-name="texp0" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
STRATEGY="NeuralNetwork"
TIME_LIMIT=90
sleep 1


# EXPERIMENT 1 
for SAMPLESIZE in 10 25 75 100
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp1" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
SAMPLESIZE=50
sleep 1


# EXPERIMENT 2
for NUMINSTANCES in 1 2 5 10 20 25 30
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp2" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
NUMINSTANCES=15
sleep 1


# EXPERIMENT 3
for RUNTIMESTRATEGY in 60 120 180 240 300 900 "bestSeed"
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp3" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
RUNTIMESTRATEGY=3600
sleep 1


# EXPERIMENT 4
for FEATURE_SET in "static" "dynamic"
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp4" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
FEATURE_SET="dynamicstatic"
sleep 1


# EXPERIMENT 5
for STRATEGY in  "GraphNeuralNetwork" "Linear" "GraphNeuralNetwork_sparse"
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp5" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$TIME_LIMIT,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
STRATEGY="NeuralNetwork"


# EXPERIMENT 6
for RUNTIME in 30 60 120 180 240
do
	ITERATION=${array_learning_iteration["${STRATEGY}_samples-${SAMPLESIZE}_instances-${NUMINSTANCES}_runtime-${RUNTIMESTRATEGY}_featureset-${FEATURE_SET}"]}
	sbatch --job-name="texp6" --export=STRATEGY=$STRATEGY,TIME_LIMIT=$RUNTIME,INSTANCE_DIRECTORY=$INSTANCE_DIRECTORY,RESULT_DIRECTORY=$RESULT_DIRECTORY,INSTANCE_SEEDS="${INSTANCE_SEEDS}",DIR_MODELS=$DIR_MODELS,TRAINING_ITERATIONS="${ITERATION}",SAMPLESIZE=$SAMPLESIZE,NUMINSTANCES=$NUMINSTANCES,RUNTIMESTRATEGY=$RUNTIMESTRATEGY,FEATURE_SET=$FEATURE_SET run_solve_bound.sh
done
RUNTIME=90





