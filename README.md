# py-kaldi-asr: a simple Python wrapper for Kaldi ASR

This image contains Kaldi and
[py-kaldi-asr](https://github.com/gooofy/py-kaldi-asr), a simple Python
wrapper for Kaldi. It contains a sample server in /opt/asr_server that clients
can connect to to transcribe audio.

Note: This image doesn't contain a Kaldi model, which is required for
transcription. Refer to
https://quay.io/repository/mpuels/docker-py-kaldi-asr-and-model for images
that are ready for transcription.

The image is part of [Zamia Speech](https://github.com/gooofy/zamia-speech).
