# TokenCare Documents — Team Git Workflow

This document explains how TokenCare team members should work with the `TokenCare/Documents` GitHub repository.

The goal is to make sure everyone can:

* Get the latest documents from GitHub
* Work independently without overwriting someone else's work
* Add or modify documentation safely
* Commit their changes
* Push their work to GitHub
* Create Pull Requests
* Synchronize their local repository
* Resolve merge conflicts when necessary

---

## 1. Repository

GitHub repository:

https://github.com/TokenCare/Documents

The repository contains documentation related to the TokenCare project.

Examples of documentation may include:

* Architecture
* FHIR
* ABDM
* Healthcare workflows
* API documentation
* Technical decisions
* Development guides
* Project specifications
* Research documents

---

# 2. Prerequisites

Every team member should have:

1. A GitHub account
2. Access to the `TokenCare/Documents` repository
3. Git installed on their computer
4. A Git client or terminal
5. A code editor such as VS Code

Check whether Git is installed:

```bash
git --version
```

Example:

```text
git version 2.x.x
```

---

# 3. Getting Repository Access

The repository owner/admin must add the team member as a collaborator.

After receiving the GitHub invitation:

1. Open the invitation
2. Accept it
3. Verify that you can access the repository
4. Clone the repository to your computer

Do not create a separate copy of the repository unless instructed to do so.

---

# 4. First-Time Setup

A team member only needs to clone the repository once.

Open a terminal and run:

```bash
git clone https://github.com/TokenCare/Documents.git
```

Then enter the repository:

```bash
cd Documents
```

Check the repository status:

```bash
git status
```

You should normally see something similar to:

```text
On branch main
Your branch is up to date with 'origin/main'.

nothing to commit, working tree clean
```

---

# 5. What `clone` Actually Does

When you run:

```bash
git clone https://github.com/TokenCare/Documents.git
```

Git downloads:

* The current files
* The Git history
* Branch information
* Repository configuration

The relationship becomes:

```text
GitHub
   |
   | git clone
   ↓
Team Member's Computer
   |
   └── Documents/
```

The local `Documents` directory is now connected to the GitHub repository.

---

# 6. Check the Remote Repository

Run:

```bash
git remote -v
```

You should see:

```text
origin  https://github.com/TokenCare/Documents.git (fetch)
origin  https://github.com/TokenCare/Documents.git (push)
```

`origin` is simply the conventional name Git gives to the remote repository.

---

# 7. Configure Git Identity

Each team member should configure their Git identity.

Run:

```bash
git config --global user.name "Your Name"
```

And:

```bash
git config --global user.email "your-email@example.com"
```

Check the configuration:

```bash
git config --global user.name
git config --global user.email
```

Use the email associated with the GitHub account when appropriate.

---

# 8. IMPORTANT: Always Synchronize Before Starting New Work

Before starting a new task, first get the latest version of `main`.

Run:

```bash
git checkout main
```

Then:

```bash
git pull origin main
```

This updates the local `main` branch with the latest changes from GitHub.

The normal workflow is:

```text
GitHub main
    ↓
git pull
    ↓
Local main
```

---

# 9. Do Not Normally Work Directly on `main`

Team members should avoid making their changes directly on `main`.

Instead, create a separate branch for each task.

Example:

```bash
git checkout -b add-fhir-documentation
```

Now the structure is conceptually:

```text
main
 |
 +---- add-fhir-documentation
```

Your changes will be made on:

```text
add-fhir-documentation
```

rather than directly on `main`.

---

# 10. Branch Naming Convention

Use clear branch names.

Recommended format:

```text
<type>/<short-description>
```

Examples:

```text
docs/fhir
docs/abdm
docs/architecture
docs/api-documentation
docs/healthcare-workflow
fix/fhir-document
update/readme
```

For example:

```bash
git checkout -b docs/fhir
```

---

# 11. Create or Modify a Document

After creating the branch, work normally.

For example:

```text
Documents/
├── README.md
├── CONTRIBUTING.md
├── FHIR.md
├── ABDM.md
└── architecture.md
```

Suppose you create:

```text
docs/FHIR.md
```

or modify:

```text
FHIR.md
```

Git will detect the changes.

Check them:

```bash
git status
```

Example:

```text
Changes not staged for commit:

    modified: FHIR.md

Untracked files:

    docs/ABDM.md
```

