import { AxiosRequestConfig } from "axios";
import { useToast } from "vue-toastification";
import Fetcher from "./fetcher";

class OffLineRequests {
  private static requests: AxiosRequestConfig[] = [];

  constructor() {
    OffLineRequests.load();
  }

  public static add(req: AxiosRequestConfig) {
    OffLineRequests.load();
    OffLineRequests.requests.push(req);
    OffLineRequests.save();
  }

  private static save() {
    localStorage.setItem("requests", JSON.stringify(this.requests));
  }

  private static load() {
    this.requests = JSON.parse(localStorage.getItem("requests") ?? "[]");
  }

  private static clear() {
    this.requests = [];
    this.save();
  }

  public static push() {
    const reqs = [];
    for (const request of this.requests) {
      reqs.push(Fetcher.makeRequest(request));
    }
    Promise.all(reqs).then(() => {
      this.clear();
      window.location.reload();
      useToast().info("Vous êtes re-connecté");
    });
  }
}

export default OffLineRequests;
