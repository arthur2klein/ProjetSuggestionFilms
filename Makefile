.PHONY: front
	
front:
	docker build -t test_image -f docker/front.dockerfile .
	docker run -p 8080:80 -t test_image
