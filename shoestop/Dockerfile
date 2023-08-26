FROM node:14
WORKDIR /app/Hackathon-Application/shoestop
RUN git clone https://github.com/KiruthikaES/Hackathon-Application.git /app/Hackathon-Application
COPY Hackathon-Application/shoestop/package*.json ./
RUN npm install
EXPOSE 5000
CMD ["npm", "start"]
