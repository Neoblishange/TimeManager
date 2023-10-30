import EUserRole from "../types/EUserRole";
import User from "../types/User";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class UserAPI {
  public static getUserWithID = async (id: string): Promise<Response<User>> =>
    Fetcher.get<User>("users/" + id);

  public static getAllUsers = async (): Promise<Response<User[]>> =>
    Fetcher.get<User[]>("/users/all");

  public static getAllManagers = async (): Promise<Response<User[]>> =>
    Fetcher.get<User[]>("/users/all").then((res) => ({
      ...res,
      data: res.data.filter(
        (user) => user.roles.length === 2 && user.roles[1] === EUserRole.MANAGER
      ),
    }));

  public static getUserWithParams = async (
    email: string,
    username: string
  ): Promise<Response<User>> =>
    Fetcher.get<User>(`users?email=${email}&username=${username}`);

  public static createUser = async (
    email: string,
    username: string,
    roles: EUserRole[] = [EUserRole.EMPLOYEE]
  ): Promise<Response<User>> =>
    Fetcher.post<User>("users", {
      user: { email, username, roles },
    });

  public static updateUser = async (
    email: string,
    username: string
  ): Promise<Response<User>> =>
    Fetcher.put<User>("users", { user: { email, username } });

  public static deleteUser = async (): Promise<Response<User>> =>
    Fetcher.delete<User>("users");

  public static login = ({
    email,
    username,
  }: {
    email: string;
    username: string;
  }) => {
    return {
      email,
      username,
      authToken: "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    };
  };
}

export default UserAPI;
