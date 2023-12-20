import axiosClient from "./axiosClient";

const imagesApi = {
  getAll: () => axiosClient.get("images"),
  createData: (sendData) => axiosClient.post("images", sendData),
  update: (id, sendData) => axiosClient.patch(`images/${id}`, sendData),
  delete: (id) => axiosClient.delete(`images/${id}`),
};

export default imagesApi;
