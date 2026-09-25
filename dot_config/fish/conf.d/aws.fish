function get_ecr_password
    argparse -n get_ecr_password 'p/profile=' -- $argv
    or return

    aws ecr get-login-password --profile $_flag_profile
end

function aws_sso_login
    argparse -n aws_sso_login 'p/profile=' -- $argv
    or return

    aws sso login --profile $_flag_profile
end

function login_ecr
    argparse -n login_ecr 'p/profile=' 'h/host=' -- $argv
    or return

    if get_ecr_password --profile $_flag_profile | docker login --username=AWS --password-stdin $_flag_host
        return 0
    end

    # Most likely an expired SSO session. Refresh it and try exactly once more:
    # a second failure is a real error, not something to keep retrying.
    aws_sso_login --profile $_flag_profile
    or return

    get_ecr_password --profile $_flag_profile | docker login --username=AWS --password-stdin $_flag_host
end

function get_rds_token
    argparse -n get_rds_token 'p/profile=' 'h/host=' 'u/username=' -- $argv
    or return

    aws --profile $_flag_profile rds generate-db-auth-token --host $_flag_host --port 5432 --username $_flag_username
end

function psql_rds
    argparse -n psql_rds 'p/profile=' 'h/host=' 'u/username=' 'd/dbname=' -- $argv
    or return

    set -l pw (get_rds_token --profile $_flag_profile --host $_flag_host --username $_flag_username)

    if test $status -ne 0
        # Same as above: refresh the SSO session and retry the token once.
        aws_sso_login --profile $_flag_profile
        or return

        set pw (get_rds_token --profile $_flag_profile --host $_flag_host --username $_flag_username)
        or return
    end

    # Root certificate taken from: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions
    psql "host=$_flag_host port=5432 user=$_flag_username sslmode=verify-full sslrootcert=$HOME/.aws/root-certificate.pem dbname=$_flag_dbname password=$pw"
end
