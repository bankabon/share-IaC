module "snowflake" {
    source = "../modules"

    env = "TEST"
    name = "DEMO"
    snowflake_account = "test_account"
    snowflake_user = "test_user"
    snowflake_password = "test_password"

}