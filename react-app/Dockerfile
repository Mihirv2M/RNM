FROM node:latest as build
WORKDIR /react-app  
COPY package.json  .
COPY package-lock.json .
RUN npm install
COPY . .
RN npm run build  


FROM nginx:alpine
# Remove default nginx website
# RUN rm -rf /usr/share/nginx/html/*

# Copy build output from the previous stage
COPY --from=build /react-app/build /usr/share/nginx/html

EXPOSE 80
ENTRYPOINT [ "nginx","-g","daemon off;" ]
 
