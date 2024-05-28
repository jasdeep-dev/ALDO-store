import React from 'react';

const CollapsibleList = ({ title, icon, data, isLoading, error }) => {
  if (isLoading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <div className="collapse collapse-arrow bg-base-200">
      <input type="checkbox" />
      <div className="collapse-title text-lg font-medium">
        <div className='text-lg mx-auto ml-3 flex'>
          {icon && React.cloneElement(icon, { className: "size-5 text-base-800 my-auto pr-1" })}
          <p>{title}</p>
        </div>
      </div>
      <div className="collapse-content">
        <ul className="menu w-64 rounded-box bg-primary-800">
          {data && typeof data === 'object' && Object.entries(data).map(([key, item]) => (
            <li key={key}><button>{item.name}</button></li>
          ))}
        </ul>
      </div>
    </div>
  );
};

export default CollapsibleList;
