# Time Manager

> Outil interne de gestion du temps

L’objectif principal de Time Manager est de centraliser la gestion du temps et des
équipes dans une solution unique, intuitive et sécurisée.

## Features

- Enregistrement automatique des arrivées et départs des employés.
  ![Futur screen](docs/screenshot.png)
- Accès à un historique des heures travaillées.
- Visualisation des plannings individuels et d’équipe.
- Accès à des rapports et indicateurs clés (KPI) pour les managers.
- Gestion des rôles et permissions (employés, managers, administrateurs).
- Authentification sécurisée.

## Getting Started

### Prerequisites

- Docker Desktop with Docker Compose
- Node.js 20+ (only required to run an application outside Docker)
- npm 10+

### Applications

- `portal/`: interface destinée aux utilisateurs.
- `backoffice/`: interface d'administration.
- `api/`: API NestJS.
- PostgreSQL et Adminer: services de base de données disponibles avec Docker Compose.

### Running With Docker (local)

From the repository root:

```bash
docker compose -f compose.dev.yml --env-file .env.development up --build -d
```

The services are then available at:

- Portal: http://localhost:3001
- Back-office: http://localhost:3000
- API: http://localhost:4000
- Adminer: http://localhost:8080
- SonarQube: http://localhost/sonarqube/

Stop the services with:

```bash
docker compose -f compose.dev.yml --env-file .env.development down
```

## Database

PostgreSQL credentials are stored in the root `.env` file.

To connect through Adminer, open http://localhost:8080 and use:

- System: `PostgreSQL`
- Server: `db`
- Username: `postgres`
- Password: `***`
- Database: `timemanager`

## Running Applications Locally

Each application has its own `package.json`. Install dependencies and start the
desired application from its directory:

```bash
cd portal       # or backoffice, or api
npm install
npm run dev     # for portal/backoffice
npm run start:dev  # for api
```

For local frontend development, use ports `3001` for the portal and `3002` for the
back-office when those ports are available. The API listens on port `3000` by
default when run outside Docker.

> For more information about running applications locally, go see :

- [Back Office NextJs Documentation](backoffice/README.md)
- [Portal NextJs Documentation](portal/README.md)
- [API NestJs Documentation](api/README.md)

## Configuration file

Create all this file before starting the project.

### Docker Compose Development

- [.env.development](.env.development.example)

### Docker Compose Development

- [.env.production](.env.production.example)

### Development

- [backoffice/.env.development](backoffice/.env.development.example)
- [portal/.env.development](portal/.env.development.example)
- [api/.env.development](api/.env.development.example)

### Production (TBD)

- [backoffice/.env.production](backoffice/.env.production.example)
- [portal/.env.production](portal/.env.production.example)
- [api/.env.production](api/.env.production.example)
