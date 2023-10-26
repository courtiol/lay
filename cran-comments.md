## Test environments

* local R installation, R 4.3.1
* GitHub Actions (usethis::use_github_action("check-standard"))
  - {os: macos-latest,   r: 'release'}
  - {os: windows-latest, r: 'release'}
  - {os: ubuntu-latest,  r: 'devel', http-user-agent: 'release'}
  - {os: ubuntu-latest,  r: 'release'}
  - {os: ubuntu-latest,  r: 'oldrel-1'}
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
