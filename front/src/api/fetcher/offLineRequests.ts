import { AxiosRequestConfig } from "axios";
import Fetcher from "./fetcher";

class OffLineRequests {
  private static requests: AxiosRequestConfig[] = [];

  constructor() {
    OffLineRequests.load();
  }

  public static add(req: AxiosRequestConfig) {
    OffLineRequests.requests.push(req);
    OffLineRequests.save();
  }

  private static save() {
    localStorage.setItem("requests", JSON.stringify(this.requests));
  }

  private static load() {
    this.requests = JSON.parse(localStorage.getItem("requests") ?? "[]");
  }

  public static push() {
    for (const request of this.requests) {
      Fetcher.makeRequest(request);
    }
  }
}

export default OffLineRequests;
