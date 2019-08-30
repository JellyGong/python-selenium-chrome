FROM ubuntu

RUN apt-get update 

#Python 2.7 and Python Pip
RUN apt-get install -y \
    python \
    python-setuptools \
    python-pip
RUN pip install selenium

#Essential tools and xvfb
RUN apt-get install -y \
    software-properties-common \
    unzip \
    curl \
    wget \
    bzip2\
    xvfb\
    fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libcairo2 libcups2 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0\
    libpangocairo-1.0-0 libxcomposite1 libxcursor1 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 xdg-utils gconf-service libgconf-2-4 libpango1.0-0
 
#Chrome browser to run the tests
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
      && wget https://www.slimjet.com/chrome/download-chrome.php?file=files%2F76.0.3809.100%2Fgoogle-chrome-stable_current_amd64.deb -O google-chrome-browser.deb\
      && dpkg -i google-chrome-browser.deb || true
RUN apt-get install -y -f \
      && rm -rf /var/lib/apt/lists/*
 
#Disable the SUID sandbox so that chrome can launch without being in a privileged container
RUN dpkg-divert --add --rename --divert /opt/google/chrome/google-chrome.real /opt/google/chrome/google-chrome \
        && echo "#! /bin/bash\nexec /opt/google/chrome/google-chrome.real --no-sandbox --disable-setuid-sandbox \"\$@\"" > /opt/google/chrome/google-chrome \
        && chmod 755 /opt/google/chrome/google-chrome
 
#Chrome Driver
RUN mkdir -p /opt/selenium \
        && curl https://chromedriver.storage.googleapis.com/76.0.3809.126/chromedriver_linux64.zip -o /opt/selenium/chromedriver_linux64.zip \
        && cd /opt/selenium; unzip /opt/selenium/chromedriver_linux64.zip; rm -rf chromedriver_linux64.zip; ln -fs /opt/selenium/chromedriver /usr/local/bin/chromedriver;
