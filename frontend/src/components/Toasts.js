import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { removeToast } from '../features/app/appSlice';

const Toasts = () => {
  const toasts = useSelector((state) => state.app.toasts);
  const dispatch = useDispatch();

  useEffect(() => {
    const timers = toasts.map(toast => {
      return setTimeout(() => {
        dispatch(removeToast(toast.id));
      }, 2000); // 2 seconds
    });

    return () => {
      timers.forEach(timer => clearTimeout(timer));
    };
  }, [toasts, dispatch]);

  return (
    <div className="fixed top-5 right-5 space-y-2 w-1/4">
      {toasts.map(toast => (
        <div
          key={toast.id}
          className={`px-4 py-2 shadow-lg text-white rounded-lg ${
            toast.type === 'info' ? 'bg-blue-500' :
            toast.type === 'success' ? 'bg-green-500' :
            toast.type === 'warning' ? 'bg-orange-300' :
            toast.type === 'error' ? 'bg-red-300' : ''
          }`}
        >
          {toast.message}
        </div>
      ))}
    </div>
  );
};

export default Toasts;
