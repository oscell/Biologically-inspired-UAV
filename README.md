# Biologically Inspired UAV Guidance

This project uses reinforcement learning (RL) to develop flocking behaviour in drones to organise groups of UAVs using biologically inspired behavioural models.

```bash
git clone --recursive https://github.com/oscell/Biologically-inspired-UAV.git
```

## Methods

The methods used include:

- Potential field functions for attraction to destinations
- Boid flocking model with separation, alignment, and cohesion behaviors
- Actor-critic RL model to learn gains to control flocking behavior 
- Custom environment and reward shaping to encourage flocking and reaching destinations

## Results

The results demonstrate:

- Emergent flocking behavior of drones can be learned by an RL agent
- Reward shaping is important to promote desired behaviors
- Issues like some drones not reaching destinations highlight need for further reward function tuning

## Future Work

Suggestions for future work:

- Improve ML structure by using decentralized multi-agent approach
- Expand environment dynamics and obstacles
- Optimize simulation speed with methods like quad trees
- Refine reward function to address undesirable behaviors

## Reference

Meunier, Oscar. "Biologically inspired UAV guidance: Using reinforcement learning to optimize flocking behaviour." University of Glasgow, 2022.