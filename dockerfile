FROM node:14
WORKDIR /usr/app
COPY Package*.json .
RUN npm install
COPY . .
EXPOSE 80
CMD [ "node" , "index.js"]