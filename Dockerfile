FROM rocker/r-ver:4.3.3 AS build

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.57/quarto-1.5.57-linux-amd64.deb \
    && dpkg -i quarto-1.5.57-linux-amd64.deb \
    && rm quarto-1.5.57-linux-amd64.deb

RUN pip3 install --no-cache-dir \
    jupyter \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn

WORKDIR /app
COPY . .

RUN quarto render

FROM nginx:alpine
COPY --from=build /app/_site /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
