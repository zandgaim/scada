-- init-grafana-user.sql
CREATE USER grafana_user WITH PASSWORD 'grafana_pass';
GRANT CONNECT ON DATABASE scada_repo TO grafana_user;
\c scada_repo
GRANT USAGE ON SCHEMA public TO grafana_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO grafana_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO grafana_user;
