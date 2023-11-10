FROM elixir:1.14

# Installer Hex et Phoenix
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix archive.install hex phx_new 1.6.2 --force

# Créer un répertoire pour votre application et définissez-le comme le répertoire de travail
RUN mkdir app
COPY . ./app
WORKDIR /app

# Copiez les fichiers de configuration et installez les dépendances Elixir
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copiez le script de démarrage
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Commande pour démarrer votre application Phoenix avec le script de démarrage
CMD ["./entrypoint.sh"]