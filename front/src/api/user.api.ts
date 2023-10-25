import User from "../types/User";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class UserAPI {
  public static getUser = async (): Promise<Response<User>> =>
    Fetcher.get<User>("users");

  public static createUser = async (
    email: string,
    username: string
  ): Promise<Response<User>> =>
    Fetcher.post<User>("users", { user: { email, username } });

  public static updateUser = async (
    email: string,
    username: string
  ): Promise<Response<User>> =>
    Fetcher.put<User>("users", { user: { email, username } });

  public static deleteUser = async (): Promise<Response<User>> =>
    Fetcher.delete<User>("users");

  public static login = () => {
    return {
      email: "aaa@aaa.com",
      username: "usernameTEST",
      authToken: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    };
  };
}

export default UserAPI;
