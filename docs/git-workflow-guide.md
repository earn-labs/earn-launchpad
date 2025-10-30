# 🧭 Git & Workflow Guide for Earn Launchpad

This document defines the Git branching, commit, and collaboration workflow for the **Earn Launchpad** project.  
It is structured like a professional engineering workflow but lightweight enough for solo development.

---

## 📁 Branching Model

```
master                # Always production-ready code
│
└── dev             # Integration branch (feature branches merge here)
     ├── feature/backend-setup
     ├── feature/foundry-contracts
     ├── docs/mvp-scope
     └── fix/docker-compose
```

### Permanent Branches

| Branch   | Purpose |
|----------|----------|
| `master` | Stable production-ready code. Merges only from `dev`. |
| `dev`    | Integration/staging branch. All feature branches merge here first. |

### Temporary Branches

| Type | Naming pattern | Example |
|------|----------------|----------|
| Feature | `feature/<description>` | `feature/backend-setup` |
| Documentation | `docs/<description>` | `docs/mvp-scope` |
| Fix | `fix/<description>` | `fix/docker-compose` |

---

## ⚙️ Workflow Steps

### 1. Create New Branch
Each GitHub issue → one feature branch.

```bash
git checkout -b feature/backend-setup dev
```

### 2. Make Small, Clear Commits
Follow the pattern:

```
type(scope): short summary
```

#### Common Types
| Type | Meaning |
|------|----------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation |
| `refactor` | Code cleanup |
| `test` | Add or update tests |
| `ci` | Continuous integration changes |
| `chore` | Maintenance / config |

#### Examples
```
docs(mvp): add initial MVP scope draft
feat(api): implement project creation endpoint
fix(ci): correct Foundry test path in workflow
```

### 3. Push Branch and Open Pull Request (PR)

```bash
git push -u origin feature/backend-setup
```

On GitHub:
- Base branch: `dev`
- Compare branch: your feature branch
- PR title: `[Feature] Backend setup (#issue-number)`
- PR description: *what*, *why*, *how to verify*

Merge PR → into `dev`.

### 4. Merge `dev` → `master` for Releases

When a milestone is stable:

```bash
git checkout master
git merge dev
git tag -a v0.1 -m "Initial MVP structure"
git push origin master --tags
```

---

## 🏷️ Labels and Milestones

**Labels** organize issues and PRs.

| Label | Purpose |
|--------|---------|
| `feature` | New capability |
| `bug` | Fixes something broken |
| `docs` | Documentation updates |
| `infra` | Infrastructure or CI work |
| `discussion` | Open design questions |

**Milestones** group work by phase or release:

| Milestone | Example Description |
|------------|---------------------|
| `v0.1 – MVP Definition` | MVP scope, docs, and structure |
| `v0.2 – Smart Contracts` | Foundry contracts and tests |
| `v0.3 – Backend API` | REST API and DB integration |
| `v0.4 – Frontend Integration` | UI and wallet flow |

---

## 🧱 Commit History Example

```
feat(contracts): implement funding logic
test(contracts): add invariant tests
feat(api): expose /projects endpoint
docs(adr): record database decision
fix(ci): cache Foundry artifacts
```

This narrative shows your development process clearly — great for interviews and changelogs.

---

## 🔀 Visual Workflow Diagram

```
          ┌─────────────┐
          │   master      │◄─── Merge from dev (release)
          └──────┬──────┘
                 │
          ┌──────▼──────┐
          │    dev      │◄─── Merge feature branches here
          └──────┬──────┘
                 │
     ┌───────────▼────────────┐
     │ feature/backend-setup  │
     │ docs/mvp-scope         │
     │ fix/docker-compose     │
     └────────────────────────┘
```

---

## 🧩 Quick Reference

| Action | Command | Example |
|--------|----------|----------|
| Create new branch | `git checkout -b feature/api-endpoints dev` |  |
| Commit | `git commit -m "feat(api): add endpoint"` |  |
| Push | `git push -u origin feature/api-endpoints` |  |
| Merge via PR | (on GitHub) |  |
| Tag release | `git tag -a v0.1 -m "First release"` |  |

---

## 🧠 Tips for Professional Workflow

- **Never commit to `master` directly.**  
- **One issue = one branch = one PR.**  
- **Keep commits small and descriptive.**  
- **Use milestones to group related work.**  
- **Always write a short PR description (what/why/how).**  
- **Tag stable releases (`v0.1`, `v0.2`, etc.).**  
- **Treat your Git history as a story — it’s your portfolio.**

---

© Earn Labs — Git workflow guide for internal and public Launchpad repositories.
*Last updated: Oct 10, 2025*