# 2026-11-18 license and GitHub remote

Repository housekeeping; no part changed.

## Done

- The three parts that were only in the working tree are committed:
  kvm shelf mount, rm10 shelf hanger (with the plain variant) and
  rm10 kumiko panel, with their specs, session notes, Makefile targets
  and the saved STLs that are generated from local source only.
- `LICENSE`: BSD 2-Clause (the FreeBSD license), copyright 2026.
- Remote `origin` added: a GitHub repository named `3dprint`, created
  private and then made public. `main` is pushed and tracks
  `origin/main`.
- `README.md`: what the project is, the parts with their build targets
  and specs, requirements, usage, layout, the third-party model rule
  and the license.
- Before the push: `gitleaks` over the history and over the working
  tree found nothing; the history holds no local paths, addresses or
  credentials.

## Decisions

- Public repository, under the BSD 2-Clause license. Publication
  cannot be taken back once the repository is cloned or cached, so
  everything committed from now on is written as public.
- `models/drawer-20cm.stl`, the input of `make drawer-swap`, is an own
  model and stays in the repository.
- The author address in the commits stays as it is and is public.
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
  host may keep unreferenced objects for a while; until it collects
  them they can be fetched by their hash. Deleting and recreating the
  remote repository is the only way to purge them at once.
- `make help` does not list the `rm10-hanger*` targets: the pattern in
  the `help` rule does not match digits in a target name.

## Files touched

- `LICENSE` (new)
- `README.md` (new)
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

The repository is public: every commit, including `specs/` and
`session/`, is readable by anyone. No secrets, personal data or
internal addresses go into them, and `gitleaks` runs before each push.
Third-party files stay out of the
tree; check `git status` for new untracked models before each commit.
