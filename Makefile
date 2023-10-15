pip-install:
	pip3 install -r requirements.in

apt-install:
	DEBIAN_FRONTEND=noninteractive apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
	  dpkg-dev \
	  fakeroot \
	  git

docker-build:
	docker-compose build --pull

build-bin:
	pyinstaller --onefile --noconfirm --distpath build/binaries --name project_deb_bin  project_deb/main.py

docker-build-bin:
	docker-compose run -u `id -u`:`id -g` app make build-bin

cleanup:
	rm build/binaries/project_deb_demo* || true
	rm -rf build/project_deb_demo || true
	rm *.spec || true

test-bin:
	docker-compose -f docker-compose-test-bin.yml up

build-deb:
	@mkdir -p package/python-deb/usr/bin
	@cp build/binaries/project_deb_bin package/python-deb/usr/bin
	@DEB_SIZE=$$(du -sk package/python-deb | cut -f1); \
	DEB_VERSION=$$(git describe --tags --always HEAD | sed 's/^v//; s/-g/./; s/-/./g'); \
	echo "DEB_SIZE=$${DEB_SIZE}"; \
	echo "DEB_VERSION=$${DEB_VERSION}"; \
	sed -i "s/{{version}}/$${DEB_VERSION}/g" package/python-deb/DEBIAN/control; \
	sed -i "s/{{size_in_kb}}/$${DEB_SIZE}/g" package/python-deb/DEBIAN/control; \
	cat package/python-deb/DEBIAN/control; \
	chmod 0755 package/python-deb/DEBIAN -R; \
	chmod 777 package/python-deb/usr/bin; \
	chmod +x package/python-deb/usr/bin; \
	dpkg-deb --build package/python-deb build/python-deb.deb


docker-build-deb:
	docker-compose run -u `id -u`:`id -g` app make build-deb

build-all:
	make build-bin
	make build-deb

docker-build-all:
	docker-compose run -u `id -u`:`id -g` app make build-all
