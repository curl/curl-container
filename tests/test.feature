Feature: curl-images

   Scenario: Run curl images

    Given a set of container images
        | image                        |
        | localhost/curl-dev:master     |
        | localhost/curl-base:master    |
        | localhost/curl:master         |

    Then running > podman run -it {image} -V
        | output     |
        | test       |

