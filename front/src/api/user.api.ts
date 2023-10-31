import EUserRole from "../types/EUserRole";
import User from "../types/User";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class UserAPI {
  public static getUserWithID = async (id: string): Promise<Response<User>> =>
    Fetcher.get<User>("users/" + id);

  public static getAllUsers = async (): Promise<Response<User[]>> =>
    Fetcher.get<User[]>("/users/all").then((res) => ({
      ...res,
      data: res.data.sort((a, b) => a.username.localeCompare(b.username)),
    }));

  public static getAllManagers = async (): Promise<Response<User[]>> =>
    this.getAllUsers().then((res) => ({
      ...res,
      data: res.data.filter(
        (user) => user.roles.length === 2 && user.roles[1] === EUserRole.MANAGER
      ),
    }));

  public static getAllEmployee = async (): Promise<Response<User[]>> =>
    this.getAllUsers().then((res) => ({
      ...res,
      data: res.data.filter(
        (user) =>
          user.roles.length === 1 && user.roles[0] === EUserRole.EMPLOYEE
      ),
    }));

  public static getAllEmployeeWithoutTeam = async (): Promise<
    Response<User[]>
  > =>
    this.getAllUsers().then((res) => ({
      ...res,
      data: res.data.filter(
        (user) => user.team === undefined || user.team === null
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
    id: string,
    email: string,
    username: string
  ): Promise<Response<User>> =>
    Fetcher.put<User>(`users/${id}`, { user: { email, username } });

  public static deleteUser = async (id: string): Promise<Response<User>> =>
    Fetcher.delete<User>(`users/${id}`);

  public static setManagerUser = async (id: string): Promise<Response<User>> =>
    Fetcher.put(`users/${id}`, {
      user: {
        roles: ["employee", "manager"],
      },
    });
  public static setEmployeeUser = async (id: string): Promise<Response<User>> =>
    Fetcher.put(`users/${id}`, {
      user: {
        roles: ["employee"],
      },
    });

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
