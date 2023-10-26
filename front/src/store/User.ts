import EUserRole from "../types/EUserRole";
import User from "../types/User";

class UserProvider {
  private static user: User;

  constructor() {
    if (UserProvider.user !== undefined) {
      UserProvider.loadUserFromLS();
    } else {
      UserProvider.loadUser();
    }
  }

  public getUsername = (): string => {
    if (UserProvider.user.username) return UserProvider.user.username;
    else {
      UserProvider.loadUser();
      return UserProvider.user.username;
    }
  };

  public setUsername = (username: string) => {
    UserProvider.user.username = username;
    UserProvider.save();
  };

  public getEmail = (): string => {
    if (UserProvider.user.email) return UserProvider.user.email;
    else {
      UserProvider.loadUser();
      return UserProvider.user.email;
    }
  };

  public setEmail = (email: string) => {
    UserProvider.user.email = email;
    UserProvider.save();
  };

  public getToken = (): string => {
    return UserProvider.user.authToken;
  };

  public setToken = (token: string) => {
    UserProvider.user.authToken = token;
    UserProvider.save();
  };

  public getID = (): string => {
    if (UserProvider.user.id) return UserProvider.user.id;
    else {
      UserProvider.loadUser();
      return UserProvider.user.id;
    }
  };

  public setID = (id: string) => {
    UserProvider.user.id = id;
    UserProvider.save();
  };

  public getRoles = (): EUserRole[] => {
    if (UserProvider.user.id) return UserProvider.user.roles;
    else {
      UserProvider.loadUser();
      return UserProvider.user.roles;
    }
  };

  public setRoles = (roles: EUserRole[]) => {
    UserProvider.user.roles = roles;
    UserProvider.save();
  };

  public isAuth = (): boolean => {
    return UserProvider.user.authToken.length > 10;
  };

  static loadUserFromLS = () => {
    const userLS = localStorage.getItem("user");
    const userParsed = JSON.parse(userLS ?? "{}");

    UserProvider.user = {
      id: userParsed.id ?? "",
      email: userParsed.email ?? "",
      username: userParsed.username ?? "",
      authToken: userParsed.authToken ?? "",
      roles: userParsed.roles ?? [],
    };
    return;
  };

  static loadUser = async () => {
    UserProvider.loadUserFromLS();
    const values = Object.values(UserProvider.user);

    let isMissingInfo = false;
    for (const value of values) {
      if (!isMissingInfo)
        isMissingInfo =
          value === undefined ||
          (typeof value === "string" && value.length <= 0) ||
          (typeof value === "number" && Number.isNaN(value));
    }

    // if (isMissingInfo) {
    //   UserProvider.user = {
    //     ...(await UserAPI.getUser()).data,
    //     id: "00000000000000000000000000000000000",
    //     email: "aaaaa@aaaa.com",
    //     username: "usernameTEST",
    //     authToken: UserProvider.user.authToken,
    //   };
    // }

    UserProvider.save();
  };

  private static save = () => {
    const stringUser = JSON.stringify(UserProvider.user);

    localStorage.setItem("user", stringUser);
  };

  public disconnect = () => {
    localStorage.clear();
    UserProvider.user.authToken = "";
  };
}

export default UserProvider;
