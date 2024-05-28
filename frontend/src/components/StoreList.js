import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { fetchStores, selectStores } from '../features/app/appSlice';
import CollapsibleList from './CollapsibleList';
import { BuildingStorefrontIcon } from '@heroicons/react/24/solid';

const StoreList = () => {
  const dispatch = useDispatch();
  const stores = useSelector(selectStores);
  const { data, isLoading, error } = stores;

  useEffect(() => {
    dispatch(fetchStores());
  }, [dispatch]);

  return (
    <CollapsibleList
      title="Stores"
      icon={<BuildingStorefrontIcon />}
      data={data}
      isLoading={isLoading}
      error={error}
    />
  );
};

export default StoreList;
