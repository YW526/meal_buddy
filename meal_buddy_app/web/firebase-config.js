// Firebase 웹 설정
const firebaseConfig = {
  apiKey: "AIzaSyA-orVolqTTCgYwo4k-uM49S0FWsgxj8CY",
  authDomain: "babuddy-1ee74.firebaseapp.com",
  projectId: "babuddy-1ee74",
  storageBucket: "babuddy-1ee74.firebasestorage.app",
  messagingSenderId: "193709824863",
  appId: "1:193709824863:web:374d3103e735e41b86f4ea",
  measurementId: "G-7SV4CD7VP6"
};

// Firebase 초기화
firebase.initializeApp(firebaseConfig);

// Firebase 서비스들 초기화
const auth = firebase.auth();
const firestore = firebase.firestore();
const storage = firebase.storage();
const analytics = firebase.analytics();

// 전역으로 Firebase 객체 노출
window.firebase = firebase;
window.auth = auth;
window.firestore = firestore;
window.storage = storage;
window.analytics = analytics;


