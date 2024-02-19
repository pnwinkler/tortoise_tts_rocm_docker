This is a quick & dirty personal project. This means you can use it as you like, but please note that I expect nothing of you, and promise nothing to you.

# What this repo does
This sets up tortoise-tts in a docker image, with the ability to use the system's AMD GPU. It works on my system (Ubuntu 22.04.3 with ROCm 5.6 installed, and AMD RX 6700 XT) as of 2024-02-19, but perhaps not yours.

# Steps
1) have ROCm >= 5.6 installed on the host machine.
2) clone this repo.
3) cd into the repo.
4) build using ```sudo docker build . --network=host -t tortoise-tts```. This might also work without the network=host bit.
5) run using this command, substituting your preferred host machine paths in ```xhost +local: && sudo docker run --rm -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /tmp/.X11-unix:/tmp/.X11-unix -v /YOUR/HOST/PATH/tortoise-tts/models:/root/.cache/tortoise/models/ -v /YOUR/HOST/PATH/tortoise-tts/output:/results -v YOUR/HOST/PATH/tortoise-tts/huggingface:/root/.cache/huggingface -e DISPLAY=${DISPLAY} tortoise-tts```
6) test GPU support is working with `python3 -c "import torch; print(torch.cuda.is_available());torch.zeros(1).cuda()"`
7) try generating something like this `python3 tortoise/do_tts.py --output_path /results --preset ultra_fast --voice angie --text "hello world"`.

## Advice
- The xhost stuff is adapted from [this DockerHub page](https://hub.docker.com/r/rocm/pytorch).
- The `-v` volume stuff (excluding the /tmp/ bit) above maps between your host machine and the docker image, so that large files can persist on your host machine between container restarts, meaning models don't have to repeatedly downloaded.
- An alternative approach is mentioned [here](https://github.com/neonbjb/tortoise-tts/discussions/670)
