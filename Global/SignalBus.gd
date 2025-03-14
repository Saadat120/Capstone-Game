extends Node

signal playerHealthChanged(newHealth: int)
signal enemyHealthChanged(newHealth: int)
signal applyBleed(target: CharacterBody2D, damagePerSec: int, timeEffect: int)
signal playerEnterArena(player: CharacterBody2D)
signal bossDefeated()
