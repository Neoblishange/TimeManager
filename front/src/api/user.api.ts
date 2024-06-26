import { jwtDecode } from "jwt-decode";
import Role from "../types/Roles";
import User, { UserLogin } from "../types/User";
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
        (user) => user.roles.length === 2 && user.roles[1] === Role.MANAGER
      ),
    }));

  public static getAllEmployee = async (): Promise<Response<User[]>> =>
    this.getAllUsers().then((res) => ({
      ...res,
      data: res.data.filter(
        (user) => user.roles.length === 1 && user.roles[0] === Role.EMPLOYEE
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
    roles: string[] = [Role.EMPLOYEE],
    password: string
  ): Promise<Response<User>> =>
    Fetcher.post<User>("users", {
      user: { email, username, roles, password },
    });

  public static login = async ({
    email,
    password,
  }: {
    email: string;
    password: string;
  }): Promise<Response<UserLogin>> =>
    Fetcher.post<UserLogin>("login", {
      email,
      password,
    }).then(async (res) => {
      const { email, id, roles, username } = jwtDecode(
        res.data.token
      ) satisfies { [key: string]: any };

      return {
        ...res,
        data: { token: res.data.token, email, id, roles, username },
      };
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
        roles: [Role.EMPLOYEE, Role.MANAGER],
      },
    });
  public static setEmployeeUser = async (id: string): Promise<Response<User>> =>
    Fetcher.put(`users/${id}`, {
      user: {
        roles: [Role.EMPLOYEE],
      },
    });
}

export default UserAPI;
