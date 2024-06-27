FROM node:16.20.2
WORKDIR /node-server
COPY package.json .
COPY package-lock.json .
RUN npm install
COPY . .
EXPOSE 8081
CMD [ "npm" , "start" ]
