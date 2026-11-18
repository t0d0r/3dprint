# 2026-11-18 license and GitHub remote

Repository housekeeping; no part changed.

## Done

- The three parts that were only in the working tree are committed:
  kvm shelf mount, rm10 shelf hanger (with the plain variant) and
  rm10 kumiko panel, with their specs, session notes, Makefile targets
  and the saved STLs that are generated from local source only.
- `LICENSE`: BSD 2-Clause (the FreeBSD license), copyright 2026.
- Remote `origin` added: a private GitHub repository named `3dprint`.
  `main` is pushed and tracks `origin/main`.
- Before the push: `gitleaks` over the history and over the working
  tree found nothing; the history holds no local paths, addresses or
  credentials.

## Decisions

- Private repository. A public one cannot be taken back once it is
  cloned or cached, so visibility changes only after the open points
  below are settled.
- BSD 2-Clause: short, permissive, keeps only the copyright notice and
  the disclaimer.
- No third-party models in the repository. The rack mount STL that
  `scripts/rm10_shelf_hanger.scad` imports, and
  `models/rm10-shelf-hanger.stl`, which contains its sleeve, are in
  `.gitignore` and stay in the local working tree only. The first push
  contained both; the two commits were rebuilt without them and `main`
  was force-pushed. `make rm10-hanger` therefore works only where the
  rack mount STL has been placed by hand (specs/rm10-shelf-hanger.md).

## Open

- The origin of the rack mount model is not recorded in the tree; a
  fresh clone cannot build the holed hanger until it is.
- The commits of the first push are no longer on any branch, but the
  host may keep unreferenced objects for a while. Deleting and
  recreating the remote repository is the only way to purge them at
  once.
- The author address in the commits becomes visible if the repository
  is made public.
- No `README.md` yet.

## Files touched

- `LICENSE` (new)
- `.gitignore`
- `specs/rm10-shelf-hanger.md`
- `todo/todo.md`
- `session/2026-11-18-github-remote.md` (this note)

## Run and verify

- `make help` lists the targets; `make check` runs lint and tests and
  must pass before a commit.
- `git remote -v` shows `origin`; `git status -sb` shows `main` in
  sync with `origin/main`.

## Next step

Record the source of the rack mount model in
specs/rm10-shelf-hanger.md, then continue with the open print tests in
todo/todo.md.

## Security Note

The repository is private, but `specs/` and `session/` are still
treated as public source: no secrets, personal data or internal
addresses go into them. Run `gitleaks` and review `git log -p` again
before any change of visibility. Third-party files stay out of the
tree; check `git status` for new untracked models before each commit.
