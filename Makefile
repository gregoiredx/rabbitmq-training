PROJECT = rabbitmq-training

venv:
	python -m venv venv
	venv/bin/pip install -r requirements.txt

.PHONY: produce
produce: PRODUCER=producer.py
produce:
	venv/bin/python $(PRODUCER)

.PHONY: consume
consume: CONSUMER=consumer.py
consume:
	venv/bin/python $(CONSUMER)

.PHONY: stop-cluster
stop-cluster:
	docker-compose down

.PHONY: run-cluster
run-cluster: stop-cluster
	docker-compose up -d --build
	$(info After startup, you should be able to login with guest/guest on http://localhost:15672)
