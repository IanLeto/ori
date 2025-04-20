# 构建阶段
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY .. .
RUN npm run build

# 运行阶段
FROM nginx:alpine
RUN rm -rf /etc/nginx/conf.d/*
COPY default.conf /etc/nginx/conf.d/
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]