import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class RolesAPI {
  public static getAllRoles = async (): Promise<Response<IRole[]>> =>
    Fetcher.get<IRole[]>("roles");
}

export interface IRole {
  id: string;
  name: string;
}

export default RolesAPI;
