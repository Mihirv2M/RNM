FROM node:latest as react
WORKDIR /react-app  
COPY package.json  .
COPY package-lock.json .
RUN npm install
COPY . .
CMD [ "npm","run","build" ]  

#
# FROM nginx:1.23-alpine
# # Remove default nginx website
# RUN rm -rf /usr/share/nginx/html/*

# # Copy build output from the previous stage
# COPY --from=react /react-app/build /usr/share/nginx/html

# EXPOSE 80
# ENTRYPOINT [ "nginx","-g","daemon off;" ]
 
