import { useToast } from "vue-toastification";
import UserAPI from "../api/user.api";
import router from "../router";
import EUserRole from "../types/EUserRole";
import Team from "../types/Team";
import User from "../types/User";
import OffLineRequests from "../api/fetcher/offLineRequests";

class UserProvider {
  private static user: User;
  private static isOnline: boolean = true;
  private static intervalID: any = undefined;

  constructor() {
    this.checkIfOnline();
    if (UserProvider.intervalID === undefined) {
      UserProvider.intervalID = setInterval(() => {
        this.checkIfOnline();
      }, 2000);
    }
    if (UserProvider.user !== undefined) {
      UserProvider.loadUserFromLS();
    } else {
      UserProvider.loadUser();
    }
  }

  private checkIfOnline = () => {
    if (UserProvider.isOnline !== navigator.onLine) {
      UserProvider.isOnline = navigator.onLine;
      let path = window.location.pathname;
      const id = UserProvider.user?.id;

      if (UserProvider.isOnline === false) {
        path = `/workingTimes/${id}`;
        useToast().error("Vous êtes hors connexion");
      } else {
        OffLineRequests.push();
      }

      router.push({
        path,
        force: true,
      });
    }
  };

  public isOnline = (): boolean => {
    return UserProvider.isOnline === true;
  };

  public isOffline = (): boolean => {
    return UserProvider.isOnline === false;
  };

  public setOnlineStatus = (status: boolean) => {
    UserProvider.isOnline = status;
    this.checkIfOnline();
  };

  public getUser = () => {
    return { ...UserProvider.user };
  };

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

  public getTeam = (): Team | undefined => {
    if (UserProvider.user.team) return UserProvider.user.team;
    else {
      UserProvider.loadUser();
      return UserProvider.user.team;
    }
  };

  public setTeam = (team: Team | undefined) => {
    UserProvider.user.team = team;
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

  public isEmployee = (): boolean =>
    UserProvider.user.roles.includes(EUserRole.EMPLOYEE);

  public isOnlyEmployee = (): boolean =>
    UserProvider.user.roles[0] === EUserRole.EMPLOYEE &&
    UserProvider.user.roles.length === 1;

  public isManager = (): boolean =>
    UserProvider.user.roles.includes(EUserRole.MANAGER);

  public isDirector = (): boolean =>
    UserProvider.user.roles.includes(EUserRole.DIRECTOR);

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
      team: userParsed.team ?? undefined,
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

  public reload = async () => {
    await UserAPI.getUserWithID(UserProvider.user.id).then((res) => {
      UserProvider.user = {
        ...res.data,
        authToken: UserProvider.user.authToken,
      };
      UserProvider.save();
    });
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
