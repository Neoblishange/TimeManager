# Utiliser une image Node.js pour construire l'application Vue.js
FROM node:20 AS build

WORKDIR /app

# Copier le fichier package.json et package-lock.json (si vous en avez un)
COPY package*.json ./

# Installer les dépendances
RUN npm install

# Exposer le port 8081 pour le mode développement
EXPOSE 8081

COPY . .

# Démarrer l'application en mode développement
CMD ["npm", "run", "dev"]