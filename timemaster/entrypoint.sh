#!/bin/bash

# Attendre que le service de base de données soit prêt
until mix ecto.create
do
  echo "Attente que le service de base de données soit prêt..."
  sleep 2
done

# Vérifier si la base de données existe
if mix ecto.migrate --check
then
  echo "La base de données existe déjà. Pas besoin de la recréer."
else
  # Créer la base de données si elle n'existe pas
  echo "La base de données n'existe pas. Création en cours..."
  mix ecto.create
  mix ecto.migrate
fi

# Démarrer l'application Phoenix
mix phx.server
