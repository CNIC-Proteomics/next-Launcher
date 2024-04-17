import React from 'react';
import ReactDOM from 'react-dom/client';
import reportWebVitals from './reportWebVitals';
// // MDB v4
// import 'bootstrap-css-only/css/bootstrap.min.css';
// import 'mdbreact/dist/css/mdb.css';
// // MDB v5
// import 'mdb-react-ui-kit/dist/css/mdb.min.css';


// icons
import "@fortawesome/fontawesome-free/css/all.min.css";
// bootstrap
import 'bootstrap/dist/css/bootstrap.min.css';
// import 'bootstrap-css-only/css/bootstrap.min.css';

// Import APP
import './index.css';
import App from './App';


const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
