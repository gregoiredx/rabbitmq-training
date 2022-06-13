PROJECT = rabbitmq-training

.PHONY: build
build:
	docker build -t $(PROJECT):latest .

.PHONY: run
run: build
	docker run --rm -ti -p 5672:5672 -p 15672:15672  $(PROJECT):latest

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

.PHONY: run-cluster
run-cluster: build
	docker stop $(PROJECT)-server-1 || true
	docker stop $(PROJECT)-server-2 || true
	docker network rm $(PROJECT)-network || true
	docker network create $(PROJECT)-network
	docker run -d -e RABBITMQ_NODENAME=rabbit@$(PROJECT)-server-1 --rm -p 5672:5672 -p 15672:15672 --network $(PROJECT)-network --name $(PROJECT)-server-1 $(PROJECT):latest
	sleep 5
	docker run -d -e SECONDARY_NODE=true -e RABBITMQ_NODENAME=rabbit@$(PROJECT)-server-2 --rm --network $(PROJECT)-network --name $(PROJECT)-server-2 $(PROJECT):latest


tmp:
	docker run -e SECONDARY_NODE=true --rm --network $(PROJECT)-network --name $(PROJECT)-server-2 $(PROJECT):latest
