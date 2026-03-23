# Backend AgrisDecis (Django/DRF)

## Installation

```bash
python -m venv .venv
.\.venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

## Variables d’environnement (recommandé)

- `DJANGO_SECRET_KEY`
- `DJANGO_DEBUG` (`true`/`false`)
- `DJANGO_ALLOWED_HOSTS` (séparés par virgules)

### Admin par défaut (optionnel)

Pour créer automatiquement un admin au démarrage (après migrations):

- `CREATE_DEFAULT_ADMIN=true`
- `DEFAULT_ADMIN_EMAIL=djassikone22@gmail.com`
- `DEFAULT_ADMIN_PASSWORD=Admin@026AD!`
- `DEFAULT_ADMIN_NOM=Admin`
- `DEFAULT_ADMIN_PRENOM=AgrisDecis`

## Endpoints principaux (préfixe `/api/`)

### Auth

- `POST auth/register/` (role: `agriculteur` ou `agronome`)
- `POST auth/login/` (JWT)
- `POST auth/token/refresh/`
- `GET auth/me/`
- `GET/PATCH profile/` (dont `profile_photo` en multipart)

### Admin

- `GET admin/profile/`
- `PUT admin/profile/`
- `GET admin/users/`
- `POST admin/users/toggle/<user_id>/`
- `DELETE admin/users/delete/<user_id>/`

### Contenus / Forum / Signalements

- `GET contents/` (public)
- `POST contents/` (agronome/admin)
- `GET questions/` (public)
- `POST questions/` (agriculteur)
- `POST comments/` (auth)
- `POST reports/` (auth)
- `GET/PATCH reports/` (admin)
- `GET advices/` (public: seulement `validated`)
- `POST/PATCH/DELETE advices/` (agronome/admin)

### IA (phase 1: flux technique + stubs)

- `POST diagnostic/` (auth, upload image)
- `GET diagnostic/history/`
- `POST ai/chat/` (auth; Ollama si configuré, sinon stub)

Variables IA:
- `OLLAMA_BASE_URL` (ex: `http://localhost:11434`)
- `OLLAMA_MODEL` (ex: `llama3.1`)

### Rapports

- `POST reports/generate/` (auth, génère un rapport JSON)
- `GET reports/`

## Tests

```bash
python manage.py test
```

