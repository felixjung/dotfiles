function gh_open_prs --description "List open PRs grouped by repo using GraphQL; supports --author, --owner, and repo filters"
    argparse 'a/author=' 'o/owner=' -- $argv
    or return

    set -l author "@felixjung"
    if set -q _flag_author
        set author $_flag_author
    end

    set -l author_name (string replace -r '^@' '' -- $author)

    set -l search_terms "is:pr state:open author:$author_name"

    # Optional owner filter
    if set -q _flag_owner
        # GitHub search supports org: and user:, but not a generic owner: qualifier.
        # For simplicity, keep this as a client-side prefix filter after fetching.
        set -l owner $_flag_owner
    else
        set -l owner ""
    end

    # Optional explicit repo filters
    for repo in $argv
        set search_terms "$search_terms repo:$repo"
    end

    gh api graphql \
        -f query='
          query($q: String!) {
            search(query: $q, type: ISSUE, first: 50) {
              nodes {
                ... on PullRequest {
									number
									title
									url
									mergeable
									mergeStateStatus
									repository {
										nameWithOwner
									}
                }
              }
            }
          }
        ' \
        -F q="$search_terms" \
        | jq -r --arg owner "$owner" '
        .data.search.nodes
        | map(select(.repository != null))
        | if ($owner | length) > 0
          then map(select(.repository.nameWithOwner | startswith($owner + "/")))
          else .
          end
        | sort_by(.repository.nameWithOwner, .number)
        | group_by(.repository.nameWithOwner)
        | .[]
        | "\u001b[1m\(.[0].repository.nameWithOwner)\u001b[0m\n"
          + (
              map(
                "  \u001b[34m#\(.number)\u001b[0m "
                + "\u001b[92m\(.title)\u001b[0m "
                + (
									if .mergeStateStatus == "CLEAN" then "\u001b[32m[mergeable]\u001b[0m "
									elif .mergeStateStatus == "HAS_HOOKS" then "\u001b[32m[mergeable]\u001b[0m "
									elif .mergeStateStatus == "UNSTABLE" then "\u001b[33m[checks]\u001b[0m "
									elif .mergeStateStatus == "BEHIND" then "\u001b[33m[behind]\u001b[0m "
									elif .mergeStateStatus == "BLOCKED" then "\u001b[31m[blocked]\u001b[0m "
									elif .mergeStateStatus == "DIRTY" then "\u001b[31m[conflicts]\u001b[0m "
									elif .mergeable == "MERGEABLE" then "\u001b[32m[mergeable]\u001b[0m "
									elif .mergeable == "CONFLICTING" then "\u001b[31m[conflicts]\u001b[0m "
									else "\u001b[2m[unknown]\u001b[0m "
									end
                  )
                + "\u001b[2m<\(.url)>\u001b[0m"
              )
              | join("\n")
            )
          + "\n"
    '
end
