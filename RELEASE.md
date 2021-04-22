## Release Process

1. Create and push `release/<VERSION>` branch off of `main`.
    _This will trigger a workflow that creates a draft release on GitHub._
1. On the [GitHub releases page](https://github.com/buildpacks/pack-orb/releases):
    1. Click `Edit` on the latest _draft_ release.
    1. Review (and edit) generated changelog.
    1. Verify the _tag version_ value:
        - It should be `<VERSION>`.
        - It should "target" the `release/<VERSION>` branch.
    1. Click `Publish` release.

    _The release "Publish" action will create a tag that then triggers a workflow that additionally publishes the orb to the circleci catalog._
1. Confirm that the orb is updated by viewing the [orb page](https://circleci.com/developer/orbs/orb/buildpacks/pack).


## Makefile targets


`make future-version` - logic to determine the next version by looking at the current git branch.
`make generate-changelog` - process of generating the changelog for the `future-version`.
