# EARN Launchpad

> A decentralized, multi-chain platform for launching curated, high-quality token projects using the EARN token as the ecosystem's liquidity and governance backbone.

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
<!-- [![GitHub Actions](https://github.com/earn-labs/earn-launchpad/workflows/CI/badge.svg)](https://github.com/earn-labs/earn-launchpad/actions) -->

## 🚀 Overview

EARN Launchpad enables creators to launch token projects with built-in liquidity deployment and fundraising mechanisms. The platform uses the EARN token as the primary funding currency and automatically creates liquidity pools paired with EARN tokens.

### Key Features

- **Token Creation & Deployment**: Simple ERC-20 token creation with automatic liquidity pool setup
- **Fundraising Campaigns**: Vetted project submissions with contribution tracking and token distribution
- **Admin Vetting**: Review and approval system for project quality control
- **Real-time Progress Tracking**: Live funding progress and contributor analytics
- **Non-custodial Security**: All funds remain on-chain with verified contract interactions

## 🏗️ Architecture

The platform consists of three main components:

- **Frontend**: Next.js application for user interaction and project management
- **Backend**: NestJS API service with PostgreSQL database for event indexing and metadata storage
- **Smart Contracts**: Solidity contracts handling launch mechanics, fund management, and token distribution

## 📋 MVP Roadmap

### Phase 1: MVP v0 - Token Creation & Liquidity Deployment
- [x] ERC-20 token creation with metadata
- [x] Automatic liquidity pool creation (EARN pair)
- [x] Basic frontend interface
- [x] Backend event indexing

### Phase 2: MVP v1 - Fundraising Flow
- [x] Project submission system
- [x] Admin vetting workflow
- [x] Contribution mechanism using EARN tokens
- [x] Campaign progress tracking
- [x] Automatic campaign closure and token distribution

## 🛠️ Tech Stack

- **Frontend**: Next.js, React, TypeScript
- **Backend**: NestJS, PostgreSQL, GraphQL/REST API
- **Smart Contracts**: Solidity, Foundry
- **Infrastructure**: Docker Compose, GitHub Actions CI/CD
- **Blockchain**: BNB Chain (initial deployment)

## 🚦 Getting Started

### Prerequisites

- Node.js 18+
- Docker & Docker Compose
- Git

### Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/earn-labs/earn-launchpad.git
   cd earn-launchpad
   ```

2. **Set up environment**
   ```bash
   # Copy environment files
   cp .env.example .env
   
   # Install dependencies
   npm install
   ```

3. **Start development environment**
   ```bash
   # Start all services with Docker Compose
   docker-compose up -d
   
   # Run database migrations
   npm run db:migrate
   
   # Start frontend development server
   npm run dev
   ```

4. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:4000
   - API Documentation: http://localhost:4000/swagger

## 📁 Project Structure

```
earn-launchpad/
├── contracts/          # Foundry smart contracts
│   ├── src/            # Contract source files
│   ├── test/           # Contract tests
│   └── script/         # Deployment scripts
├── backend/            # NestJS API service
│   ├── src/            # API source code
│   ├── test/           # Backend tests
│   └── prisma/         # Database schema and migrations
├── frontend/           # Next.js application
│   ├── src/            # Frontend source code
│   ├── components/     # React components
│   └── pages/          # Next.js pages
├── docs/               # Documentation
│   ├── mvp-scope.md    # MVP specification
│   ├── requirements.md # Detailed requirements
│   └── adr/            # Architecture decision records
└── .github/            # GitHub workflows and templates
```

## 🎯 User Roles

| Role | Capabilities |
|------|--------------|
| **Project Creator** | Create tokens, submit launch proposals, manage campaigns |
| **Admin** | Review and vet project submissions, manage platform settings |
| **Contributor** | Fund vetted projects, claim distributed tokens, track investments |

## 🔧 Development

### Running Tests

```bash
# Smart contract tests
cd contracts && forge test

# Backend tests
cd backend && npm run test

# Frontend tests
cd frontend && npm run test

# Run all tests
npm run test:all
```

### Building for Production

```bash
# Build all components
npm run build

# Build specific component
npm run build:contracts
npm run build:backend
npm run build:frontend
```

## 🌐 Deployment

The platform is designed for deployment on BNB Chain (testnet for MVP) with the following requirements:

- EARN token contract deployed
- DEX router for liquidity pool creation
- PostgreSQL database for backend
- IPFS or similar for metadata storage

See [deployment documentation](./docs/deployment.md) for detailed instructions.

## 📊 API Documentation

The backend exposes both REST and GraphQL endpoints:

- **REST API**: OpenAPI/Swagger documentation at `/swagger`
- **GraphQL**: Playground available at `/graphql`

Key endpoints:
- `GET /projects` - List all projects
- `POST /projects` - Create new project
- `GET /projects/:id` - Get project details
- `POST /contributions` - Make contribution
- `GET /contributions/:address` - Get user contributions

## 🔒 Security

- **Non-custodial**: Platform never holds user funds or private keys
- **Verified Contracts**: All smart contracts are verified and audited
- **Event-driven**: Backend relies on blockchain events for state management
- **Rate Limiting**: API endpoints are rate-limited to prevent abuse

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](./CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📝 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

- **Documentation**: [/docs](./docs/)
- **Issues**: [GitHub Issues](https://github.com/earn-labs/earn-launchpad/issues)
- **Discussions**: [GitHub Discussions](https://github.com/earn-labs/earn-launchpad/discussions)

## 🗺️ Roadmap

### Current (MVP)
- ✅ Basic token creation and liquidity deployment
- ✅ Fundraising campaigns with admin vetting
- ✅ Real-time progress tracking

### Upcoming
- 🔄 AI-powered project vetting
- 🔄 DAO governance integration
- 🔄 Cross-chain deployment support
- 🔄 Advanced pricing curves
- 🔄 Reward and referral systems

---

**Built with ❤️ by the EARN Labs team**
