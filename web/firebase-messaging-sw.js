importScripts('https://www.gstatic.com/firebasejs/8.5.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.5.0/firebase-messaging.js');

firebase.initializeApp({
    apiKey: "",
     authDomain: "localhost",
  projectId: "weather-app-4443a",
  appId: "1:31568379267:web:7be3e39a2029dd3e234ab6",
    messagingSenderId: ""
});

const messaging = firebase.messaging();