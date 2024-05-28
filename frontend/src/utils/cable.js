// src/cable.js
import { createConsumer } from "@rails/actioncable";

const cable = createConsumer('ws://localhost:8000/cable');

export default cable;
