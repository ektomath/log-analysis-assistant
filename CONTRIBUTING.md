# Contributing

This repo follows a team-style Git workflow, even though it's a solo learning project. The goal is to practise the habits used in a professional engineering team.

## 1. Plan the work in issues

- Every piece of work starts as a GitHub Issue.
- Each week of the plan is a sprint, tracked as a milestone (`Week 1`, `Week 2`, ...).
- Issues move across the project board: **To do → In progress → Review → Done**.
- An issue should be small enough to finish in a day or two. Split it if not.

## 2. Never commit directly to `main`

`main` is protected. All changes go in through a pull request and CI has to pass first.

## 3. One short-lived branch per issue

Start from an up-to-date `main`:

```bash
git switch main
git pull
git switch -c feat/12-airflow-dag
```

Branch names use `<type>/<issue-number>-<short-description>`:

| Type | Use for |
| --- | --- |
| `feat` | New functionality |
| `fix` | Bug fixes |
| `chore` | Tooling, config, dependencies |
| `docs` | Documentation only |
| `test` | Adding or fixing tests |
| `refactor` | Code changes that don't change behaviour |

## 4. Write clear commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add HDFS log parser

Parses raw HDFS lines into timestamp, level, component and message.

Refs #12
```

- Use the imperative mood ("add", not "added").
- Keep the first line under about 72 characters.
- Commit small, logical steps rather than one large commit at the end.

## 5. Open a pull request

```bash
git push -u origin feat/12-airflow-dag
```

Then open a PR on GitHub. The PR template asks for **what**, **why** and **how it was tested**. Put `Closes #12` in the description so the issue closes automatically on merge.

Before asking for review:

```bash
ruff check .
ruff format .
pytest
```

## 6. Review and merge

- CI must be green.
- At least one review (from Claude, acting as a teammate) and all comments addressed.
- Merge with **Squash and merge** so `main` gets one clean commit per PR.
- Delete the branch after merging.

## 7. Keep your branch up to date

If `main` moved while you were working:

```bash
git fetch origin
git rebase origin/main
git push --force-with-lease
```

Only force-push your own feature branches, never `main`.

## Definition of done

An issue is done when:

- the code is merged to `main`
- tests cover the main behaviour
- the README explains how to run it, if anything changed for the user
- the issue is closed and the board is updated
