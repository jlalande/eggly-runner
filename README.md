# Eggly Runner

Jeu runner mono-voie en **Love2D** : un œuf issu d’une espèce animale court dans une forêt en parallaxe. Le MVP pilote la **Poule des bois** (saut simple).

## Prérequis

- [Love2D](https://love2d.org/) 11.x (testé avec 11.5)

### Installation rapide

**Ubuntu / Debian :**

```bash
sudo apt-get update
sudo apt-get install -y love
```

**macOS (Homebrew) :**

```bash
brew install love
```

**Windows :** télécharger l’installateur sur [love2d.org](https://love2d.org/).

Vérifier :

```bash
love --version
```

## Lancer le jeu

Depuis la racine du dépôt :

```bash
love .
```

## Contrôles

| Action | Touches |
|--------|---------|
| Démarrer / rejouer | Entrée, Espace, clic |
| Sauter | Espace, ↑, W, clic |
| Menu | Échap |

## Contenu MVP

- États : menu → course → game over
- Espèce starter data-driven (`src/data/species.lua`) + habileté `jump`
- Stubs documentés : grenouille (double saut), kangourou (saut haut)
- Course auto, obstacles, collisions AABB, score / meilleur score
- Parallaxe forêt : ciel, arbres lointains, sous-bois, sol
- Sprites pixel art (filtre nearest-neighbor)

## Structure

```
conf.lua / main.lua
src/data/species.lua
src/abilities/          # jump + stubs
src/states/             # menu, play, gameover
src/entities/           # player, obstacle, spawner
src/world/parallax.lua  # couches sky / far / mid / ground
assets/sprites/         # PNG pixel art
```

## Régénérer les sprites

```bash
python3 scripts/generate_sprites.py
```
