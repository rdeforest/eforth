Don't ask why I called this SALT. It's embarrassing.

# A thing AWS seems to need: app templates

AWS offers dozens of services which can be combined in myriad ways to create
new features, be they web sites or programatic services. Various programming
environments have app-builders which create a functional skeleton a customer
can modify to realize their vision. AWS needs something like this:

    $ aws-cli site create hello-world
    Using credentials from ~/.aws
    Creating web site using seed 'hello-world'.
    Creating infrastructure:
      Default domain for this account is 'thatsnice.org'.
      Creating minimal backing S3 bucket
      Using web site domain name 'hello-world.thatsnice.org'
      Creating API Gateway endpoints
      .. port 80
      .. creating cert
      .. port 443
    Validating site:
      http://hello-world.thatsnice.org - ok
      https://hello-world.thatsnice.org - ok
    $

But, more than that it needs to include the ability to use the same kind of
interface to plug in functionality:

    $ aws-cli site extend hello-world
    Using credentials from ~/.aws
    Using Site 'hello-world.thatsnice.org'
    > add blog
    Adding Module::Blog at http(s)://hello-world.thatsnice.org/blog
    > add forum "what is this"
    Adding Module::Forum at http(s)://hello-world.thatsnice.org/what_is_this
    > share auth with .
    Requesting shared authentication/authorization with site 'thatsnice.org'.
      Notification sent.
    The controllers of 'thatsnice.org' have been notified of your request.
    > list pending
    request sharing auth 'thatsnice.org'


