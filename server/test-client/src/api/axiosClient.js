import axios from "axios";

const axiosClient = axios.create({
  baseURL: "http://localhost:4242/api/v1",
});

export default axiosClient;
