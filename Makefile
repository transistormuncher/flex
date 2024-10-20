
build_container:
	docker compose --env-file .env -f docker-compose.yaml up --build -d

load_data:
	. .venv/bin/activate && python3 data_load.py

dbt:
	docker exec -it dbt /bin/bash -c "dbt run -x"

data_test:
	docker exec -it dbt /bin/bash -c "dbt test -x"