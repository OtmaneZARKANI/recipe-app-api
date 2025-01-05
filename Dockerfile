FROM python:3.9-alpine3.13
LABEL maintainer="otmaneapp.com"

# Utilisation de la nouvelle syntaxe ENV
ENV PYTHONUNBUFFERED=1

# Copier les fichiers nécessaires
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# Étape 1: Créer l'environnement virtuel
RUN python -m venv /py

# Étape 2: Mettre à jour pip
RUN /py/bin/pip install --upgrade pip

# Étape 3: Installer les dépendances
RUN /py/bin/pip install -r /tmp/requirements.txt
RUN if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi

# Étape 4: Supprimer le fichier temporaire
RUN rm -rf /tmp

# Étape 5: Créer l'utilisateur
RUN adduser --disabled-password --no-create-home django-user

# Définir le chemin pour l'environnement virtuel
ENV PATH="/py/bin:$PATH"

# Passer à l'utilisateur créé
USER django-user
