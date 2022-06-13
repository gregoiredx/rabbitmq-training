PROJECT = "rabbitmq-training"

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
