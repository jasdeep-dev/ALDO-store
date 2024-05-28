import React from 'react';

const Pagination = ({ currentPage, totalPages, nextPage, prevPage, onPageChange, perPage, onPerPageChange }) => {
  const handlePageClick = (page) => {
    onPageChange(page);
  };

  return (
    <div className="flex justify-center items-center space-x-2 mt-4">
      <label>
        Items per page:
        <select value={perPage} onChange={onPerPageChange}>
          <option value={5}>5</option>
          <option value={10}>10</option>
          <option value={20}>20</option>
        </select>
      </label>
      <button
        onClick={() => handlePageClick(prevPage)}
        disabled={!prevPage}
        className="px-3 py-1 border rounded bg-gray-200 disabled:opacity-50 hover:bg-blue-500 hover:text-white"
      >
        Previous
      </button>
      <span className="px-3 py-1">
        Page {currentPage} of {totalPages}
      </span>
      <button
        onClick={() => handlePageClick(nextPage)}
        disabled={!nextPage}
        className="px-3 py-1 border rounded bg-gray-200 disabled:opacity-50 hover:bg-blue-500 hover:text-white"
      >
        Next
      </button>
    </div>
  );
};

export default Pagination;
