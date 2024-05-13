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

    get_classic_ecr_password | docker login --username=AWS --password-stdin $_flag_host

    if test $status -ne 0
        aws_sso_classic_login --profile $_flag_profile
        login_classic_ecr
    end
end

function get_rds_password
    argparse -n get_rds_password 'p/profile=' 'h/host=' 'u/username=' -- $argv
    or return
    aws --profile $_flag_profile rds generate-db-auth-token --host $_flag_host --port 5432 --username $_flag_username
end

function psql_rds
    argparse -n psql_rds 'p/profile=' 'h/host=' 'u/username=' 'd/dbname=' -- $argv
    or return
    set -l pw (get_rds_password --profile $_flag_profile --host $_flag_host --username $_flag_username)

    if test $status -ne 0
        aws_sso_login --profile sumup-classic-sso-acl
        psql_rds --host $_flag_host --profile $_flag_profile --username $_flag_username
    end

    # Root certificate taken from: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions
    psql "host=$_flag_host port=5432 user=$_flag_username sslmode=verify-full sslrootcert=/Users/felix/.aws/root-certificate.pem dbname=$_flag_dbname password=$pw"
end

# FIXME: this does not work because pgcli cannot parse the DSN when the password
# looks like a URL. Our passwords are URLs.
function pgcli_rds
    argparse -n pgcli_rds 'p/profile=' 'h/host=' 'u/username=' 'd/dbname=' -- $argv
    or return
    set -l pw (get_rds_password --profile $_flag_profile --host $_flag_host --username $_flag_username)

    echo $pw

    if test $status -ne 0
        aws_sso_login --profile sumup-classic-sso-acl
        psql_rds --host $_flag_host --profile $_flag_profile --username $_flag_username
    end

    # Root certificate taken from: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.SSL.html#UsingWithRDS.SSL.CertificatesAllRegions
    pgcli "postgres://$_flag_username:'$pw'@$_flag_host:5432/$_flag_dbname?sslmode=verify-full&sslrootcert=/Users/felix/.aws/root-certificate.pem"
end
