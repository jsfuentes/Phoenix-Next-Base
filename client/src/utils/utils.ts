import { default as axiosBase } from "axios";

import conf from "conf";

export let inProd = process.env.NODE_ENV === "production";

export const axios = axiosBase.create({
  baseURL: conf.get("SERVER_URL"),
  // withCredentials: true
  /* other custom settings */
});
