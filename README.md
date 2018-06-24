A elixir backend with phoenix and an elm frontend to turn on some mills using raspberry pi GPIO pins. It also streams from a camera attached to the raspberry pi.

For example:
![Example of the internet of mills in operation](mills.gif)

The dev and test environments fakes the GPIO(https://github.com/fhunleth/elixir_ale) and PiCam(https://github.com/electricshaman/picam) operations.

The prod environment works on the raspberry pi. To actually turn the mills on and off.
