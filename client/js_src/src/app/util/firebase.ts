import firebase from "firebase/app";
import "firebase/firestore";

firebase.initializeApp({
  apiKey: "AIzaSyAlHojK4773uV-v7aSCCQO1h59gPSNh_cE",
  authDomain: "bulletz-io.firebaseapp.com",
  databaseURL: "https://bulletz-io.firebaseio.com",
  projectId: "bulletz-io",
});

const database = firebase.firestore();

export {database};
