FROM rocm/pytorch:rocm5.7_ubuntu22.04_py3.10_pytorch_2.0.1
# allow to work on 6700 XT
ENV HSA_OVERRIDE_GFX_VERSION=10.3.0

RUN apt update
RUN apt install -y python3-pip libsndfile1 wget git

RUN git clone https://github.com/neonbjb/tortoise-tts
WORKDIR tortoise-tts

RUN python -m pip install --upgrade pip
# if we didn't comment this out, then pip would replace the torch version that already comes with our image
RUN sed -i "s|torchaudio|#torchaudio|g" ./requirements.txt
# I don't know why I can't import torchaudio without including this line. Using python3 -c "import torchaudio"
RUN pip3 install torchaudio --index-url https://download.pytorch.org/whl/rocm5.7
RUN python3 -m pip --no-cache-dir install -r ./requirements.txt

RUN python3 setup.py install
