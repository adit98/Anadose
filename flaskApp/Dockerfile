FROM frolvlad/alpine-python2

ADD app.py /

RUN pip install Flask

EXPOSE 5000

CMD ["python", "./app.py"]
