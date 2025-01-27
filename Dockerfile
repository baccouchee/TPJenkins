# Utilisation de l'image officielle Python
FROM python:3.13.0-alpine3.20

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier le script Python dans le conteneur
COPY sum.py /app/sum.py

# Commande par défaut pour que le conteneur reste actif
CMD ["tail", "-f", "/dev/null"]