---

# 12. Review Your Changes

Before committing, inspect what changed.

Run:

```bash
git diff
```

This is important because it lets you verify that you are committing only the intended changes.

For a new file, you can inspect the file directly in your editor.

---

# 13. Stage the Changes

To stage a specific file:

```bash
git add FHIR.md
```

For a new file:

```bash
git add docs/ABDM.md
```

You can also stage all changes:

```bash
git add .
```

Then check:

```bash
git status
```

The files should now appear under:

```text
Changes to be committed
```

---

# 14. Commit the Changes

Create a commit:

```bash
git commit -m "Add FHIR documentation"
```

A commit is a saved point in Git history.

For example:

```text
Working files
     ↓
git add
     ↓
Staged changes
     ↓
git commit
     ↓
Local Git history
```

Important:

`git commit` does NOT upload your changes to GitHub.

---

# 15. Push the Branch to GitHub

After committing:

```bash
git push -u origin docs/fhir
```

The first push creates the remote branch.

The structure becomes:

```text
Your computer
    |
    | git push
    ↓
GitHub
    |
    └── docs/fhir
```

---

# 16. Create a Pull Request

After pushing the branch, go to GitHub.

You should see an option to create a Pull Request.

Create:

```text
docs/fhir
     ↓
   main
```

The Pull Request should explain:

### What was changed?

Example:

```text
Added initial FHIR documentation.
```

### Why was it changed?

Example:

```text
We need a common reference for the FHIR resources used by TokenCare.
```

### What should the reviewer check?

Example:

```text
Please verify the FHIR resource descriptions and examples.
```

---

# 17. Pull Request Review

Another team member can review the changes.

The reviewer can:

* Read the changes
* Comment on specific lines
* Request changes
* Approve the Pull Request

After approval, the branch can be merged into `main`.

The final workflow becomes:

```text
Developer
    |
    ↓
Create branch
    |
    ↓
Make changes
    |
    ↓
Commit
    |
    ↓
Push
    |
    ↓
Pull Request
    |
    ↓
Review
    |
    ↓
Merge
    |
    ↓
main
```

---

# 18. After the Pull Request Is Merged

After your Pull Request is merged, update your local `main`.

First switch to `main`:

```bash
git checkout main
```

Then pull:

```bash
git pull origin main
```

Your local repository is now synchronized with GitHub.

---

# 19. Starting Your Next Task

Every new task should start from the latest `main`.

Use:

```bash
git checkout main
git pull origin main
```

Then create a new branch:

```bash
git checkout -b docs/new-document
```

Work on the new task.

Then:

```bash
git add .
git commit -m "Add new document"
git push -u origin docs/new-document
```

Create a Pull Request.

---

# 20. Complete Example

Suppose a team member needs to add ABDM documentation.

### Step 1 — Update main

```bash
git checkout main
git pull origin main
```

### Step 2 — Create a branch

```bash
git checkout -b docs/abdm
```

### Step 3 — Create the document

Create:

```text
ABDM.md
```

### Step 4 — Check changes

```bash
git status
```

### Step 5 — Review changes

```bash
git diff
```

### Step 6 — Stage

```bash
git add ABDM.md
```

### Step 7 — Commit

```bash
git commit -m "Add ABDM documentation"
```

### Step 8 — Push

```bash
git push -u origin docs/abdm
```

### Step 9 — Create Pull Request

On GitHub:

```text
docs/abdm → main
```

### Step 10 — Review and merge

After approval, merge the Pull Request.

### Step 11 — Synchronize local main

```bash
git checkout main
git pull origin main
```

Done.

---

# 21. What If Another Team Member Has Already Changed `main`?

Suppose:

```text
You                 Teammate
 |                      |
 |---- work ------------|
 |                      |
 |                  Pull Request
 |                      |
 |                  merge to main
 |
```

Your local `main` may now be outdated.

Before creating another branch:

```bash
git checkout main
git pull origin main
```

This is why team members should regularly synchronize with `main`.

---

# 22. What If There Is a Merge Conflict?

A conflict can occur when two people modify the same part of the same file.

Example:

```text
You:
FHIR.md

Teammate:
FHIR.md
```

Both modify the same section.

Git may report:

```text
CONFLICT (content): Merge conflict in FHIR.md
```

Open the file.

You may see:

