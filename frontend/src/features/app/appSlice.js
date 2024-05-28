import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import { v4 as uuidv4 } from 'uuid';

export const fetchStores = createAsyncThunk(
  'app/fetchStores',
  async (_, { rejectWithValue }) => {
    const url = `${process.env.REACT_APP_BACKEND_API}/stores`; // Replace with your actual API endpoint
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Network response was not ok');
      const data = await response.json();
      return data;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

export const fetchShoeModels = createAsyncThunk(
  'app/fetchShoeModels',
  async (_, { rejectWithValue }) => {
    const url = `${process.env.REACT_APP_BACKEND_API}/shoe_models`; // Replace with your actual API endpoint
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Network response was not ok');
      const data = await response.json();
      return data;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

export const fetchInventories = createAsyncThunk(
  'inventories/fetchInventories',
  async ({ page, perPage }, rejectWithValue) => {
    const url = `${process.env.REACT_APP_BACKEND_API}/inventories?page=${page}&per_page=${perPage}`
    try {
      const response = await fetch(url);
      if (!response.ok) throw new Error('Network response was not ok');
      const data = await response.json();
      return data;
    } catch (error) {
      return rejectWithValue(error.message);
    }
  }
);

const initialState = {
  inventoryData: {},
  inventory: {
    data: [],
    isLoading: false,
    error: null,
    currentPage: 1,
    perPage: 10,
    totalPages: 0,
    totalCount: 0,
    nextPage: 2,
    prevPage: null
  },
  notification: [],
  toasts: [],
  stores: {
    data: null,
    isLoading: false,
    error: null
  },
  shoeModels: {
    data: null,
    isLoading: false,
    error: null
  }
};

const appSlice = createSlice({
  name: 'app',
  initialState,
  reducers: {
    addMessage: (state, action) => {
      state.messages.push(action.payload);
    },
    updateInventoryData: (state, action) => {
      const { store, model, inventory } = action.payload;
      if (!state.inventoryData[store]) {
        state.inventoryData[store] = {};
      }
      state.inventoryData[store][model] = inventory;
    },
    addNotification: (state, action) => {
      state.notification.push(action.payload);
    },
    addToast: (state, action) => {
      const newToast = {
        id: uuidv4(),
        ...action.payload
      };
      state.toasts.push(newToast);
    },
    removeToast: (state, action) => {
      state.toasts = state.toasts.filter(toast => toast.id !== action.payload);
    },
    setPage: (state, action) => {
      state.inventory.currentPage = action.payload;
    },
    setPerPage: (state, action) => {
      state.inventory.perPage = action.payload;
    }
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchInventories.pending, (state) => {
        state.inventory.isLoading = true;
        state.inventory.error = null;
      })
      .addCase(fetchInventories.fulfilled, (state, action) => {
        state.inventory.data = action.payload.inventories;
        state.inventory.currentPage = action.payload.meta.current_page;
        state.inventory.nextPage = action.payload.meta.next_page;
        state.inventory.prevPage = action.payload.meta.prev_page;
        state.inventory.totalCount = action.payload.meta.total_count;
        state.inventory.totalPages = action.payload.meta.total_pages;
        state.inventory.isLoading = false;
      })
      .addCase(fetchInventories.rejected, (state, action) => {
        state.inventory.error = action.error.message;
        state.inventory.isLoading = false;
      })
      .addCase(fetchStores.pending, (state) => {
        state.stores.isLoading = true;
        state.stores.error = null;
      })
      .addCase(fetchStores.fulfilled, (state, action) => {
        state.stores.data = action.payload;
        state.stores.isLoading = false;
      })
      .addCase(fetchStores.rejected, (state, action) => {
        state.stores.error = action.error.message;
        state.stores.isLoading = false;
      })
      .addCase(fetchShoeModels.pending, (state) => {
        state.shoeModels.isLoading = true;
        state.shoeModels.error = null;
      })
      .addCase(fetchShoeModels.fulfilled, (state, action) => {
        state.shoeModels.data = action.payload;
        state.shoeModels.isLoading = false;
      })
      .addCase(fetchShoeModels.rejected, (state, action) => {
        state.shoeModels.error = action.error.message;
        state.stores.isLoading = false;
      });
  }
});

export const {
  addMessage,
  updateInventoryData,
  addNotification,
  addToast,
  removeToast,
  setPage,
  setPerPage
} = appSlice.actions;

export const selectInventoryData = (state) => state.app.inventoryData;
export const selectInventory = (state) => state.app.inventory;
export const selectStores = (state) => state.app.stores;
export const selectShoeModels = (state) => state.app.shoeModels;

export default appSlice.reducer;
