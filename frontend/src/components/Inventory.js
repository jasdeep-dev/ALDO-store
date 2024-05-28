import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { fetchInventories, setPage, setPerPage } from '../features/app/appSlice';
import Pagination from './Pagination'

const Inventory = () => {
  const dispatch = useDispatch();
  const inventoryData = useSelector((state) => state.app.inventoryData);
  const { data, currentPage, perPage, totalPages, status, error, nextPage, prevPage } = useSelector((state) => state.app.inventory);

  const handleGetInventory = (store, model) => {
    return inventoryData[store]?.[model] || 0;
  };

  useEffect(() => {
    dispatch(fetchInventories({ page: currentPage, perPage }));
  }, [dispatch, currentPage, perPage]);

  const handlePageChange = (newPage) => {
    dispatch(setPage(newPage));
  };

  const handlePerPageChange = (event) => {
    dispatch(setPerPage(Number(event.target.value)));
  };

  if (status === 'loading') {
    return <div>Loading...</div>;
  }

  if (status === 'failed') {
    return <div>Error: {error}</div>;
  }

  return (
    <div className='my-20'>
      <p className='text-xl p-5 mt-0 w-full top-20 container mx-auto'>Inventory</p>
      <div className="overflow-x-auto">
      <div className="overflow-x-auto container mx-auto bg-red-50 rounded-lg">
        <table className="table">
          <thead>
            <tr className='bg-red-100'>
              <th>Model Name</th>
              <th>Store Name</th>
              <th>Favorite Color</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
          {data && data.map((model, index) => {
            const currentInventory = handleGetInventory(model.store_name, model.shoe_model_name) || model.inventory;
            return(
            <tr 
              key={index}
              className={(currentInventory <= 0 && "bg-red-100") || (currentInventory >= 0 && currentInventory <= 10 && "bg-orange-100") || ""}
            > 
              <td>{model.shoe_model_name}</td>
              <td>{model.store_name}</td>
              <td>
                {currentInventory}
                { (currentInventory <= 10 && currentInventory > 0) &&
                  <span className="badge badge-ghost badge-sm bg-warning">low</span>
                }
                { currentInventory === 0 &&
                  <span className="badge badge-ghost badge-sm bg-error">out of stock</span>
                }
              </td>
              <td></td>
            </tr>
            )  
          })}

          </tbody>
        </table>

          <Pagination
            currentPage={currentPage}
            totalPages={totalPages}
            nextPage={nextPage}
            prevPage={prevPage}
            onPageChange={handlePageChange}
            perPage={perPage}
            onPerPageChange={handlePerPageChange}
          />
      </div>
      </div>
    </div>
  );
};


export default Inventory;
