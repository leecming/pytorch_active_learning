FROM nvcr.io/nvidia/tensorflow:19.12-tf2-py3
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN rm /etc/bash.bashrc

WORKDIR /root

RUN pip install scikit-learn pandas matplotlib torch torchvision
RUN apt-get update && apt-get install -y openssh-server screen
RUN mkdir /var/run/sshd
RUN echo 'root:testdocker' | chpasswd
RUN sed -i 's/.*PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

WORKDIR /root
COPY . .

EXPOSE 22
CMD ["bash", "-c", "/usr/sbin/sshd && jupyter notebook"]