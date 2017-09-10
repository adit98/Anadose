FROM frolvlad/alpine-python2

COPY . /app
WORKDIR /app

RUN pip install Flask

EXPOSE 5000

ENTRYPOINT ["python"]
CMD ["app.py"]
