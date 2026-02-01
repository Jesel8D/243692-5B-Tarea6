CREATE ROLE webapp_user WITH LOGIN PASSWORD 'rollito_password';

GRANT CONNECT ON DATABASE postgres TO webapp_user;

GRANT USAGE ON SCHEMA public TO webapp_user;

GRANT SELECT ON ALL VIEWS IN SCHEMA public TO webapp_user;
CREATE ROLE webapp_user WITH LOGIN PASSWORD 'rollito_password';

GRANT CONNECT ON DATABASE postgres TO webapp_user;

GRANT USAGE ON SCHEMA public TO webapp_user;

GRANT SELECT ON ALL VIEWS IN SCHEMA public TO webapp_user;