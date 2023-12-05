default_install_migrations_task_name = "cognito_idp_rails:install:migrations"
Rake::Task[default_install_migrations_task_name].clear if Rake::Task.task_defined?(default_install_migrations_task_name)
