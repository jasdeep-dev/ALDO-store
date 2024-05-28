import { useEffect } from 'react';
import { useDispatch } from 'react-redux';
import cable from '../utils/cable';
import { updateInventoryData, addToast } from '../features/app/appSlice';

const useNotification = () => {
  const dispatch = useDispatch();

  useEffect(() => {
    const subscription = cable.subscriptions.create({
      channel: "NotificationChannel"
    }, {
      connected() {
        dispatch(addToast({ message: 'Connected to NotificationChannel', type: 'success' }));
      },
      disconnected() {
        dispatch(addToast({ message: 'Disconnected from NotificationChannel', type: 'success' }));
      },
      received(data) {
        if(data.message){
          dispatch(addToast({ message: data.message, type: 'success' }));
          return
        }
        console.log("Received data:", data, subscription);
        const store = data.store_name;
        const model = data.shoe_model;
        const inventory = data.inventory_count;

        if (!store || !model || inventory === undefined) {
          console.error('Invalid data received:', data);
          return;
        }

        dispatch(updateInventoryData({ store, model, inventory }));

        if (inventory <= 10 && inventory > 0) {
          dispatch(addToast({ message: `Less in stock: Model: ${model} in store: ${store}`, type: 'warning' }));
        }

        if (inventory <= 0) {
          dispatch(addToast({ message: `Out of Stock: Model: ${model} in store: ${store}`, type: 'error' }));
        }
      }
    });

    return () => {
      subscription.unsubscribe();
    };
  }, [dispatch]);
};

export default useNotification;
