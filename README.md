# Biologically Inspired UAV Guidance Using Reinforcement Learning

## Abstract

This project uses reinforcement learning (RL) with actor-critic model to instill flocking behaviour in drones based on biological models. This involved: 

- Developing a simulation of multi-agent systems in an environment  that incorporates potential field functions and boid flocking behavior.
- Formulating an effective loss function
- Designing a  custom reward function that uses exponential variations to ensure flocking within set steps
- Drones are directed through gains that boost specific behaviours, with the goal to maximize long-term rewards. 

This work highlights RL's promise in UAV systems and suggests transitioning to a more scalable multi-agent environment.

<div align="center">

:book: For a comprehensive overview, refer to the [dissertation document](https://github.com/oscell/Biologically-inspired-UAV/blob/main/assets/Documents/Biologically_inspired_UAV.pdf). :book:

</div>

## Overview

This project delves into the intricacies of using reinforcement learning to guide UAVs, drawing inspiration from biological models. The environment is constructed using potential field functions and boid flocking behavior, and the agent learns to control drones by adjusting gains that amplify specific behaviors.

## Methods

The methods employed include:


- Incorporating the boid flocking model with separation, alignment, and cohesion behaviors.


<div align="center">

| Separation | Alignment | Cohesion |
|:----------------:|:----------------:|:----------------:|
| <img src="assets/Images/Separation.png" width="200"> | <img src="assets/Images/Alingment.png" width="200"> | <img src="assets/Images/Cohesion.png" width="200"> |

</div>

- Utilizing the actor-critic RL model to learn gains that control flocking behavior.
- Layering potential field functions for attraction to destinations.
- Designing a custom environment and reward shaping to foster flocking and ensure drones reach their destinations.

<div align="center">

| Rewared Function | Potential Field  |
|:----------------:|:----------------:|
| <img src="assets\Images\RewardFunctionscaled9.jpg" width="300"> | <img src="assets/Images/EndByitself.jpg" width="300"> 

</div>

## Results

The project's outcomes are:

- The RL agent successfully learns the emergent flocking behavior of drones.
- The significance of reward shaping in promoting desired behaviors is highlighted.
- Certain challenges, such as some drones not reaching their destinations, underscore the need for further refinement of the reward function.

### Trained Agent

<img src="assets/Images/TrainedAgent.PNG" width="400">

## Future Work

Potential avenues for future exploration:

- Transition to a decentralized multi-agent approach to enhance the RL structure.
- Enrich the environment dynamics and introduce obstacles.
- Boost simulation speed using techniques like quad trees.
- Refine the reward function to rectify any undesirable behaviors.

## Repository Contents

[Matlab Simulation](https://github.com/oscell/Biologically-inspired-UAV/blob/main/MATLAB): The custom environment and the RL agent.

[Dissertation](https://github.com/oscell/Biologically-inspired-UAV/blob/main/assets/Documents/Biologically_inspired_UAV.pdf): The primary document detailing the research, methodology, and findings.
## Setup & Installation

```bash
git clone --recursive https://github.com/oscell/Biologically-inspired-UAV.git
```

## Reference

Meunier, Oscar. "Biologically inspired UAV guidance: Using reinforcement learning to optimize flocking behaviour." University of Glasgow, 2022.
