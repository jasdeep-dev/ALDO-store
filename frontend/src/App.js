import React from 'react';
import { Provider } from 'react-redux';
import store from './app/store';
import Header from './components/Header';
import Footer from './components/Footer';
import StoreList from './components/StoreList';
import ShoeModelList from './components/ShoeModelList';
import Inventory from './components/Inventory';
import Toasts from './components/Toasts';
import useNotification from './hooks/useNotification';
import './styles/App.css';

function App() {
  useNotification();

  return (
    <Provider store={store}>
      <div className="drawer">
        <input id="my-drawer-2" type="checkbox" className="drawer-toggle" />
        <div className="drawer-content">
          <Header notification={[]} />

          <Inventory />
          <Footer />
        </div>

        <Toasts />

        <label htmlFor="my-drawer-2" className="btn drawer-button fixed top-3 left-3">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" className="inline-block w-6 h-6 stroke-current">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 6h16M4 12h16M4 18h16"></path>
          </svg>  
        </label>

        <div className="drawer-side">
          <label htmlFor="my-drawer-2" aria-label="close sidebar" className="drawer-overlay mt-0 fixed w-full top-0"></label>
          <div className="menu p-4 w-80 min-h-full bg-base-200 text-base-content">
            <ShoeModelList />
            <StoreList />
          </div>
        </div>
      </div>
    </Provider>
  );
}

export default App;
