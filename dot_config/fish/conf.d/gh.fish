function gh_open_prs --description "List open PRs grouped by repo; supports --author, --owner, and repo filters"
    argparse 'a/author=' 'o/owner=' -- $argv
    or return

    # Default author
    set -l author "@felixjung"
    if set -q _flag_author
        set author $_flag_author
    end

    # Optional owner/org filter
    set -l owner_args
    if set -q _flag_owner
        set owner_args --owner $_flag_owner
    end

    # Remaining args = repos
    set -l repo_args
    for repo in $argv
        set repo_args $repo_args --repo $repo
    end

    gh search prs --author $author --state open $owner_args $repo_args \
        --json repository,number,title,url \
        | jq -r '
        sort_by(.repository.nameWithOwner)
        | group_by(.repository.nameWithOwner)
        | .[]
        | sort_by(.number)
        | "\u001b[1m\(.[0].repository.nameWithOwner)\u001b[0m\n"
          + (
              map(
                "  \u001b[34m#\(.number)\u001b[0m "
                + "\u001b[92m\(.title)\u001b[0m "
                + "\u001b[2m\(.url)\u001b[0m"
              )
              | join("\n")
            )
          + "\n"
    '
end
