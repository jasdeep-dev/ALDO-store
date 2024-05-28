import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { fetchShoeModels, selectShoeModels } from '../features/app/appSlice';
import CollapsibleList from './CollapsibleList';
import { BuildingStorefrontIcon } from '@heroicons/react/24/solid';

const ShoeModelList = () => {
  const dispatch = useDispatch();
  const stores = useSelector(selectShoeModels);
  const { data, isLoading, error } = stores;

  useEffect(() => {
    dispatch(fetchShoeModels());
  }, [dispatch]);

  return (
    <CollapsibleList
      title="Shoe Models"
      icon={<BuildingStorefrontIcon />}
      data={data}
      isLoading={isLoading}
      error={error}
    />
  );
};

export default ShoeModelList;
