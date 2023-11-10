import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class RolesAPI {
  public static getAllRoles = async (): Promise<
    Response<{ id: string; name: string }[]>
  > => Fetcher.get<{ id: string; name: string }[]>("roles");
}

export default RolesAPI;