```text
<<<<<<< HEAD
Your version
=======
Teammate's version
>>>>>>> other-branch
```

Decide which content should remain.

Remove the conflict markers:

```text
<<<<<<<
=======
>>>>>>>
```

Then stage the resolved file:

```bash
git add FHIR.md
```

Commit:

```bash
git commit -m "Resolve FHIR documentation conflict"
```

Then continue with the appropriate push/PR workflow.

---

# 23. Important Rule for Documentation

If two people are likely to work on the same document, divide the work whenever possible.

For example, instead of everyone modifying:

```text
FHIR.md
```

use:

```text
docs/
├── fhir/
│   ├── overview.md
│   ├── patient.md
│   ├── observation.md
│   └── encounter.md
```

This reduces merge conflicts.

---

# 24. Recommended TokenCare Documentation Structure

As the repository grows, a structure like this can be used:

```text
Documents/
│
├── README.md
├── CONTRIBUTING.md
│
├── architecture/
│   ├── overview.md
│   ├── system-architecture.md
│   └── workflows.md
│
├── healthcare/
│   ├── fhir/
│   │   ├── overview.md
│   │   ├── patient.md
│   │   ├── encounter.md
│   │   ├── observation.md
│   │   └── medication.md
│   │
│   ├── abdm/
│   │   ├── overview.md
│   │   ├── consent.md
│   │   └── health-information-exchange.md
│   │
│   └── dicom/
│       └── overview.md
│
├── api/
│   ├── authentication.md
│   └── endpoints.md
│
└── decisions/
    ├── README.md
    └── architecture-decisions.md
```

This is only a suggested structure. Change it according to the actual TokenCare project.

---

# 25. Commit Message Convention

Use short and meaningful commit messages.

Recommended:

```text
Add FHIR overview
Add ABDM consent documentation
Update patient resource documentation
Fix FHIR example
Update architecture diagram
Add healthcare workflow
```

Avoid messages such as:

```text
update
changes
final
new
test
asdf
```

A commit message should explain what changed.

---

# 26. Useful Git Commands

### Check current branch

```bash
git branch
```

### Check repository status

```bash
git status
```

### See branches

```bash
git branch
```

### Create a branch

```bash
git checkout -b branch-name
```

### Switch branches

```bash
git checkout branch-name
```

### Get latest changes

```bash
git pull origin main
```

### See changes

```bash
git diff
```

### Stage a file

```bash
git add filename.md
```

### Stage everything

```bash
git add .
```

### Commit

```bash
git commit -m "Description of changes"
```

### Push

```bash
git push -u origin branch-name
```

### See commit history

```bash
git log --oneline
```

---

# 27. The Golden Workflow

For TokenCare team members, remember this workflow:

```text
START
  |
  ↓
git checkout main
  |
  ↓
git pull origin main
  |
  ↓
git checkout -b <new-task>
  |
  ↓
Make changes
  |
  ↓
git status
  |
  ↓
git diff
  |
  ↓
git add .
  |
  ↓
git commit -m "Meaningful message"
  |
  ↓
git push -u origin <new-task>
  |
  ↓
Create Pull Request
  |
  ↓
Review
  |
  ↓
Merge into main
  |
  ↓
git checkout main
  |
  ↓
git pull origin main
  |
  ↓
DONE
```

---

# 28. Rules for the TokenCare Team

1. Do not directly modify `main` unless specifically authorized.
2. Create a branch for each task.
3. Pull the latest `main` before starting new work.
4. Keep commits small and meaningful.
5. Review your changes before committing.
6. Do not commit passwords, API keys, tokens, or other secrets.
7. Create a Pull Request for review.
8. Do not force-push shared branches unless the team explicitly agrees.
9. Keep documentation organized by topic.
10. Pull the latest `main` before beginning the next task.

---

# 29. Quick Reference

For a new team member:

```bash
git clone https://github.com/TokenCare/Documents.git
cd Documents
```

For a new task:

```bash
git checkout main
git pull origin main
git checkout -b docs/my-task
```

After making changes:

```bash
git status
git diff
git add .
git commit -m "Describe the changes"
git push -u origin docs/my-task
```

Then:

```text
GitHub
  ↓
Create Pull Request
  ↓
Review
  ↓
Merge
```

After merging:

```bash
git checkout main
git pull origin main
```

This is the standard workflow to follow for the TokenCare Documents repository.
