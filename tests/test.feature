Feature: curl-images

   Scenario: Run curl images

    Given running > podman run -it localhost/curl:master -V

    Given running > podman run -it localhost/curl-dev:master curl -V

    Given running > podman run -it localhost/curl-base:master curl -V

    Given running > podman run -it localhost/curl-multi:master -V

    Given running > podman run -it localhost/curl-base-multi:master curl -V
