FROM python:3.13-slim

# Empêche Python d'écrire des fichiers .pyc et force l'affichage immédiat des logs
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /code

# Installation des dépendances avant la copie du code pour optimiser le cache Docker
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copie du code applicatif
COPY ./app /code/app

# Création d'un utilisateur non-privilégié
RUN adduser --disabled-password --gecos "" appuser && chown -R appuser /code
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]