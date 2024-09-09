BUILD_ARCH?=$(shell uname -m | sed 's/x86_64/amd64/')

all: binary

#vendor:
#	glide up -v

binary: #vendor
	./hack/build/build.sh ${VERSION}

release: binary
	mkdir -p _out
	cp cmd/kubevirt-template-validator/kubevirt-template-validator _out/kubevirt-template-validator-${VERSION}-linux-${BUILD_ARCH}
	hack/container/docker-push.sh ${VERSION}

clean:
	rm -f cmd/kubevirt-template-validator/kubevirt-template-validator
	rm -rf _out

unittests: binary
	go test -v ./...

functests:
	cd functests && ./test-runner.sh

tests: unittests functests


.PHONY: all vendor binary release clean unittests functests tests

