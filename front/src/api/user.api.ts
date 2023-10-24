import User from "@/types/User";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class UserAPI {
  public static me = async (): Promise<Response<User>> =>
    Fetcher.get<User>("me");
}

export default UserAPI;
